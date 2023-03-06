//
//  DataModel.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 01/03/2023.
//

import Foundation

struct DataModel: Codable, Equatable  {
    let id, name, description, imageUrl: String
    let price: Double

    enum CodingKeys: String, CodingKey {
        case id, name, description, price
        case imageUrl = "image_url"
    }
    
    init(
        id: String,
        name: String,
        description: String,
        imageUrl: String,
        price: Double
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.imageUrl = imageUrl
        self.price = price
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        price = try values.decode(Double.self, forKey: .price)
        description = try values.decode(String.self, forKey: .description)
        imageUrl = try values.decode(String.self, forKey: .imageUrl)
    }
    
    func getFormattedPrice() -> String {
        String(format: "%.2f", price)
    }
}
