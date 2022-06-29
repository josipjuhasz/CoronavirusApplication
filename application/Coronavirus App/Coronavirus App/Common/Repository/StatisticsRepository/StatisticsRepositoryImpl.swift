//
//  StatisticsRepositoryImpl.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 21.03.2022..
//

import Foundation
import Combine

class StatisticsRepositoryImpl: StatisticsRepository {
    
    func getCountryData(for name: String) -> AnyPublisher<[CountryDayOneResponseItem], ErrorType> {
        let url = RestEndpoints.countryStats(name: name).endpoint()
        let publisher: AnyPublisher<[CountryDayOneResponseItem], ErrorType> = RestManager().fetchData(url: url)
        
        return publisher
            .map { countries in
                countries
                    .sorted(by: { $0.date > $1.date })
            }
            .eraseToAnyPublisher()
    }
    
    func getWorldwideData() -> AnyPublisher<WorldwideResponseItem, ErrorType> {
        let url = RestEndpoints.worldwideStats.endpoint()
        let publisher: AnyPublisher<WorldwideResponseItem, ErrorType> = RestManager().fetchData(url: url)
        
        return publisher
            .map { response in
                var item = response
                item.countries = Array(
                    response.countries
                        .filter { $0.countryName != "United States of America" }
                        .sorted(by: { $0.totalConfirmed > $1.totalConfirmed })
                        .prefix(3)
                )
                return item
            }
            .eraseToAnyPublisher()
    }
}
