//
//  PlayerDetailViewController.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftSVG

class PlayerDetailViewController: UIViewController {

	// MARK: - UI Elements
	
	@IBOutlet weak var flagImageView: UIImageView!
	@IBOutlet weak var countryLabel: UILabel!
	
	
	// MARK: - Properties
	var player: PlayerDetail!
	private let service = PlayerDetailService()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		fetchCountry()
    }
	
	deinit {
		print("detail view deinitialized")
	}
	
	// MARK: - Private
	private func fetchCountry() {
		service.fetchCountry(for: self.player.birthCountry) { [weak self] (result) in
			
			switch result{
				case .success(let country):
					DispatchQueue.main.async {
						self?.render(country)
				}
				
				case .failure:
					print("Failed to fetch country")
			}
			
		}
	}
	
	/// Update the UI
	/// - Parameter country: Coutry object that will populate the view
	private func render(_ country: CountryResponseObject) {
		// Set the text
		self.countryLabel.text = country.name

		// Set the flag
		guard let url = URL(string: country.flag) else {
			return
		}
		
		// Create uiview containing the flag from the API
		let flag = UIView(SVGURL: url) { [weak self] (svgLayer) in
			svgLayer.resizeToFit((self?.flagImageView.bounds)!)
		}
		
		flag.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(flag)
		
		NSLayoutConstraint.activate([
			flag.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
			flag.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			flag.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			
			countryLabel.topAnchor.constraint(equalTo: flag.bottomAnchor, constant: 20)
		])
	}
}
