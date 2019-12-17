//
//  APIClient.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation
import UIKit

protocol APIClient {
	var session: URLSession { get }
	func fetch<T: Decodable>(with request: URLRequest,
							 decode: @escaping (Decodable) -> T?,
							 completion: @escaping (Result<T>) -> Void)
}

extension APIClient {
	private func decodingTask<T: Decodable>(with request: URLRequest,
											decodingType: T.Type,
											completionHandler completion: @escaping (Decodable?) -> Void) -> URLSessionDataTask {
		let mutableRequest = request

		let task = session.dataTask(with: mutableRequest) { data, response, _ in
			guard let httpResponse = response as? HTTPURLResponse else {
				completion(nil)
				return
			}
			
			print("API Response Status Code: \(httpResponse.statusCode)")
			
			if (httpResponse.statusCode == 200) {
				if let data = data {
					do {
						let decoder = JSONDecoder()
						decoder.keyDecodingStrategy = .convertFromSnakeCase
						let genericModel = try decoder.decode(decodingType, from: data)
						completion(genericModel)
					} catch {
						print(error)
						completion(nil)
					}
				} else {
					completion(nil)
				}
			} else {
				completion(nil)
			}
		}
		
		return task
	}
	
	
	func fetch<T: Decodable>(with request: URLRequest,
							 decode: @escaping (Decodable) -> T?,
							 completion: @escaping (Result<T>) -> Void) {
		let task = decodingTask(with: request, decodingType: T.self) { json in
			DispatchQueue.main.async {
				guard let json = json else {
					completion(.failure)
					return
				}
				
				if let value = decode(json) {
					completion(.success(value))
				} else {
					completion(.failure)
				}
			}
		}
		
		task.resume()
	}
}

