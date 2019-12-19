//
//  hockeyTests.swift
//  hockeyTests
//
//  Created by Haamed Sultani on Dec/1/19.
//  Copyright © 2019 Haamed Sultani. All rights reserved.
//

import XCTest

@testable import hockey

class hockeyTests: XCTestCase {

	var sut: PlayerListViewModel!
	
    override func setUp() {
		sut = PlayerListViewModel(team: Team(id: 0, name: "Test Team", teamName: "Test"))
    }



    func testJerseyNumberSorting() {
        // Given
		var players: [Player] = [
			Player(person: Person(fullName: "Test Player", id: 1), jerseyNumber: "5", position: Position(abbreviation: "G"), imagePath: "path", country: "Pangea"),
			Player(person: Person(fullName: "Test Player", id: 1), jerseyNumber: "32", position: Position(abbreviation: "G"), imagePath: "path", country: "Pangea"),
			Player(person: Person(fullName: "Test Player", id: 1), jerseyNumber: "1", position: Position(abbreviation: "G"), imagePath: "path", country: "Pangea"),
			Player(person: Person(fullName: "Test Player", id: 1), jerseyNumber: "10", position: Position(abbreviation: "G"), imagePath: "path", country: "Pangea"),
			Player(person: Person(fullName: "Test Player", id: 1), jerseyNumber: "19", position: Position(abbreviation: "G"), imagePath: "path", country: "Pangea"),
			Player(person: Person(fullName: "Test Player", id: 1), jerseyNumber: "2", position: Position(abbreviation: "G"), imagePath: "path", country: "Pangea"),
			Player(person: Person(fullName: "Test Player", id: 1), jerseyNumber: "1492", position: Position(abbreviation: "G"), imagePath: "path", country: "Pangea"),
		]
		
		
		// When
		let unsortedJerseyNumbers: [Int] = players.map({Int($0.jerseyNumber)!})
		XCTAssertEqual(unsortedJerseyNumbers, [5, 32, 1, 10, 19, 2, 1492])
		
		sut.sortPlayers(players: &players, by: .jersey)
		
		// Then
		let sortedJerseyNumbers: [Int] = players.map({Int($0.jerseyNumber)!})
		XCTAssertEqual(sortedJerseyNumbers, [1, 2, 5, 10, 19, 32, 1492])
    }

	func testNameSorting() {
		// Given
		var players: [Player] = [
			Player(person: Person(fullName: "Microsoft", id: 1), jerseyNumber: "5", position: Position(abbreviation: "G"), imagePath: "path", country: "Pangea"),
			Player(person: Person(fullName: "Apple", id: 1), jerseyNumber: "32", position: Position(abbreviation: "G"), imagePath: "path", country: "Pangea"),
			Player(person: Person(fullName: "IBM", id: 1), jerseyNumber: "1", position: Position(abbreviation: "G"), imagePath: "path", country: "Pangea"),
			Player(person: Person(fullName: "Sony", id: 1), jerseyNumber: "10", position: Position(abbreviation: "G"), imagePath: "path", country: "Pangea"),
			Player(person: Person(fullName: "Samsung", id: 1), jerseyNumber: "19", position: Position(abbreviation: "G"), imagePath: "path", country: "Pangea"),
			Player(person: Person(fullName: "Xerox", id: 1), jerseyNumber: "2", position: Position(abbreviation: "G"), imagePath: "path", country: "Pangea"),
			Player(person: Person(fullName: "Wayne Gretzky", id: 1), jerseyNumber: "1492", position: Position(abbreviation: "G"), imagePath: "path", country: "Pangea"),
		]
		
		
		// When
		let unsortedNames: [String] = players.map({$0.person.fullName})
		XCTAssertEqual(unsortedNames, ["Microsoft", "Apple", "IBM", "Sony", "Samsung", "Xerox", "Wayne Gretzky"])
		
		sut.sortPlayers(players: &players, by: .name)
		
		// Then
		let sortedNames: [String] = players.map({$0.person.fullName})
		XCTAssertEqual(sortedNames, ["Apple", "IBM", "Microsoft", "Samsung", "Sony", "Wayne Gretzky", "Xerox"])
	}
}
