//
//  DataEntity.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 06/03/2023.
//

import Foundation

extension DataEntity {
    public override func awakeFromInsert() {
        timestamp = Date()
    }
    
    func toDataModel() -> DataModel? {
        guard let id, let name, let desc, let imageUrl else { return nil }
        return DataModel(id: id, name: name, description: desc, imageUrl: imageUrl, price: price)
    }
}
