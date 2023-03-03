//
//  APIs.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 02/03/2023.
//

import Foundation

enum APIs: URLRequestBuilder {    
    case getDatas
}

extension APIs {
    var path: String {
        switch self {
        case .getDatas:
            return NetworkPath.Example.example
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getDatas:
            return .get
        }
    }
}
