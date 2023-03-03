//
//  AppEnvironment.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 02/03/2023.
//

import Foundation

enum AppEnvironment {
    case production
    case development
}

extension AppEnvironment {
    static var currentState: AppEnvironment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
}

extension AppEnvironment {
    static var baseURL: URL {
        switch AppEnvironment.currentState {
        case .production:
            return URL(string: Servers.production)!
        case .development:
            return URL(string: Servers.development)!
        }
    }
}
