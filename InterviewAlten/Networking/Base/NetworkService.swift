//
//  NetworkService.swift
//  InterviewAlten
//
//  Created by Paweł Sobaszek on 02/03/2023.
//

import Foundation
import Combine

protocol NetworkServiceProtocol: AnyObject {
    func execute<T: Codable>(_ urlRequest: URLRequestBuilder, model: T.Type) async throws -> AnyPublisher<T, Error>
}

enum NetworkError: Error {
    case request(underlyingError: Error)
    case unableToDecode(underlyingError: Error)
}

final class NetworkService: NetworkServiceProtocol {
    private var configuration: URLSessionConfiguration
    private var session: URLSession
    
    init(sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default) {
        configuration = URLSession.shared.configuration
        session = URLSession(configuration: configuration)
    }
    
    func execute<T: Codable>(_ urlRequest: URLRequestBuilder, model: T.Type) async throws -> AnyPublisher<T, Error> {
        guard let request = try? urlRequest.asURLRequest() else {
            Log.e(APIError.badRequest().localizedDescription)
            throw APIError.badRequest()
        }
        request.printDetails()
        return session.dataTaskPublisher(for: request)
            .tryMap { (data: Data, response: URLResponse) in
                guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse() }
                
                if urlRequest.responseValidRange.contains(httpResponse.statusCode) {
                    data.printJSON()
                    return data
                } else {
                    guard let errorMessage = data.getErrorMessage() else { throw APIError.invalidResponse() }
                    throw self.parseError(statusCode: httpResponse.statusCode, errorMessage: errorMessage)
                }
            }
            .mapError({ error in
                if let error = error as? APIError {
                    return error
                } else {
                    return APIError.unknown(error)
                }
            })
            .decode(type: model, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func parseError(statusCode: Int, errorMessage: String) -> Error {
        var errorToReturn: Error?
        
        switch statusCode {
        case 400:
            errorToReturn = APIError.badRequest(nil, errorMessage)
        case 401:
            errorToReturn = APIError.unAuthorised(nil, errorMessage)
        case 404:
            errorToReturn = APIError.notFound(nil, errorMessage)
        case 400...499:
            break
        case 500...599:
            errorToReturn = APIError.serverError(nil, errorMessage)
        default:
            errorToReturn = APIError.unknown(nil, errorMessage)
        }
        
        return errorToReturn ?? APIError.invalidResponse(nil, errorMessage)
    }
}

//struct DefaultErrorParser: ErrorParserType {
//
//     func parse(data: JSONDictionary) -> Error? {
//        print("Error: \(data)")
//
//        guard let message = data["message"] as? String else {
//            return nil
//        }
//
//         return APIError.some(nil, message)
//
//    }
//}
