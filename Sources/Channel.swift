//
//  Channel.swift
//  FromTheAshes
//
//  Created by Robin Malhotra on 07/02/17.
//  Copyright © 2017 FromTheAshes. All rights reserved.
//

import Foundation

enum ChannelState: String {
	case closed
	//: lol
	case error
	case joined
	case joining
	case leaving
}

public struct Channel {
	
	let topic: String
	var state: ChannelState = .closed
	
	weak var socket: Socket?
	
	init(topic: String, socket: Socket?) {
		self.topic = topic
		self.socket = socket
		self.state = .closed
	}
	
	public mutating func join(payload: [String: Any]) -> Push? {
		state = .joining
		let ref = UUID().uuidString + "join: \(topic)"
		return socket?.send(event: .join, topic: topic, payload: payload, ref: ref)
	}
	
	public mutating func leave() -> Push? {
		state = .leaving
		let ref = UUID().uuidString + "join: \(topic)"
		return socket?.send(event: .leave, topic: topic, payload: [:], ref: ref)
	}
}
