//
//  PlayerDetailViewController.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import UIKit
import SwiftSVG

class PlayerDetailViewController: UIViewController, SpinnerProtocol, ErrorReceivableDelegate {

	// MARK: - UI Elements
	
	@IBOutlet weak var flagImageView: UIImageView!
	@IBOutlet weak var countryLabel: UILabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	
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
		activityIndicator.startAnimating()
		
		DispatchQueue.global().async { [weak self] in
			self?.service.fetchCountry(for: (self?.player.birthCountry)!) { (result) in
				
				switch result{
					case .success(let country):
						DispatchQueue.main.async {
							self?.render(country)
					}
					
					case .failure:
						self?.didReceiveError("Could not download flag")
				}
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
			NSLayoutConstraint(item: flag, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
			flag.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			flag.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			
			countryLabel.topAnchor.constraint(equalTo: flag.bottomAnchor, constant: 20)
		])
	}
}
