//
//  BetItemTests.swift
//  BetsCoreTests
//
//  Created by Omar Torres on 4/19/24.
//

import XCTest
import BetsCore

class BetItemTests: XCTest {
	
	func test_updatedQualityMustBeLessThanInitialQualityWhenCallingDecreaseQuality() {
		let initialQuality = 4
		var dummyBet = BetItem(name: BetType(rawValue: "dummy type"),
							   sellIn: 44,
							   quality: initialQuality)
		
		dummyBet.decreaseQuality()
		
		XCTAssertLessThan(dummyBet.quality, initialQuality)
	}
	
	func test_updatedQualityMustBeGretaerThanInitialQualityWhenCallingIncreaseQuality() {
		let initialQuality = 4
		var dummyBet = BetItem(name: BetType(rawValue: "dummy type"),
							   sellIn: 44,
							   quality: initialQuality)
		
		dummyBet.increaseQuality()
		
		XCTAssertGreaterThan(dummyBet.quality, initialQuality)
	}
	
	func test_updatedSellInMustBeLessThanInitialSellInWhenCallingDecreaseSellIn() {
		let initialSellIn = 10
		var dummyBet = BetItem(name: BetType(rawValue: "dummy type"),
							   sellIn: initialSellIn,
							   quality: 30)
		
		dummyBet.decreaseSellIn()
		
		XCTAssertLessThan(dummyBet.sellIn, initialSellIn)
	}
	
	func test_updatedQualityMustBeDifferentThanInitialQualityWhenCallingSetQuality() {
		let initialQuality = 10
		var dummyBet = BetItem(name: BetType(rawValue: "dummy type"),
							   sellIn: initialQuality,
							   quality: 30)
		
		dummyBet.setQuality(20)
		
		XCTAssertEqual(dummyBet.quality, initialQuality)
	}
}
