//
//  MenuViewModel.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation

protocol MenuViewModelDelegate: ErrorReceivableDelegate {
	func didFetchTeams(_ teams: [Team])
}

class MenuViewModel {
	private let service: MenuService
	private weak var delegate: MenuViewModelDelegate?
	
	init(service: MenuService = MenuService()) {
		self.service = service
	}
	
	func bind(to delegate: MenuViewModelDelegate) {
		self.delegate = delegate
	}
	
	/// Fetch the teams from the API
	func fetchTeams() {
		service.fetchTeams(completion: { [weak self] (result) in
			switch result {

				case .success(let menuResponse):
					// Get the response, sort it, and send it to the UI via delegate
					var teams = menuResponse.teams
					teams.sort(by: {$0.name < $1.name})
					self?.delegate?.didFetchTeams(teams)
				
				case .failure:
					self?.delegate?.didReceiveError("Could not fetch teams")
			}
		})
	}
}
