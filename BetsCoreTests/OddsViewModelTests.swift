import XCTest
import BetsCore

class OddsViewModelTests: XCTestCase {
	
	func test_getOddsOnSuccessfulResponse() async throws {
		let (sut, repository) = getSut()
		repository.odds = [BetItem(name: .playerPerfomance, 
								   sellIn: 40,
								   quality: 23)]
		
		let odds = try await sut.getOdds()
		
		XCTAssertEqual(odds, repository.odds)
	}
	
	func test_getErrorOnFailureResponse() async throws {
		let (sut, repository) = getSut()
		repository.error = anyNSError()
		
		do {
			let odds = try await sut.getOdds()
			XCTFail("Expected failure, got \(odds) instead")
		} catch {
			XCTAssertEqual(repository.error, error as NSError)
		}
	}
	
	private func getSut() -> (OddsViewModel, RepositoryStub) {
		let repository = RepositoryStub()
		let viewModel = OddsViewModel(repository: repository)
		return (viewModel, repository)
	}
	
	private func anyNSError() -> NSError {
		return NSError(domain: "any error", code: 0)
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
