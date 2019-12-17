//
//  MenuViewModel.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation

protocol MenuViewModelDelegate: class {
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
	
	func fetchTeams() {
		service.fetchTeams(completion: { [weak self] (result) in
			switch result {
				case .success(let menuResponse):
					let teams = menuResponse.teams
					self?.delegate?.didFetchTeams(teams)
				case .failure:
					print("failed to fetch teams")
			}
			
		})
	}
}
