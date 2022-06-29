//
//  MapViewModel.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 07.05.2022..
//

import Combine
import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
    
    private var repository: StatisticsRepository
    
    @Published var error: ErrorType?
    @Published var loader = true
    @Published var domainItem: MapDomainItem?
    @Published var useCase: UseCaseSelection
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(repository: StatisticsRepository, useCase: UseCaseSelection){
        self.repository = repository
        self.useCase = useCase
        initPipelines()
    }
    
    func initPipelines(){
        $useCase
            .removeDuplicates()
            .flatMap { value -> AnyPublisher<MapDomainItem, ErrorType> in
                switch value {
                case let .country(name):
                    return self.countryPipeline(name: name)
                case .worldwide:
                    return self.worldwidePipeline()
                }
            }
            .receive(on: RunLoop.main)
            .sink { [unowned self] completion in
                if case let .failure(error) = completion {
                    self.error = error
                    self.loader = false
                }
            } receiveValue: { [unowned self] response in
                self.domainItem = response
                self.loader = false
                self.error = nil
            }
            .store(in: &cancellables)
    }
    
    private func countryPipeline(name: String) -> AnyPublisher<MapDomainItem, ErrorType> {
        repository
            .getCountryData(for: name)
            .receive(on: RunLoop.main)
            .tryMap {
                do {
                    return try MapDomainItem(item: $0)
                }
                catch {
                    throw ErrorType.empty
                }
            }
            .mapError{ $0.asErrorType}
            .eraseToAnyPublisher()
    }
    
    private func worldwidePipeline() -> AnyPublisher<MapDomainItem, ErrorType> {
        repository
            .getWorldwideData()
            .receive(on: RunLoop.main)
            .flatMap { [unowned self] result -> AnyPublisher<MapDomainItem, ErrorType> in
                let firstCountry = self.repository
                    .getCountryData(for: result.countries[0].countryName ?? "")
                
                let secondCountry = self.repository
                    .getCountryData(for: result.countries[1].countryName ?? "")
                
                let thirdCountry = self.repository
                    .getCountryData(for: result.countries[2].countryName ?? "")
                
                return Publishers.Zip3(firstCountry, secondCountry, thirdCountry)
                    .tryMap { (response1, response2, response3) -> MapDomainItem in
                        do {
                            return try MapDomainItem(responseItem: result, items: (response1[0], response2[0], response3[0]))
                        }
                        catch {
                            throw ErrorType.empty
                        }
                    }
                    .mapError {$0.asErrorType}
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func updateDomain(annotation: MKAnnotation){
        if let countries = domainItem?.worldwideItems {
            for country in countries {
                if (country.lat == "\(annotation.coordinate.latitude)") {
                    let newDomain = MapDomainItem(
                        title: country.name,
                        confirmed: country.confirmed,
                        active: country.confirmed - country.recovered,
                        recovered: country.recovered,
                        death: country.deaths
                    )
                    self.domainItem = newDomain
                }
            }
        }
    }
}

