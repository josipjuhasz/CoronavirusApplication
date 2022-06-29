//
//  StatisticsRepositoryMock.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 24.03.2022..
//

import Foundation
import Combine

class StatisticsRepositoryMock: StatisticsRepository {
    
    func getCountryData(for name: String) -> AnyPublisher<[CountryDayOneResponseItem], ErrorType> {
        do {
            guard let resourcePath = Bundle.main.url(forResource: "Covid19CroatiaDayOneData", withExtension: "json") else {
                return Fail(error: ErrorType.empty).eraseToAnyPublisher()
            }
            
            let data = try Data(contentsOf: resourcePath)
            let parsedData = try JSONDecoder().decode([CountryDayOneResponseItem].self, from: data)
            
            return Just(parsedData)
                .setFailureType(to: ErrorType.self)
                .eraseToAnyPublisher()
        }
        
        catch {
            print("Error \(error)")
            return Fail(error: ErrorType.empty).eraseToAnyPublisher()
        }
    }
    
    func getWorldwideData() -> AnyPublisher<WorldwideResponseItem, ErrorType> {
        do {
            guard let resourcePath = Bundle.main.url(forResource: "Covid19WorldwideData", withExtension: "json") else {
                return Fail(error: ErrorType.empty).eraseToAnyPublisher()
            }
            
            let data = try Data(contentsOf: resourcePath)
            let parsedData = try JSONDecoder().decode(WorldwideResponseItem.self, from: data)
            
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
