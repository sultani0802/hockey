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

struct PlayerDetailResponseObject: Decodable {
	let people: [PlayerDetail]
}

protocol PlayerListServiceProtocol {
	func fetchPlayers(for teamId: String, completion: @escaping (Result<PlayerListResponseObject>) -> Void)
	func fetchPlayerDetail(for playerId: String, completion: @escaping (Result<PlayerDetailResponseObject>) -> Void)
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
	
	func fetchPlayerDetail(for playerId: String, completion: @escaping (Result<PlayerDetailResponseObject>) -> Void) {
		guard let url = URL(string: Constants.baseURL + Endpoints.people + "/\(playerId)") else {
			completion(.failure)
			return
		}
		
		let request = URLRequest(url: url)
		fetch(with: request, decode: {$0 as? PlayerDetailResponseObject ?? nil}, completion: completion)
	}
}
