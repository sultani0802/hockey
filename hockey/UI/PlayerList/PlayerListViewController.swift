//
//  ViewController.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit
import SideMenu

class PlayerListViewController: UIViewController {

	// MARK: - UI Elements
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var teamsBarButtonItem: UIBarButtonItem!
	
	
	// MARK: - Properties
	private let viewModel: PlayerListViewModel = PlayerListViewModel(team: Team(id: 1, name: "Team", teamName: "Team Name"))
	private lazy var dataSource: PlayerListDataSource = PlayerListDataSource(delegate: self)
	private let storyBoard = UIStoryboard(name: "Main", bundle: nil)
	
	
	// MARK: - Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		activityIndicator.isHidden = true
		setupTableView()
		setupMenuView()
		viewModel.bind(to: self)
	}
	
	
	// MARK: - Private
	private func setupTableView() {
		tableView.register(UINib(nibName: "PlayerListCell", bundle: nil), forCellReuseIdentifier: "PlayerListCell")
		tableView.dataSource = dataSource
		tableView.delegate = dataSource
		tableView.separatorStyle = .none
	}
	
	private func setupMenuView() {
		guard let menuView = storyBoard.instantiateViewController(identifier: "MenuViewController") as? MenuViewController else {
			return
		}
		
		// Set the dataSource delegate to itself
		menuView.bindDataSource(to: menuView)
		// Set self to delegate that responds to team selection in Side Menu
		menuView.delegate = self
		
		let leftMenu = UISideMenuNavigationController(rootViewController: menuView)
		leftMenu.navigationBar.isHidden = true
		
		// Configure side menu
		SideMenuManager.default.menuLeftNavigationController = leftMenu
		SideMenuManager.default.menuPresentMode = .menuSlideIn
		SideMenuManager.default.menuFadeStatusBar = false
		SideMenuManager.default.menuAnimationFadeStrength = 0.3
		
		if let navigationController = navigationController {
			SideMenuManager.default.menuAddPanGestureToPresent(toView: navigationController.navigationBar)
			SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: navigationController.view)
		}
	}
	
	// MARK: - UI Actions
	@IBAction func teamsPressed(_ sender: Any) {
		guard let menuView = SideMenuManager.default.menuLeftNavigationController else {
			return
		}
		
		present(menuView, animated: true)
	}
	
	
}


extension PlayerListViewController: PlayerListDataSourceDelegate {
	
	/// Presents the DetailViewController and injects the Player object that was selected
	/// - Parameter player: The Player object to display in the detail view
	func didSelectPlayer(_ player: Player) {
		// present player detail view and inject player object into the VC
		guard let vc = storyBoard.instantiateViewController(identifier: "PlayerDetailViewController") as? PlayerDetailViewController else {
			return
		}
		
		navigationController?.pushViewController(vc, animated: true)
	}
}


extension PlayerListViewController: MenuViewControllerDelegate {
	func didSelectTeam(team: Team) {
		// Show spinner
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
		
		viewModel.team = team
		// fetch team and players
		viewModel.fetchPlayers()
	}
}

extension PlayerListViewController: PlayerListViewModelDelegate {
	func didFetchPlayers(players: [Player]) {
		// Stop spinner
		activityIndicator.stopAnimating()
		activityIndicator.isHidden = true
		
		// update nav bar title to new team
		navigationItem.title = viewModel.team.name
		// Update model
		dataSource.data = players
		// Update UI
		tableView.reloadData()
	}
	
	
}
