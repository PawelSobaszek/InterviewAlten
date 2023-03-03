//
//  DetailsViewModel.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 02/03/2023.
//

import Foundation
import SwiftUI

protocol DetailsViewModelProtocol: ObservableObject {
    var data: DataModel { get }
    var dataPublisher: Published<DataModel>.Publisher { get }
}

final class DetailsViewModel: DetailsViewModelProtocol {
    @Published var data: DataModel
    var dataPublisher: Published<DataModel>.Publisher { $data }
    
    init(data: DataModel) {
        self.data = data
    }
}
