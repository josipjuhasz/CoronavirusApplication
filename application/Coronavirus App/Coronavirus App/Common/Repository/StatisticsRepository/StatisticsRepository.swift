//
//  StatisticsRepository.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 21.03.2022..
//

import Foundation
import Combine

protocol StatisticsRepository {
    
    func getCountryData(for name: String) -> AnyPublisher<Result<[CountryDayOneResponseItem], ErrorType>, Never>
    func getWorldwideData() -> AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never>
}
