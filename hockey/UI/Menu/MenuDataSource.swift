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
}

extension MenuDataSource: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let team = self.data[indexPath.row]
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as? MenuCell else {
			return UITableViewCell()
		}
		
		cell.teamLogoImageView.image = UIImage(named: team.teamName.lowercased())
		cell.teamNameLabel?.text = team.name
		
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
