//
//  LatestNewsRepositoryMock.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 16.05.2022..
//

import Foundation
import Combine

class LatestNewsRepositoryMock: LatestNewsRepository {
    
    func getLatestNews(offset: Int) -> AnyPublisher<Result<LatestNewsResponseItem, ErrorType>, Never> {
        do {
            guard let resourcePath = Bundle.main.url(forResource: "LatestNewsData", withExtension: "json") else {
                return Just(Result.failure(ErrorType.general)).eraseToAnyPublisher()
            }
            
            let data = try Data(contentsOf: resourcePath)
            let parsedData = try JSONDecoder().decode(LatestNewsResponseItem.self, from: data)
            
            return Just(Result.success(parsedData))
                .eraseToAnyPublisher()
        }
        catch {
            print("Error \(error)")
            return Just(Result.failure(ErrorType.general)).eraseToAnyPublisher()
        }
    }
}
