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
}
