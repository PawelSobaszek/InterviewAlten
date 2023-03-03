//
//  DataService.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 01/03/2023.
//

import Foundation
import Combine

protocol DataServiceProtocol {
    func getData() async throws -> AnyPublisher<[DataModel], Error>
}

final class DataService: DataServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let localDataService: LocalDataServiceProtocol
    
    init(
        networkService: NetworkServiceProtocol = NetworkService(),
        localDataService: LocalDataServiceProtocol = LocalDataService()
    ) {
        self.networkService = networkService
        self.localDataService = localDataService
    }
    
    func getData() async throws -> AnyPublisher<[DataModel], Error> {
        try await networkService.execute(Endpoints.getDatas.resolve(), model: [DataModel].self)
    }
}
