//
//  MainViewModel.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 01/03/2023.
//

import Foundation
import SwiftUI
import Combine

protocol MainViewModelProtocol: ObservableObject {
    var datas: [DataModel] { get }
    var datasPublisher: Published<[DataModel]>.Publisher { get }
 
    func fetchItems()
}

final class MainViewModel: MainViewModelProtocol {
    @Published var datas: [DataModel] = []
    var datasPublisher: Published<[DataModel]>.Publisher { $datas }
    
    private let dataService: DataServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(dataService: DataServiceProtocol = DataService()) {
        self.dataService = dataService
        fetchItems()
    }
}

extension MainViewModel {
    func fetchItems() {
        Task {
            try await dataService.getData()
                .sink(receiveCompletion: { response in
                    switch response {
                    case .failure(let error):
                        Log.e(error.localizedDescription)
                        return
                    case .finished:
                        Log.i("Finished")
                    }
                }, receiveValue: { value in
                    self.datas = value
                })
                .store(in: &cancellables)
        }
    }
}
