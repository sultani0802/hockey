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
	private lazy var dataSource : MenuDataSource = MenuDataSource()
	weak var delegate : MenuViewControllerDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		setupTableView()
    }
	
	// MARK: - Public
	/// Binds self to dataSource delegate
	/// - Parameter delegate: The view controller that conforms to MenuDataSourceDelegate
	func bindDataSource(to delegate: MenuDataSourceDelegate) {
		dataSource.delegate = delegate
	}
	
	
	// MARK: - Private
	/// Sets the tableView datasource and delegate
	private func setupTableView() {
		tableView.dataSource = dataSource
		tableView.delegate = dataSource
	}

}


extension MenuViewController: MenuDataSourceDelegate {
	
	/// Tell PlayerListViewController that a team was selected and the Menu is hidden now
	/// - Parameter team: The Team object that will populate PlayerListViewController's tableView
	func didSelectTeam(team: Team) {
		dismiss(animated: true) { [weak self] in
			self?.delegate?.didSelectTeam(team: team)
		}
	}
}
