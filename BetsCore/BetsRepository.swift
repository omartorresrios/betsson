public protocol Repository {
	func updateOdds() async throws -> [BetItem]
}

final public class BetRepository: Repository {
    private let service: BetService
	private let itemsToIncreaseQuality = [BetType.playerPerfomance, 
										  BetType.totalScore, 
										  BetType.winningTeam]
	private let quantityToDecrease = 0
	private let quantityIncrease = 50
	private let sellInToIncrease = 11
	private let sellInToUpdate = 0
	
    public init(service: BetService) {
        self.service = service
    }
	
	public func updateOdds() async throws -> [BetItem] {
		let bets = try await service.loadBets()
		var betItems = bets.map { $0.betItem }
		
        for i in 0 ..< betItems.count {
			updateQuality(to: &betItems[i])
			decreaseSellIn(to: &betItems[i])
			updateQualityWithNegativeSellIn(to: &betItems[i])
        }

        try await service.saveBets(bets)
        return betItems
    }
	
	private func updateQuality(to betItem: inout BetItem) {
		if allowToIncreaseQuality(for: betItem) {
			betItem.increaseQuality()
			if betItem.name == BetType.totalScore, betItem.sellIn < sellInToIncrease {
				betItem.increaseQuality()
			}
		} else if allowToDecreaseQuality(for: betItem) {
			betItem.decreaseQuality()
		}
	}
	
	private func decreaseSellIn(to betItem: inout BetItem) {
		if allowToDecreaseSellIn(for: betItem) {
			betItem.decreaseSellIn()
		}
	}
	
	private func updateQualityWithNegativeSellIn(to betItem: inout BetItem) {
		if betItem.sellIn < sellInToUpdate {
			if betItem.name == .playerPerfomance, betItem.quality < quantityIncrease {
				betItem.increaseQuality()
			} else {
				if betItem.name == .totalScore {
					betItem.setQuality(betItem.quality - betItem.quality)
				} else if betItem.name != .winningTeam, betItem.quality > quantityToDecrease {
					betItem.decreaseQuality()
				}
			}
		}
	}
	
	private func allowToIncreaseQuality(for betItem: BetItem) -> Bool {
		let betType = BetType(rawValue: betItem.name.rawValue)
		return itemsToIncreaseQuality.contains(betType) && betItem.quality < quantityIncrease
	}
	
	private func allowToDecreaseQuality(for betItem: BetItem) -> Bool {
		betItem.name != BetType.winningTeam && betItem.quality > quantityToDecrease
	}
	
	private func allowToDecreaseSellIn(for betItem: BetItem) -> Bool {
		betItem.name != BetType.winningTeam
	}
}
