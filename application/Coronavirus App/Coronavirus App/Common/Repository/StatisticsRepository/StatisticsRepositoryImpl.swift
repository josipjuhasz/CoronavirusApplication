//
//  StatisticsRepositoryImpl.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 21.03.2022..
//

import Foundation
import Combine

class StatisticsRepositoryImpl: StatisticsRepository {
    
    func getCountryData(for name: String) -> AnyPublisher<Result<[CountryDayOneResponseItem], ErrorType>, Never> {
        let url = RestEndpoints.countryStats(name: name).endpoint()
        let publisher: AnyPublisher<Result<[CountryDayOneResponseItem], ErrorType>, Never> = RestManager.fetchData(url: url)
        
        return publisher
            .map { response -> Result<[CountryDayOneResponseItem], ErrorType> in
                switch response {
                case .success(let countries):
                    return Result.success(countries.sorted(by: { $0.date > $1.date }))
                case .failure(let error):
                    return Result.failure(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getWorldwideData() -> AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never> {
        let url = RestEndpoints.worldwideStats.endpoint()
        let publisher: AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never> = RestManager.fetchData(url: url)
        
        return publisher
            .map { response -> Result<WorldwideResponseItem, ErrorType> in
                switch response {
                case .success(var item):
                    let newCountries = Array (
                        item.countries
                            .filter { $0.countryName != "United States of America" }
                            .sorted(by: { $0.totalConfirmed > $1.totalConfirmed })
                            .prefix(3)
                    )
                    
                    item.countries = newCountries
                    
                    return Result.success(item)
                    
                case .failure(let error):
                    return Result.failure(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
