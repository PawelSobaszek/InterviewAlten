//
//  MockDataService.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 06/03/2023.
//

import Foundation

enum MockDataServiceScenario {
    case successWithEmptyList
    case successWithThreeElements
    case failureWithUnknownError
}

final class MockDataService: DataServiceProtocol {
    var testScenario: MockDataServiceScenario
    
    init(testScenario: MockDataServiceScenario) {
        self.testScenario = testScenario
    }
    
    func getData(_ isFirstStart: Bool, completion: @escaping (Result<[DataModel], Error>) -> Void) {
        switch testScenario {
        case .successWithEmptyList:
            completion(.success([]))
        case .successWithThreeElements:
            completion(.success([
                DataModel(id: "", name: "", description: "", imageUrl: "", price: 0),
                DataModel(id: "", name: "", description: "", imageUrl: "", price: 0),
                DataModel(id: "", name: "", description: "", imageUrl: "", price: 0)
            ]))
        case .failureWithUnknownError:
            completion(.failure(APIError.unknown()))
        }
    }
}
