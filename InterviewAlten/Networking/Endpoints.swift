//
//  Endpoints.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 02/03/2023.
//

import Foundation

enum Endpoints {
    case getDatas
}

extension Endpoints {
    func resolve() -> URLRequestBuilder {
        switch self {
        case .getDatas:
            return APIs.getDatas
        }
    }
}
