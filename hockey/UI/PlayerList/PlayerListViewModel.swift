//
//  PlayerListViewModel.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation

protocol PlayerListViewModelDelegate: ErrorReceivableDelegate {
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
	
	func sortPlayers(players: [Player], by sortMethod: Sorter) -> [Player] {
		var sortedPlayers = players
		
		switch sortMethod {
			// Sort by name
			case .name:
				sortedPlayers.sort { (player1, player2) -> Bool in
					player1.person.fullName < player2.person.fullName
			}
			
			// Sort by jersey number
			case .jersey:
				sortedPlayers.sort { (l, r) -> Bool in
					let lInt = Int(l.jerseyNumber)
					let rInt = Int(r.jerseyNumber)
					return lInt! < rInt!
				}
		}
		
		return sortedPlayers
	}
	
	
	/// Filters through the given [Player] with a given string
	/// - Parameters:
	///   - players: List of players to filter
	///   - filterString: The filter string
	func filterPlayers(players: [Player], with filterString: String) -> [Player]{
		return players.filter({$0.position.abbreviation.contains(filterString.uppercased())})
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
					self?.delegate?.didReceiveError("Could not fetch players")
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
					self?.delegate?.didReceiveError("Could not fetch player's info")
			}
			
		}
	}
}
