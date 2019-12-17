//
//  PlayerListDataSource.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit

protocol PlayerListDataSourceDelegate: class {
	func didSelectPlayer(_ player: Player)
}

class PlayerListDataSource: NSObject {
	var data: [Player] = []
	
	private weak var delegate: PlayerListDataSourceDelegate?
	
	init(delegate: PlayerListDataSourceDelegate) {
		self.delegate = delegate
	}
}


extension PlayerListDataSource: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerListCell") as? PlayerListCell else {
			return UITableViewCell()
		}
		
		let player = data[indexPath.row]
		
		cell.playerNameLabel.text = player.person.fullName
		cell.playerNumberLabel.text = player.jerseyNumber
		cell.playerPositionLabel.text = player.position.abbreviation
		
		return cell
	}
}


extension PlayerListDataSource: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let player = self.data[indexPath.row]
		delegate?.didSelectPlayer(player)
	}
}
