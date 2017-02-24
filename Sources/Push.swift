//
//  Push.swift
//  FromTheAshes
//
//  Created by Robin Malhotra on 20/02/17.
//  Copyright © 2017 FromTheAshes. All rights reserved.
//

import Foundation


public struct Push {
	let event: Event
	let topic: String
	let payload: [String: Any]
	let ref: String
	
	var callbacks: [String: [([String:Any]) -> Void]] = [:]
	
	func toJSON() throws -> Data {
		let dict = [
			"topic": topic,
			"event": event.rawValue,
			"payload": payload,
			"ref": ref ?? ""
		] as [String : Any]
		
		return try JSONSerialization.data(withJSONObject: dict, options: [])
	}
	
	init(event: Event, topic: String, payload: [String: Any], ref: String) {
		(self.topic, self.event, self.payload, self.ref) = (topic, event, payload, ref)
	}
	
	mutating func receive(status: String, callback: @escaping ([String: Any]) -> Void) -> Push {
		callbacks[status]?.append(callback)
		return self
	}
	
	func handle(response: Response) {
		if let callbacks = callbacks[response.ref] {
			callbacks.forEach{ $0(response.payload) }
		}
	}
}
