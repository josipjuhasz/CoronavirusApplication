//
//  RestManager.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 02.02.2022..
//

import Foundation
import Combine

class RestManager {
    
    func fetchData<T: Decodable>(url: URL) -> AnyPublisher<T, ErrorType> {
        URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap { data, _ in
                let value = try JSONDecoder().decode(T.self, from: data)
                if let array = value as? Array<Any>, array.isEmpty {
                    throw ErrorType.empty
                }
                return value
            }
            .mapError { error -> ErrorType in
                switch error {
                    
                case let errorType as ErrorType:
                    switch errorType {
                    case .empty:
                        return .empty
                    case .general:
                        return .general
                    case .noInternetConnection:
                        return .noInternetConnection
                    }
                    
                case let urlError as URLError:
                    switch urlError.code {
                    case .notConnectedToInternet, .networkConnectionLost, .timedOut:
                        return .noInternetConnection
                    case .cannotDecodeRawData, .cannotDecodeContentData:
                        return .empty
                    default:
                        return .general
                    }
                default:
                    return .general
                }
            }
            .eraseToAnyPublisher()
    }
}
