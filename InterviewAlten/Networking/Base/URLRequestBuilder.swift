//
//  URLRequestBuilder.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 02/03/2023.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol URLRequestBuilder {
    var baseURL: URL { get }
    var apiVersion: String? { get }
    var requestURL: URL { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var headers: Headers { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncodable { get }
}

extension URLRequestBuilder {
    var baseURL: URL {
        AppEnvironment.baseURL
    }
    
    var apiVersion: String? {
        "/v3"
    }
    
    var requestURL: URL {
        var url = baseURL
        if let apiVersion {
            url = baseURL.appendingPathComponent(apiVersion, isDirectory: false)
        }
        return url.appendingPathComponent(path, isDirectory: false)
    }
    
    var responseValidRange: ClosedRange<Int> {
        (200...399)
    }
    
    var encoding: ParameterEncodable {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var parameters: Parameters? {
        nil
    }
    
    var headers: Headers {
        [:]
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        headers.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        return request
    }
    
    public func asURLRequest() throws -> URLRequest {
        try encoding.encode(urlRequest, with: parameters)
    }
}
