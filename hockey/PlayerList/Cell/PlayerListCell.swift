//
//  PlayerListCell.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit
import Kingfisher

class PlayerListCell: UITableViewCell {
	
	// MARK: - UI Elements
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var playerPortraitImageView: UIImageView!
	@IBOutlet weak var playerNumberLabel: UILabel!
	@IBOutlet weak var playerPositionLabel: UILabel!
	@IBOutlet weak var playerNameLabel: UILabel!
	
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		// Add depth and rounded corners to cell
		mainView.layer.cornerRadius = 10
		mainView.layer.shadowColor = UIColor.black.cgColor
		mainView.layer.shadowRadius = 6
		mainView.layer.shadowOpacity = 0.1
		mainView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
		mainView.layer.borderWidth = 0.5
		let shadowRect = CGRect(x: 10, y: 10, width: frame.width - 20, height: frame.height - 20)
		mainView.layer.shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: 10).cgPath
	}
	
	
	/// Applies the model attributes to the UI elements of the cell
	/// - Parameter player: The model object that will be displayed into the cell
	func render(with player: Player) {
		// TO-DO: Render the cell
//		let url = URL(string: )
//		playerPortraitImageView.kf.setImage(with: url)
		
//		self.playerNameLabel.text =
//		self.playerPositionLabel.text =
//		self.playerNameLabel.text =
	}
    
}
