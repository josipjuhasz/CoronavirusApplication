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
    
    private let repository: StatisticsRepository
    
    @Published var error: ErrorType?
    @Published var domainItem: MapDomainItem?
    @Published var useCase: UseCaseSelection
    @Published var loader = true
    @Published var isShowingCountrySelection = false
    
    private let useCaseSelectionSubject: CurrentValueSubject<UseCaseSelection, Never>
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(repository: StatisticsRepository, useCase: UseCaseSelection){
        self.repository = repository
        self.useCase = useCase
        useCaseSelectionSubject = CurrentValueSubject<UseCaseSelection, Never>.init(useCase)
        initPipelines()
    }
    
    private func initPipelines(){
        useCaseSelectionSubject
            .removeDuplicates()
            .flatMap { value -> AnyPublisher<Result<MapDomainItem, ErrorType>, Never> in
                switch value {
                case let .country(name):
                    return self.countryPipeline(name: name)
                case .worldwide:
                    return self.worldwidePipeline()
                }
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] response in
                guard let self = self else { return }
                
                switch response {
                case .success(let item):
                    self.domainItem = item
                    self.loader = false
                    self.error = nil
                    
                case .failure(let error):
                    self.loader = false
                    self.error = error
                }
            }
            .store(in: &cancellables)
    }
    
    private func countryPipeline(name: String) -> AnyPublisher<Result<MapDomainItem, ErrorType>, Never> {
        repository
            .getCountryData(for: name)
            .receive(on: RunLoop.main)
            .tryMap { result -> Result<MapDomainItem, ErrorType> in
                switch result {
                case .success(let data):
                    do {
                        return try Result.success(MapDomainItem(item: data))
                    }
                    catch let error {
                        return Result.failure(error.asErrorType)
                    }
                    
                case .failure(let error):
                    return Result.failure(error)
                }
            }
            .mapError { _ in ErrorType.general}
            .catch { Just<Result<MapDomainItem, ErrorType>>(.failure($0)) }
            .eraseToAnyPublisher()
    }
    
    private func worldwidePipeline() -> AnyPublisher<Result<MapDomainItem, ErrorType>, Never> {
        repository
            .getWorldwideData()
            .receive(on: RunLoop.main)
            .flatMap { [weak self] result -> AnyPublisher<Result<MapDomainItem, ErrorType>, Never> in
                guard let self = self else {
                    return Just(Result.failure(ErrorType.general)).eraseToAnyPublisher()
                }
                
                switch result {
                    
                case .success(let item):
                    return self.getMapDomainPublisher(item: item)
                    
                case .failure(let error):
                    return Just(Result.failure(error)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func getMapDomainPublisher(item: WorldwideResponseItem) -> AnyPublisher<Result<MapDomainItem, ErrorType>, Never> {
        if let firstCountryName = item.countries[0].countryName,
           let secondCountryName = item.countries[1].countryName,
           let thirdCountryName = item.countries[2].countryName
        {
            let firstCountry = self.repository.getCountryData(for: firstCountryName)
            let secondCountry = self.repository.getCountryData(for: secondCountryName)
            let thirdCountry = self.repository.getCountryData(for: thirdCountryName)
            
            return Publishers.Zip3(firstCountry, secondCountry, thirdCountry)
                .tryMap { [weak self] data -> Result<MapDomainItem, ErrorType> in
                    
                    var newData: [CountryDayOneResponseItem] = []
                    
                    guard let self = self,
                          let firstCountryData = self.getCountryData(data.0),
                          let secondCountryData = self.getCountryData(data.1),
                          let thirdCountryData = self.getCountryData(data.2)
                    else {
                        return Result.failure(ErrorType.general)
                    }
                    
                    newData.append(firstCountryData)
                    newData.append(secondCountryData)
                    newData.append(thirdCountryData)
                    
                    do {
                        return try Result.success(MapDomainItem(responseItem: item, items: newData))
                    }
                    catch let error {
                        return Result.failure(error.asErrorType)
                    }
                }
                .mapError { _ in ErrorType.general}
                .catch { Just<Result<MapDomainItem, ErrorType>>(.failure($0)) }
                .eraseToAnyPublisher()
            
        } else {
            return Just(Result.failure(ErrorType.general)).eraseToAnyPublisher()
        }
    }
    
    private func getCountryData(_ data: Result<[CountryDayOneResponseItem], ErrorType>) -> CountryDayOneResponseItem? {
        switch data {
        case .success(let item):
            return item.first
        case .failure(_):
            return nil
        }
    }
    
    func updateDomain(annotation: MKAnnotation){
        if let countries = domainItem?.worldwideItems {
            for country in countries {
                if (country.lat == "\(annotation.coordinate.latitude)") {
                    let newDomain = MapDomainItem(
                        title: country.name,
                        confirmed: StatisticsItem(value: country.confirmed),
                        active: StatisticsItem(value: country.confirmed - country.recovered),
                        recovered: StatisticsItem(value: country.recovered),
                        death: StatisticsItem(value: country.deaths)
                    )
                    domainItem = newDomain
                }
            }
        }
    }
    
    func onUseCaseSelectionChange(_ useCase: UseCaseSelection){
        useCaseSelectionSubject.send(useCase)
    }
    
    func errorActionCallback(){
        useCaseSelectionSubject.send(.worldwide)
    }
}

