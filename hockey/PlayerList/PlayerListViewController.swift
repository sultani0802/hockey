//
//  ViewController.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

class PlayerListViewController: UIViewController {

	// MARK: - UI Elements
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	
	// MARK: - Properties
	private let viewModel: PlayerListViewModel = PlayerListViewModel(team: Team(name: "Select a team"))
	private lazy var dataSource: PlayerListDataSource = PlayerListDataSource(delegate: self)
	
	// MARK: - Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		setupTableView()
	}
	
	// MARK: - Private
	private func setupTableView() {
		tableView.register(UINib(nibName: "PlayerListCell", bundle: nil), forCellReuseIdentifier: "PlayerListCell")
		tableView.dataSource = dataSource
		tableView.delegate = dataSource
		tableView.separatorStyle = .none
	}
}


extension PlayerListViewController: PlayerListDataSourceDelegate {
	
	/// Presents the DetailViewController and injects the Player object that was selected
	/// - Parameter player: The Player object to display in the detail view
	func didSelectPlayer(_ player: Player) {
		print("Selected player: \(player.name)")
		// present player detail view and inject player object into the VC
	}
}
