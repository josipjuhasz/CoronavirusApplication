//
//  HomeViewModel.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 23.03.2022..
//

import Foundation
import Combine


class HomeViewModel: ObservableObject {
    
    private let repository: StatisticsRepository
    
    @Published var useCase: UseCaseSelection
    @Published var error: ErrorType?
    @Published var loader = true
    @Published var data: HomeDomainItem?
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(repository: StatisticsRepository, useCase: UseCaseSelection){
        self.repository = repository
        self.useCase = useCase
        getData()
    }
    
    func getData(){
        $useCase
            .flatMap { [unowned self] value -> AnyPublisher<HomeDomainItem, ErrorType> in
                self.loader = true
                self.error = nil
                
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
                self.data = response
                self.loader = false
                self.error = nil
            }
            .store(in: &cancellables)
    }
    
    private func countryPipeline(name: String) -> AnyPublisher<HomeDomainItem, ErrorType> {
        repository
            .getCountryData(for: name)
            .tryMap { response in
                do {
                    return try HomeDomainItem(response: response)
                }
                catch {
                    throw ErrorType.empty
                }
            }
            .mapError{ $0.asErrorType}
            .eraseToAnyPublisher()
    }
    
    private func worldwidePipeline() -> AnyPublisher<HomeDomainItem, ErrorType> {
        repository
            .getWorldwideData()
            .tryMap { response in
                do {
                    return try HomeDomainItem(response: response)
                }
                catch {
                    throw ErrorType.empty
                }
            }
            .mapError{ $0.asErrorType}
            .eraseToAnyPublisher()
    }
}
