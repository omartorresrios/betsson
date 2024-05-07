//
//  BetRepositoryTests.swift
//  BetsCoreTests
//
//  Created by Omar Torres on 4/19/24.
//

import XCTest
import BetsCore

class BetRepositoryTests: XCTestCase {
	
	func test_getOddsAfterSuccessfulResponse() async throws {
		let (sut, service) = getSut()
		
		let receivedOdds = try await sut.updateOdds()
		
		guard let betItems = service.bets else { return }
		XCTAssertEqual(receivedOdds, betItems.map { $0.betItem })
	}
	
	func test_saveUpdatedOddsAfterSuccessfulResponse() async throws {
		let (sut, service) = getSut()
		let dummyBets = [Bet(name: "Total Score",
							  sellIn: 34,
							  quality: 22)]
		service.bets = dummyBets
		
		_ = try await sut.updateOdds()
		let receivedBets = try await service.loadBets()
		XCTAssertEqual(service.bets, receivedBets)
	}
	
	private func getSut() -> (BetRepository, ServiceStub) {
		let service = ServiceStub()
		let viewModel = BetRepository(service: service)
		return (viewModel, service)
	}
	
	final class ServiceStub: BetService {
		var bets: [Bet]?
		
		func loadBets() async throws -> [Bet] {
			bets ?? []
		}
		
		func saveBets(_ bets: [Bet]) async throws {
			self.bets = bets
		}
	}
}
