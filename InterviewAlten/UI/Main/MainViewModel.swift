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
    var state: MainViewState { get }
 
    func fetchItems()
}

final class MainViewModel: MainViewModelProtocol {
    @Published var state: MainViewState = .START
    
    private let dataService: DataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private var isFirstStart: Bool = true

    init(dataService: DataServiceProtocol = DataService()) {
        self.dataService = dataService
        fetchItems()
    }
}

extension MainViewModel {
    func fetchItems() {
        state = .LOADING
        dataService.getData(isFirstStart) { [weak self] result in
            guard let self = self else { return }
            self.isFirstStart = false
            switch result {
            case .success(let response):
                self.state = .SUCCESS(datas: response)
            case .failure(let error):
                Log.e(error.localizedDescription)
                self.state = .FAILURE(error: error.localizedDescription)
            }
        }
    }
}
