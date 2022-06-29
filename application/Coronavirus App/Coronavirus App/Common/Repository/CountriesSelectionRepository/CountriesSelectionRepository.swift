//
//  CountriesSelectionRepository.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 03.02.2022..
//

import Foundation
import Combine

protocol CountriesSelectionRepository {
    
    func getCountriesList() -> AnyPublisher<[Country], ErrorType>
}
