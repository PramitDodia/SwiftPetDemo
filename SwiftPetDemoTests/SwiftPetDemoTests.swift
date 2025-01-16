//
//  SwiftPetDemoTests.swift
//  SwiftPetDemoTests
//
//  Created by Pramit D on 16/01/25.
//

import XCTest
@testable import SwiftPetDemo

final class SwiftPetDemoTests: XCTestCase {
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchRandomCatImageSuccess() async throws {
        let service = CatService.shared
        let cat = try await service.fetchRandomCatImage(from: constant.catRandomImage)
        XCTAssertNotNil(cat.url)
    }
    func testFetchRandomCatFactSuccess() async throws {
        let service = CatService.shared
        let fact = try await service.fetchRandomCatFact(from: constant.catFacts)
        XCTAssertFalse(fact.isEmpty)
    }
    func testLoadRandomCatUpdatesPublishedProperties() async {
        let viewModel = CatViewModel()
        
        await viewModel.loadRandomCat()
        
        XCTAssertNotNil(viewModel.catImageURL)
        XCTAssertFalse(viewModel.catFact.isEmpty)
    }
    func testExample() throws {
        // Example functional test case.
    }
    
    func testPerformanceExample() throws {
        // Example performance test case.
        self.measure {
            // Code to measure the time of here.
        }
    }
    
}
