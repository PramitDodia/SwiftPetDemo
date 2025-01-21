//
//  SwiftPetDemoTests.swift
//  SwiftPetDemoTests
//
//  Created by Pramit D on 16/01/25.
//

import XCTest
@testable import SwiftPetDemo

final class SwiftPetDemoTests: XCTestCase {
    var viewModel: CatViewModel!
    var mockService: CatServiceProtocol!
    
    override func setUp() {
        super.setUp()
        mockService = FailingMockCatService()
        viewModel = CatViewModel(service: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    // MARK: - Mock Services
    class FailingMockCatService: CatServiceProtocol {
        func fetchData<T>(from urlString: String, decodeTo type: T.Type) async throws -> T where T : Decodable {
            throw URLError(.notConnectedToInternet)
        }
        
        func fetchRandomCatImage(from urlString: String) async throws -> Cat {
            throw URLError(.notConnectedToInternet)
        }
        
        func fetchRandomCatFact(from urlString: String) async throws -> String {
            throw URLError(.notConnectedToInternet)
        }
    }
    
    class SuccessMockCatService: CatServiceProtocol {
        func fetchData<T>(from urlString: String, decodeTo type: T.Type) async throws -> T where T : Decodable {
            fatalError("Not implemented for this test scenario.")
        }
        
        func fetchRandomCatImage(from urlString: String) async throws -> Cat {
            return Cat(url: "https://example.com/cat.jpg")
        }
        
        func fetchRandomCatFact(from urlString: String) async throws -> String {
            return "A random cat fact!"
        }
    }
    
    // MARK: - Test Cases
    func testFetchRandomCatImageSuccess() async throws {
        let service = SuccessMockCatService()
        let cat = try await service.fetchRandomCatImage(from: constant.catRandomImage)
        XCTAssertNotNil(cat.url, "The cat image URL should not be nil.")
    }
    
    func testFetchRandomCatFactSuccess() async throws {
        let service = SuccessMockCatService()
        let fact = try await service.fetchRandomCatFact(from: constant.catFacts)
        XCTAssertFalse(fact.isEmpty, "The cat fact should not be empty.")
    }
    
    func testLoadRandomCatUpdatesPublishedProperties() async {
        let successService = SuccessMockCatService()
        let viewModel = CatViewModel(service: successService)
        
        await viewModel.loadRandomCat()
        XCTAssertNotNil(viewModel.catImageURL, "The cat image URL should not be nil.")
        XCTAssertFalse(viewModel.catFact.isEmpty, "The cat fact should not be empty.")
    }
    
    func testLoadRandomCatFailure() async {
        let failingService = FailingMockCatService()
        let viewModel = CatViewModel(service: failingService)
        
        await viewModel.loadRandomCat()
        XCTAssertNil(viewModel.catImageURL, "The cat image URL should be nil on failure.")
        XCTAssertEqual(viewModel.catFact, "Failed to load. Please try again.", "The cat fact should show an error message.")
        XCTAssertFalse(viewModel.isLoading, "Loading state should be false after completion.")
    }
}
