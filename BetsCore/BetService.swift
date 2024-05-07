//
//  BetService.swift
//  BetsCore
//
//  Created by Omar Torres on 18/04/24.
//

public protocol BetService {
	func loadBets() async throws -> [Bet]
	func saveBets(_ bets: [Bet]) async throws
}
