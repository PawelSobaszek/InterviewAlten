//
//  DataService.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 01/03/2023.
//

import Foundation
import Combine

protocol DataServiceProtocol {
    func getData(completion: @escaping (Result<[DataModel], Error>) -> Void)
}

final class DataService: DataServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let localDataService: LocalDataServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
        
    init(
        networkService: NetworkServiceProtocol = NetworkService(),
        localDataService: LocalDataServiceProtocol = LocalDataService()
    ) {
        self.networkService = networkService
        self.localDataService = localDataService
    }
    
    func getData(completion: @escaping (Result<[DataModel], Error>) -> Void) {
        let data = localDataService.getAll()
        if (data.isEmpty) {
            Task {
                try await networkService.execute(Endpoints.getDatas.resolve(), model: [DataModel].self)
                    .sink(receiveCompletion: { response in
                        switch response {
                        case .failure(let error):
                            Log.e(error.localizedDescription)
                            completion(.failure(error))
                        case .finished:
                            Log.i("Finished")
                        }
                    }, receiveValue: { value in
                        value.forEach { dataModel in
                            self.localDataService.add(dataModel: dataModel)
                        }
                        completion(.success(value))
                    })
                    .store(in: &cancellables)
            }
        } else {
            completion(.success(data.compactMap { $0.toDataModel() }))
        }
    }
}
