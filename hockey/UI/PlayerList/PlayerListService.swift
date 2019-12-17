//
//  PlayerListService.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation

struct PlayerListResponseObject: Decodable {
	let roster: [Player]
}

protocol PlayerListServiceProtocol {
	func fetchPlayers(for teamId: String, completion: @escaping (Result<PlayerListResponseObject>) -> Void)
}

class PlayerListService: APIClient {
	var session: URLSession
	
	init(configuration: URLSessionConfiguration = .default) {
		self.session = URLSession(configuration: configuration)
	}
}

extension PlayerListService: PlayerListServiceProtocol {
	func fetchPlayers(for teamId: String, completion: @escaping (Result<PlayerListResponseObject>) -> Void) {
		guard let url = URL(string: Constants.baseURL + Endpoints.teams + "/\(teamId)/roster") else {
			completion(.failure)
			return
		}
		
		let request = URLRequest(url: url)
		fetch(with: request, decode: {$0 as? PlayerListResponseObject ?? nil}, completion: completion)
	}
}
