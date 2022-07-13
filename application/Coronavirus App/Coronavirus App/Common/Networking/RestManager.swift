//
//  RestManager.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 02.02.2022..
//

import Foundation
import Combine

class RestManager {
    
    static func fetchData<T: Decodable>(url: URL) -> AnyPublisher<Result<T, ErrorType>, Never> {
        URLSession
            .shared
            .dataTaskPublisher(for: url)
            .mapError { urlError -> ErrorType in
                switch urlError.code {
                case .notConnectedToInternet, .networkConnectionLost, .timedOut:
                    return ErrorType.noInternetConnection
                case .cannotDecodeRawData, .cannotDecodeContentData:
                    return ErrorType.empty
                default:
                    return ErrorType.general
                }
            }
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .map { result -> Result<T, ErrorType> in
                if let array = result as? Array<Any>, array.isEmpty {
                    return Result.failure(ErrorType.empty)
                }
                return Result.success(result)
            }
            .catch { Just<Result<T, ErrorType>>(.failure($0 as? ErrorType ?? .general)) }
            .eraseToAnyPublisher()
    }
}
