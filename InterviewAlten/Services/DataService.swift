//
//  DataService.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 01/03/2023.
//

import Foundation
import Combine

protocol DataServiceProtocol {
    func getData(_ isFirstStart: Bool, completion: @escaping (Result<[DataModel], Error>) -> Void)
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
    
    func getData(_ isFirstStart: Bool, completion: @escaping (Result<[DataModel], Error>) -> Void) {
        if isFirstStart {
            let data = localDataService.getAll()
            if (data.isEmpty) {
                fetchDataFromRemote(completion: completion)
            } else {
                completion(.success(data.compactMap { $0.toDataModel() }))
            }
        } else {
            fetchDataFromRemote { [weak self] result in
                switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    guard let data = self?.localDataService.getAll(), data.isNotEmpty else {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(data.compactMap { $0.toDataModel() }))
                }
            }
        }
    }
    
    private func fetchDataFromRemote(completion: @escaping (Result<[DataModel], Error>) -> Void) {
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
                }, receiveValue: { [weak self] value in
                    self?.localDataService.removeAll()
                    value.forEach { dataModel in
                        self?.localDataService.add(dataModel: dataModel)
                    }
                    completion(.success(value))
                })
                .store(in: &cancellables)
        }
    }
}
