//
//  StatisticsRepository.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 21.03.2022..
//

import Foundation
import Combine

protocol StatisticsRepository {
    
    func getCountryData(for name: String) -> AnyPublisher<[CountryDayOneResponseItem], ErrorType>
    func getWorldwideData() -> AnyPublisher<WorldwideResponseItem, ErrorType>
}
