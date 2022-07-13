//
//  CountriesSelectionRepositoryImpl.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 03.02.2022..
//

import Foundation
import Combine

class CountriesSelectionRepositoryImpl: CountriesSelectionRepository {
    
    func getCountriesList() -> AnyPublisher<Result<[CountryDetails], ErrorType>, Never> {
        let url = RestEndpoints.countries.endpoint()
        return RestManager.fetchData(url: url)
    }
}
