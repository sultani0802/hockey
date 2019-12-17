//
//  PlayerDetailViewController.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit
import Kingfisher

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
	
	private func render(_ country: CountryResponseObject) {
		guard let url = URL(string: Constants.countryBaseURL + "/\(country.flag)") else {
			return
		}
		
		self.countryLabel.text = country.name
		self.flagImageView.kf.setImage(with: url)
	}
}
