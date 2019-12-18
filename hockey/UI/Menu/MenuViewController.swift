//
//  MenuViewController.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
	func didSelectTeam(team: Team)
}

class MenuViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	// MARK: - Properties
	private let viewModel = MenuViewModel()
	private lazy var dataSource : MenuDataSource = MenuDataSource()
	weak var delegate : MenuViewControllerDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupTableView()
		// Bind to MenuViewModel protocol in order to perform UI updates
		viewModel.bind(to: self)
		// Fetch the hockey teams from API
		viewModel.fetchTeams()
    }
	
	
	// MARK: - Private
	/// Sets the tableView datasource and delegate
	private func setupTableView() {
		tableView.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
		tableView.dataSource = dataSource
		tableView.delegate = dataSource
		dataSource.delegate = self
	}
}

extension MenuViewController: MenuViewModelDelegate {
	/// Updates the datasource with the data received from the API call
	/// > Called by MenuViewModel after successful response from API
	/// - Parameter teams: An array of the Team objects that will be displayed in the UI
	func didFetchTeams(_ teams: [Team]) {
		self.dataSource.data = teams
		tableView.reloadData()
	}
}

extension MenuViewController: MenuDataSourceDelegate {
	
	/// Tell PlayerListViewController that a team was selected and the Menu is hidden now
	/// - Parameter team: The Team object that will populate PlayerListViewController's tableView UI
	func didSelectTeam(team: Team) {
		dismiss(animated: true) { [weak self] in
			self?.delegate?.didSelectTeam(team: team)
		}
	}
}
