//
//  MenuDataSource.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

protocol MenuDataSourceDelegate: class {
	func didSelectTeam(team: Team)
}

class MenuDataSource: NSObject {
	var data: [Team] = []
	
	weak var delegate: MenuDataSourceDelegate?
	
	override init() {
		data.append(Team(name: "team 1"))
		data.append(Team(name: "team 2"))
		data.append(Team(name: "team 3"))
		data.append(Team(name: "team 4"))
	}
}

extension MenuDataSource: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let team = self.data[indexPath.row]
		
		let cell = UITableViewCell()
		cell.textLabel?.numberOfLines = 0
		cell.textLabel?.text = team.name
//		cell.imageView?.image = UIImage(named: indexPath.row == 0 ? "star-icon" : "movie-reel-icon")
		return cell
	}
}

extension MenuDataSource: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let team = data[indexPath.row]
		delegate?.didSelectTeam(team: team)
	}
}
