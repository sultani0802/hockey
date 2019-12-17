//
//  MenuService.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation

struct MenuResponseObject: Decodable {
	let teams: [Team]
}

protocol MenuServiceProtocol {
	func fetchTeams(completion: @escaping (Result<MenuResponseObject>) -> Void)
}


class MenuService: APIClient {
	var session: URLSession
	
	init(configuration: URLSessionConfiguration = .default) {
		self.session = URLSession(configuration: configuration)
	}
}

extension MenuService: MenuServiceProtocol {
	func fetchTeams(completion: @escaping (Result<MenuResponseObject>) -> Void) {
		guard let url = URL(string: Constants.baseURL + Endpoints.teams) else {
			completion(.failure)
			return
		}
		
		let request = URLRequest(url: url)
		fetch(with: request, decode: {$0 as? MenuResponseObject ?? nil}, completion: completion)
	}
}
