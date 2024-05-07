public struct BetItem: Equatable {
    public let name: BetType
    public var sellIn: Int
	public var quality: Int
	
	public mutating func increaseQuality() {
		quality += 1
	}
	
	public mutating func decreaseQuality() {
		quality -= 1
	}
	
	public mutating func setQuality(_ quality: Int) {
		self.quality = quality
	}
	
	public mutating func decreaseSellIn() {
		sellIn -= 1
	}
	
    public init(name: BetType, sellIn: Int, quality: Int) {
        self.name = name
        self.sellIn = sellIn
        self.quality = quality
    }
}

public struct Bet: Equatable {
	public let name: String
	public let sellIn: Int
	public let quality: Int

	public init(name: String, sellIn: Int, quality: Int) {
		self.name = name
		self.sellIn = sellIn
		self.quality = quality
	}
	
	public var betItem: BetItem {
		return BetItem(name: BetType(rawValue: name),
					   sellIn: sellIn,
					   quality: quality)
	}
}
