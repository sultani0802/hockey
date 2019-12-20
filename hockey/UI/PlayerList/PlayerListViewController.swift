//
//  ViewController.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit
import SideMenu

class PlayerListViewController: UIViewController, SpinnerProtocol, ErrorReceivableDelegate {

	// MARK: - UI Elements
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var teamsBarButtonItem: UIBarButtonItem!
	@IBOutlet weak var sortBarButtonItem: UIBarButtonItem!
	@IBOutlet weak var searchBar: UISearchBar!
	
	
	// MARK: - Properties
	private let viewModel: PlayerListViewModel = PlayerListViewModel(team: Team(id: 1, name: "Team", teamName: "Team Name"))
	private lazy var dataSource: PlayerListDataSource = PlayerListDataSource(delegate: self)
	private let storyBoard = UIStoryboard(name: "Main", bundle: nil)
	
	
	// MARK: - Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupTableView()
		setupMenuView()
		viewModel.bind(to: self)
	}
	
	
	// MARK: - Private
	private func setupTableView() {
		searchBar.delegate = self
		searchBar.returnKeyType = .done
		
		tableView.register(UINib(nibName: "PlayerListCell", bundle: nil), forCellReuseIdentifier: "PlayerListCell")
		tableView.dataSource = dataSource
		tableView.delegate = dataSource
		tableView.separatorStyle = .none
	}
	
	private func setupMenuView() {
		guard let menuView = storyBoard.instantiateViewController(identifier: "MenuViewController") as? MenuViewController else {
			return
		}
		
		// Updates UI when a team is selected in the side menu
		menuView.delegate = self
		
		// Init the side menu
		let leftMenu = UISideMenuNavigationController(rootViewController: menuView)
		leftMenu.navigationBar.isHidden = true
		
		// Configure side menu
		SideMenuManager.default.menuLeftNavigationController = leftMenu
		SideMenuManager.default.menuPresentMode = .menuSlideIn
		SideMenuManager.default.menuFadeStatusBar = false
		SideMenuManager.default.menuAnimationFadeStrength = 0.3
		
		// Configure the gestures
		if let navigationController = navigationController {
			SideMenuManager.default.menuAddPanGestureToPresent(toView: navigationController.navigationBar)
			SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: navigationController.view)
		}
	}
	
	// MARK: - UI Actions
	/// Present the side menu
	@IBAction func teamsPressed(_ sender: Any) {
		guard let menuView = SideMenuManager.default.menuLeftNavigationController else {
			return
		}
		
		present(menuView, animated: true)
	}
	
	
	@IBAction func sortPressed(_ sender: Any) {
		let alertController = UIAlertController(title: "", message: "Sort by", preferredStyle: .actionSheet)
	
		
		// Sort by "Name" action
		alertController.addAction(UIAlertAction(title: "Name", style: .default, handler: {
			[weak self] (alert) in
			guard let self = self else {return}
			
			// Sort both player arrays
			self.dataSource.originalData = self.viewModel.sortPlayers(players: self.dataSource.originalData, by: .name)
			self.dataSource.filteredData = self.viewModel.sortPlayers(players: self.dataSource.filteredData, by: .name)
			// Display the filtered array if it isn't empty
			self.dataSource.data = self.dataSource.filteredData.isEmpty ? self.dataSource.originalData : self.dataSource.filteredData
			self.tableView.reloadData()
		}))
		
		// Sort by "Jersey Number" action
		alertController.addAction(UIAlertAction(title: "Jersey Number", style: .default, handler: {
			[weak self] (alert) in
			guard let self = self else {return}
			
			// Sort both player arrays
			self.dataSource.originalData = self.viewModel.sortPlayers(players: self.dataSource.originalData, by: .jersey)
			self.dataSource.filteredData = self.viewModel.sortPlayers(players: self.dataSource.filteredData, by: .jersey)
			// Display the filtered array if it isn't empty
			self.dataSource.data = self.dataSource.filteredData.isEmpty ? self.dataSource.originalData : self.dataSource.filteredData
			self.tableView.reloadData()
		}))
		
		// Cancel action
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		
		self.present(alertController, animated: true, completion: nil)
	}
}


extension PlayerListViewController: PlayerListDataSourceDelegate {
	
	/// Presents the DetailViewController and injects the Player object that was selected
	/// - Parameter player: The Player object to display in the detail view
	func didSelectPlayer(_ player: Player) {
		activityIndicator.startAnimating()
		// fetch Player details
		viewModel.fetchPlayerDetails(player: player)
	}
}


extension PlayerListViewController: MenuViewControllerDelegate {
	
	/// Called when user selects a team
	/// - Parameter team: The Team object we want players for
	func didSelectTeam(team: Team) {
		// Show spinner
		activityIndicator.startAnimating()
		
		viewModel.team = team
		// fetch team and players
		viewModel.fetchPlayers()
	}
}

extension PlayerListViewController: PlayerListViewModelDelegate {
	
	/// Called after the networking layer received a successful response from the API
	/// - Parameter players: Array of Player objects from a specific team
	func didFetchPlayers(players: [Player]) {
		// Stop spinner
		activityIndicator.stopAnimating()
		
		// update nav bar title to new team
		navigationItem.title = viewModel.team.name
		
		// Update model
		dataSource.data = players
		dataSource.originalData = players
		dataSource.filteredData = []
		// Update UI
		tableView.reloadData()
	}
	
	/// Called after networking layer receives successful response from API
	/// - Parameter playerDetail: The object that contains data that will be displayed in the DetailViewController
	func didFetchPlayerDetails(playerDetail: PlayerDetail) {
		guard let vc = storyBoard.instantiateViewController(identifier: "PlayerDetailViewController") as? PlayerDetailViewController else {
			return
		}
		
		self.activityIndicator.stopAnimating()
		// Inject model into PlayerDetailViewController and present 
		vc.player = playerDetail
		navigationController?.pushViewController(vc, animated: true)
	}
}



extension PlayerListViewController: UISearchBarDelegate, UITextFieldDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		// If the search bar is empty, display the original array of Players
		guard !searchText.isEmpty else {
			dataSource.filteredData = []
			dataSource.data = dataSource.originalData
			tableView.reloadData()
			return
		}
		
		// Filter the tableView based on the text entered
		dataSource.filteredData = viewModel.filterPlayers(players: dataSource.originalData, with: searchText)
		dataSource.data = dataSource.filteredData
		tableView.reloadData()
	}
	
	// Hide keyboard when user taps "done" key
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
}



