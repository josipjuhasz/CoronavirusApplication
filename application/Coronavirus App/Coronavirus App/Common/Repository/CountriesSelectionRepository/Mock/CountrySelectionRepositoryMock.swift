//
//  CountrySelectionMock.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 18.02.2022..
//

import Foundation
import Combine

class CountrySelectionRepositoryMock: CountriesSelectionRepository {
    
    func getCountriesList() -> AnyPublisher<[Country], ErrorType> {
        do {
            guard let resourcePath = Bundle.main.url(forResource: "Covid19CountryList", withExtension: "json") else {
                return Fail(error: ErrorType.empty).eraseToAnyPublisher()
            }
            let data = try Data(contentsOf: resourcePath)
            let parsedData = try JSONDecoder().decode([Country].self, from: data)
            
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

