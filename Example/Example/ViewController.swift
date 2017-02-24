//
//  ViewController.swift
//  Example
//
//  Created by Robin Malhotra on 20/02/17.
//  Copyright © 2017 FromTheAshes. All rights reserved.
//

import UIKit
import FromTheAshes

class ViewController: UIViewController {

	var socket = Socket(url: URL(string: "http://localhost:4000/socket/websocket")!, params: ["user_id": "asdf"])
	var channel: Channel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		

		socket.onConnect = { [weak self] in
			self?.channel = self?.socket.channel(topic: "rooms:lobby")
			self?.channel?.join(payload: ["user": "asdf"])
		}
		
		socket.connect()
		

		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

