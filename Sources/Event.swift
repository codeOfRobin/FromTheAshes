//
//  Event.swift
//  FromTheAshes
//
//  Created by Robin Malhotra on 20/02/17.
//  Copyright © 2017 FromTheAshes. All rights reserved.
//

import Foundation

enum Event: String {
	case heartbeat = "heartbeat"
	case join = "phx_join"
	case leave = "phx_leave"
	case reply = "phx_reply"
	case error = "phx_error"
	case close = "phx_close"
}
