//
//  OddsViewModel.swift
//  Bets
//
//  Created by Omar Torres on 18/04/24.
//

import BetsCore

final public class OddsViewModel {
	private let repository: Repository
	
	public init(repository: Repository) {
		self.repository = repository
	}
	
	func getOdds() async throws -> [BetItem] {
		do {
			let odds = try await repository.updateOdds()
			return odds
		} catch {
			throw error
		}
	}
}
