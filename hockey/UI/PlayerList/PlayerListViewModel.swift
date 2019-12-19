//
//  PlayerListViewModel.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation

protocol PlayerListViewModelDelegate: class {
	func didFetchPlayers(players: [Player])
	func didFetchPlayerDetails(playerDetail: PlayerDetail)
}

class PlayerListViewModel {
	
	// MARK: - Properties
	var team: Team!
	private var service: PlayerListService
	private weak var delegate: PlayerListViewModelDelegate?
	
	init(team: Team, service: PlayerListService = PlayerListService()) {
		self.team = team
		self.service = service
	}
	
	func bind(to delegate: PlayerListViewModelDelegate) {
		self.delegate = delegate
	}
	
	func sortPlayers(players: inout [Player], by sortMethod: Sorter) {
		let num : [Int] = players.map({Int($0.jerseyNumber)!})
		
		switch sortMethod {
			case .name:
				players.sort { (player1, player2) -> Bool in
					player1.person.fullName < player2.person.fullName
			}
			
			case .jersey:
				print(players.map({$0.jerseyNumber}))
				players.sort { (l, r) -> Bool in
					let lInt = Int(l.jerseyNumber)
					let rInt = Int(r.jerseyNumber)
					return lInt! < rInt!
				}
				print(players.map({$0.jerseyNumber}))
		}
	}
	
	
	/// Fetch the players on a team
	/// > Uses the Team instance to make API request
	func fetchPlayers() {
		let id = String(self.team.id)
		
		service.fetchPlayers(for: id) { [weak self] (result) in
			switch result {
				case .success(let playerListResponse):
					let players = playerListResponse.roster
					self?.delegate?.didFetchPlayers(players: players)
				
				case .failure:
					print("failed to fetch players")
			}
		}
	}
	
	/// Fetch more details about the player
	/// - Parameter player: The Player object that we want more info on
	func fetchPlayerDetails(player: Player) {
		let id = String(player.person.id)
		
		service.fetchPlayerDetail(for: id) { [weak self] (result) in
			switch result {
				
				case .success(let response):
					let playerDetail = response.people[0]
					self?.delegate?.didFetchPlayerDetails(playerDetail: playerDetail)
				
				case .failure:
					print("failed to fetch player detail")
			}
			
		}
	}
}
