//
//  URL+Params.swift
//  FromTheAshes
//
//  Created by Robin Malhotra on 20/02/17.
//  Copyright © 2017 FromTheAshes. All rights reserved.
//

import Foundation

extension URL {
	func add(params: [String: String]) -> URL {
		let queryItems: [URLQueryItem] = params.map{ URLQueryItem(name: $0, value: $1) }
		guard var components = URLComponents.init(url: self, resolvingAgainstBaseURL: false) else { fatalError("components not built") }
		components.queryItems = queryItems
		guard let url = components.url else { fatalError() }
		return url
	}
}
