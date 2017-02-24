//
//  Socket+Heartbeat.swift
//  FromTheAshes
//
//  Created by Robin Malhotra on 21/02/17.
//  Copyright © 2017 FromTheAshes. All rights reserved.
//

import Starscream
//: Heartbeat BS

extension Socket: WebSocketDelegate {
	
	func sendHeartbeat() {
		guard self.isConnected else {
			return
		}
		
		let ref = self.heartBeatPrefix + UUID().uuidString
		let heartbeatPush = Push(event: .heartbeat, topic: "phoenix", payload: [:], ref: ref)
		send(message: heartbeatPush)
		queueHeartBeat()
	}
	
	func queueHeartBeat() {
		let deadline = DispatchTime.now() + .seconds(heartBeatInterval)
		heartBeatQueue.asyncAfter(deadline: deadline) { [weak self] in
			self?.sendHeartbeat()
		}
	}
	
	public func websocketDidConnect(socket: WebSocket) {
		onConnect?()
		print("connected")
		queueHeartBeat()
	}
	
	public func websocketDidReceiveData(socket: WebSocket, data: Data) {
		print(String(data: data, encoding: .utf8))
	}
	
	public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
		print(error)
	}
	
}
