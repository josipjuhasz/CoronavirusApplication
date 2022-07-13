//
//  CountrySelectionMock.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 18.02.2022..
//

import Foundation
import Combine

class CountrySelectionRepositoryMock: CountriesSelectionRepository {
    
    func getCountriesList() -> AnyPublisher<Result<[CountryDetails], ErrorType>, Never> {
        do {
            guard let resourcePath = Bundle.main.url(forResource: "Covid19CountryList", withExtension: "json") else {
                return Just(Result.failure(ErrorType.general)).eraseToAnyPublisher()
            }
            let data = try Data(contentsOf: resourcePath)
            let parsedData = try JSONDecoder().decode([CountryDetails].self, from: data)
            
            return Just(Result.success(parsedData))
                .eraseToAnyPublisher()
        }
        
        catch {
            print("Error \(error)")
            return Just(Result.failure(ErrorType.general)).eraseToAnyPublisher()
        }
    }
}

