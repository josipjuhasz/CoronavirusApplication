//
//  LatestNewsRepositoryMock.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 16.05.2022..
//

import Foundation
import Combine

class LatestNewsRepositoryMock: LatestNewsRepository {
    func getLatestNews(offset: Int) -> AnyPublisher<LatestNewsResponseItem, ErrorType> {
        do {
            guard let resourcePath = Bundle.main.url(forResource: "LatestNewsData", withExtension: "json") else {
                return Fail(error: ErrorType.empty).eraseToAnyPublisher()
            }
            
            let data = try Data(contentsOf: resourcePath)
            let parsedData = try JSONDecoder().decode(LatestNewsResponseItem.self, from: data)
            
            return Just(parsedData)
                .setFailureType(to: ErrorType.self)
                .eraseToAnyPublisher()
        }
        catch {
            print("Error \(error)")
            return Fail(error: ErrorType.empty).eraseToAnyPublisher()
        }
    }
}
