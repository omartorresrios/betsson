//
//  ViewControllerTests.swift
//  BetsCoreTests
//
//  Created by Omar Torres on 4/19/24.
//

import XCTest
import BetsCore

class ViewControllerTests: XCTest {
	
	func test_sutShouldBeTheDataSourceForCollectionViewWhenViewDidLoad() {
		let (sut, _) = getSut()
		
		sut.loadViewIfNeeded()
		
		XCTAssertIdentical(sut.oddsCollectionView.dataSource, sut)
	}
	
	func test_collectionjViewShouldNotHaveItemsWhenGetOddsRequestFailed() {
		let (sut, repository) = getSut()
		repository.error = anyNSError()
		
		sut.loadViewIfNeeded()
		
		XCTAssertFalse((sut.oddsCollectionView.dataSource?.collectionView(sut.oddsCollectionView, numberOfItemsInSection: 0))! > 0)
	}
	
	func test_collectionViewShouldHaveItemsWhenOddsRequestSucceed() {
		let (sut, repository) = getSut()
		repository.odds = [BetItem(name: .playerPerfomance,
								   sellIn: 40,
								   quality: 23)]
		
		sut.loadViewIfNeeded()
		
		XCTAssertTrue((sut.oddsCollectionView.dataSource?.collectionView(sut.oddsCollectionView, numberOfItemsInSection: 0))! > 0)
	}
	
	func test_navigationItemMustHaveRightItem() {
		let (sut, _) = getSut()
		
		sut.loadViewIfNeeded()
		
		XCTAssertNotNil(sut.navigationItem.rightBarButtonItem)
	}
	
	func test_getOddsWhenTappinng() {
		let (sut, repository) = getSut()
		repository.odds = [BetItem(name: .playerPerfomance,
								   sellIn: 40,
								   quality: 23)]
		let action = sut.navigationItem.rightBarButtonItem?.action
		
		sut.loadViewIfNeeded()
		sut.perform(action)
		
		XCTAssertNotNil(repository.odds)
	}
	
	private func anyNSError() -> NSError {
		return NSError(domain: "any error", code: 0)
	}
	
	private func getSut() -> (OddsViewController, RepositoryStub) {
		let repository = RepositoryStub()
		let viewModel = OddsViewModel(repository: repository)
		let viewController = OddsViewController(viewModel: viewModel)
		return (viewController, repository)
	}
	
	final class RepositoryStub: Repository {
		
		var odds: [BetItem]?
		var error: NSError?
		
		func updateOdds() async throws -> [BetItem] {
			if let error = error {
				throw error
			} else {
				return odds ?? []
			}
		}
	}
}
