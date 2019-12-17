//
//  Player.swift
//  hockey
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import Foundation

struct Player: Decodable {
	var person: Person
	var jerseyNumber: String
	var position: Position
	var imagePath: String?
	var country: String?
}

struct Person: Decodable {
	var fullName: String
	var id: Int
}

struct Position: Decodable {
	var abbreviation: String
}
