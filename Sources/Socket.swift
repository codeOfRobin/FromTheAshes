//
//  Socket.swift
//  FromTheAshes
//
//  Created by Robin Malhotra on 07/02/17.
//  Copyright © 2017 FromTheAshes. All rights reserved.
//

import Foundation
import Starscream


public class Socket {
	public let socket: WebSocket
	
	var channels: [String: Channel] = [:]
	
	public var onConnect: (() -> Void)?
	public var onDisconnect: ((Error) -> Void)?
	
	let heartBeatInterval = 30
	let heartBeatPrefix = "hb-"
	let heartBeatQueue = DispatchQueue(label: "com.codeOfRobin.FromTheAshes.hbqueue")
	
	var waitingForResponses: [String: Push] = [:]
	
	var isConnected: Bool {
		return socket.isConnected
	}
	
	public init(url: URL, params: [String: String]) {
		let url = url.add(params: params)
		self.socket = WebSocket(url: url)
		socket.delegate = self
	}
	
	func send(event: Event, topic: String, payload: [String: Any], ref: String) -> Push {
		let push = Push(event: event, topic: topic, payload: payload, ref: ref)
		print(push)
		waitingForResponses[ref] = push
		return send(message: push)
	}
	
	@discardableResult func send(message: Push) -> Push {
		do {
			let data = try message.toJSON()
			waitingForResponses[message.ref] = message
			socket.write(data: data)
		} catch {
			print(error)
		}
		return message
	}
	
	public func connect() {
		if socket.isConnected {
			return
		}
		print("connecting to \(socket.currentURL)")
		socket.connect()
	}
	
	public func disconnect() {
		if !socket.isConnected {
			return
		}
		socket.disconnect()
	}
	
	public func channel(topic: String) -> Channel {
		let channel = Channel(topic: topic, socket: self)
		channels[topic] = channel
		return channel
	}
	
	public func removeChannel(with topic: String) {
		if var channel = channels.removeValue(forKey: topic) {
			channel.leave()
		}
	}
	
	public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
		if let data = text.data(using: .utf8),
			let response = Response(data: data),
			let push = waitingForResponses[response.ref] {
			push.handle(response: response)
		}
		
	}
}

