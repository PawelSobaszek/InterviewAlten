//
//  URLRequestExtensions.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 03/03/2023.
//

import Foundation

extension URLRequest {
    func printDetails() {
        if let url = url, let method = httpMethod, let headers = allHTTPHeaderFields {
            Log.i("\n REQUEST DETAILS \n URL: \(url) \n METHOD: \(method) \n HEADERS: \(headers) \n PARAMS: \(String(describing: httpBody?.jsonString() ?? nil))")
        }
    }
}
