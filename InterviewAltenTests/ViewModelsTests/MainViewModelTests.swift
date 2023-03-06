//
//  MainViewModelTests.swift
//  InterviewAltenTests
//
//  Created by Paweł Sobaszek on 06/03/2023.
//

import XCTest
@testable import InterviewAlten

final class MainViewModelTests: XCTestCase {
    private var mockDataService: (any DataServiceProtocol)!
    private var vm: (any MainViewModelProtocol)!

    override func tearDownWithError() throws {
        mockDataService = nil
        vm = nil
    }
    
    func test_fetchItems_successWithEmptyList() {
        setupMockForScenario(scenario: .successWithEmptyList)
        let expected = MainViewState.SUCCESS(datas: [])
        
        XCTAssertEqual(vm.state, expected)
    }
    
    func test_fetchItems_successWithThreeElements() {
        setupMockForScenario(scenario: .successWithThreeElements)
        let expected = MainViewState.SUCCESS(datas: [
            DataModel(id: "", name: "", description: "", imageUrl: "", price: 0),
            DataModel(id: "", name: "", description: "", imageUrl: "", price: 0),
            DataModel(id: "", name: "", description: "", imageUrl: "", price: 0)
        ])
        
        XCTAssertEqual(vm.state, expected)
    }
    
    func test_fetchItems_failureWithUnknownError() {
        setupMockForScenario(scenario: .failureWithUnknownError)
        let expected = MainViewState.FAILURE(error: APIError.unknown().localizedDescription)
        
        XCTAssertEqual(vm.state, expected)
    }
    
    private func setupMockForScenario(scenario: MockDataServiceScenario) {
        mockDataService = MockDataService(testScenario: scenario)
        vm = MainViewModel(dataService: mockDataService)
        vm.fetchItems()
    }
}
