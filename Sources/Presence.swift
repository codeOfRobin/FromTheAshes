//
//  Presence.swift
//  FromTheAshes
//
//  Created by Robin Malhotra on 20/02/17.
//  Copyright © 2017 FromTheAshes. All rights reserved.
//

import Foundation

struct Presence {
	typealias Meta = [String: Any]
	typealias PresenceState = [String: [Meta]]
	typealias Diff = [String: [Meta]]
	
	var state: PresenceState
	
	var onJoin: ((_ id: String, _ meta: Meta) -> Void)?
	var onLeave: ((_ id: String, _ meta: Meta) -> Void)?
	var onStateChange: ((PresenceState) -> ())?
	
	
	init(state: PresenceState) {
		self.state = state
	}
	
}
