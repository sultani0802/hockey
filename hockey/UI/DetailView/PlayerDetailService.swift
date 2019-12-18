//
//  PlayerDetailService.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation

struct CountryResponseObject: Decodable {
	var name: String
	var flag: String
}

protocol PlayerDetailServiceProtocol {
	func fetchCountry(for country: String, completion: @escaping (Result<CountryResponseObject>) -> Void)
}


class PlayerDetailService: APIClient {
	var session: URLSession
	
	init(configuration: URLSessionConfiguration = .default) {
		self.session = URLSession(configuration: configuration)
	}
}


extension PlayerDetailService: PlayerDetailServiceProtocol {
	
	/// Fetch country details from API
	/// - Parameters:
	///   - country: Country code that will be sent to the API. Accepts alpha2code and alpha3code.
	func fetchCountry(for country: String, completion: @escaping (Result<CountryResponseObject>) -> Void) {
		guard let url = URL(string: Constants.countryBaseURL + "/\(country)") else {
			completion(.failure)
			return
		}
		
		let request = URLRequest(url: url)
		fetch(with: request, decode: {$0 as? CountryResponseObject ?? nil}, completion: completion)
	}
}
