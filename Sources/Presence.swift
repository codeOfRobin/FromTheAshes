//
//  Presence.swift
//  FromTheAshes
//
//  Created by Robin Malhotra on 20/02/17.
//  Copyright © 2017 FromTheAshes. All rights reserved.
//

import Foundation

struct Presence {
	typealias PresenceState = [String: [[String: Any]]]
	typealias Diff = [String: [String: Any]]
	
	var state: PresenceState
	
	var onJoin: ((_ id: String, _ meta: [String: Any]) -> Void)?
	var onLeave: ((_ id: String, _ meta: [String: Any]) -> Void)?
	var onStateChange: ((PresenceState) -> ())?
	
	
	init(state: PresenceState) {
		self.state = state
	}
	
	mutating func sync(diff: Response) {
		// Initial state event
		if diff.event == "presence_state" {
			diff.payload.forEach{ id, entry in
				if let entry = entry as? [String: Any] {
					if let metas = entry["metas"] as? [[String: Any]] {
						state[id] = metas
					}
				}
			}
		}
		else if diff.event == "presence_diff" {
			if let leaves = diff.payload["leaves"] as? Diff {
				syncLeaves(leaves)
			}
			if let joins = diff.payload["joins"] as? Diff {
				syncJoins(joins)
			}
		}
		
		onStateChange?(state)
	}
	
	mutating func syncLeaves(_ diff: Diff) {
		defer {
			diff.forEach { id, entry in
				if let metas = entry["metas"] as? [[String: Any]] {
					metas.forEach { onLeave?(id, $0) }
				}
			}
		}
		
		for (id, entry) in diff where state[id] != nil {
			guard var existing = state[id] else {
				continue
			}
			
			// If there's only one entry for the id, just remove it.
			if existing.count == 1 {
				state.removeValue(forKey: id)
				continue
			}
			
			// Otherwise, we need to find the phx_ref keys to delete.
			let metas = entry["metas"] as? [[String: Any]]
			if let refsToDelete = metas?.flatMap({ $0["phx_ref"] as? String }) {
				existing = existing.filter {
					if let phxRef = $0["phx_ref"] as? String {
						return !refsToDelete.contains(phxRef)
					}
					
					return true
				}
				state[id] = existing
			}
		}
	}
	
	mutating func syncJoins(_ diff: Diff) {
		diff.forEach { id, entry in
			if let metas = entry["metas"] as? [[String: Any]] {
				if var existing = state[id] {
					existing += metas
				}
				else {
					state[id] = metas
				}
				
				metas.forEach { onJoin?(id, $0) }
			}
		}
	}

	
}
