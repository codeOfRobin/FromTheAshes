//
//  Response.swift
//  FromTheAshes
//
//  Created by Robin Malhotra on 24/02/17.
//  Copyright © 2017 FromTheAshes. All rights reserved.
//

import Foundation

struct Response {
	let ref: String
	let topic: String
	let event: String
	let payload: [String: Any]
	
	init?(data: Data) {
		do {
			guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
				let ref = json["ref"] as? String,
				let topic = json["topic"] as? String,
				let event = json["event"] as? String,
				let payload = json["payload"] as? [String: Any]
				else { return nil }
			
			self.ref = ref
			self.topic = topic
			self.event = event
			self.payload = payload
			
		} catch {
			return nil
		}
	}
}
