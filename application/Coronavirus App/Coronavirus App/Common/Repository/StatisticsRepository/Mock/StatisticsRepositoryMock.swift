//
//  StatisticsRepositoryMock.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 24.03.2022..
//

import Foundation
import Combine

class StatisticsRepositoryMock: StatisticsRepository {

    func getCountryData(for name: String) -> AnyPublisher<Result<[CountryDayOneResponseItem], ErrorType>, Never> {
        do {
            guard let resourcePath = Bundle.main.url(forResource: "Covid19CroatiaDayOneData", withExtension: "json") else {
                return Just(Result.failure(ErrorType.general)).eraseToAnyPublisher()
            }
            
            let data = try Data(contentsOf: resourcePath)
            let parsedData = try JSONDecoder().decode([CountryDayOneResponseItem].self, from: data)
            
            return Just(Result.success(parsedData))
                .eraseToAnyPublisher()
        }
        
        catch {
            print("Error \(error)")
            return Just(Result.failure(ErrorType.general)).eraseToAnyPublisher()
        }
    }
    
    func getWorldwideData() -> AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never> {
        do {
            guard let resourcePath = Bundle.main.url(forResource: "Covid19WorldwideData", withExtension: "json") else {
                return Just(Result.failure(ErrorType.general)).eraseToAnyPublisher()
            }
            
            let data = try Data(contentsOf: resourcePath)
            let parsedData = try JSONDecoder().decode(WorldwideResponseItem.self, from: data)
            
            return Just(Result.success(parsedData))
                .eraseToAnyPublisher()
        }
        
        catch {
            print("Error \(error)")
            return Just(Result.failure(ErrorType.general)).eraseToAnyPublisher()
        }
    }
}
