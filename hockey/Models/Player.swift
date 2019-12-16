//
//  Player.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation

struct Player: Decodable {
	var name: String
	var number: Int
	var position: String
	var imagePath: String?
	var country: String?
}
