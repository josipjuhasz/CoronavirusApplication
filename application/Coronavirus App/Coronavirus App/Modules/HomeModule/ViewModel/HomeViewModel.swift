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
    @Published var data: HomeDomainItem?
    
    @Published var loader = true
    @Published var isShowingCountrySelection = false

    private let useCaseSelectionSubject: CurrentValueSubject<UseCaseSelection, Never>
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(repository: StatisticsRepository, useCase: UseCaseSelection){
        self.repository = repository
        self.useCase = useCase
        self.useCaseSelectionSubject = CurrentValueSubject<UseCaseSelection, Never>.init(useCase)
        initPipelines()
    }
    
    private func initPipelines(){
        useCaseSelectionSubject
            .flatMap { [weak self] value -> AnyPublisher<Result<HomeDomainItem, ErrorType>, Never> in
                guard let self = self else {
                    return Just(Result.failure(ErrorType.general)).eraseToAnyPublisher()
                }
                self.loader = true
                self.error = nil
                switch value {
                case let .country(name):
                    return self.countryPipeline(name: name)
                    
                case .worldwide:
                    return self.worldwidePipeline()
                }
            }
            .sink { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let item):
                    self.data = item
                    self.loader = false
                    self.error = nil
                    
                case .failure(let error):
                    self.loader = false
                    self.error = error
                }
            }
            .store(in: &cancellables)
    }
    
    private func countryPipeline(name: String) -> AnyPublisher<Result<HomeDomainItem, ErrorType>, Never> {
        repository
            .getCountryData(for: name)
            .tryMap { response in
                switch response {
                case .success(let item):
                    do {
                        return try Result.success(HomeDomainItem(response: item))
                    }
                    catch let error {
                        return Result.failure(error.asErrorType)
                    }
                case .failure(let error):
                    return Result.failure(error.asErrorType)
                }
            }
            .mapError { _ in ErrorType.general}
            .catch { Just<Result<HomeDomainItem, ErrorType>>(.failure($0)) }
            .eraseToAnyPublisher()
    }
    
    private func worldwidePipeline() -> AnyPublisher<Result<HomeDomainItem, ErrorType>, Never> {
        repository
            .getWorldwideData()
            .tryMap { response in
                switch response {
                case .success(let item):
                    return Result.success(HomeDomainItem(response: item))
                case .failure(let error):
                    return Result.failure(error.asErrorType)
                }
            }
            .mapError { _ in ErrorType.general}
            .catch { Just<Result<HomeDomainItem, ErrorType>>(.failure($0)) }
            .eraseToAnyPublisher()
    }
    
    func handleHeaderButtonAction(){
        isShowingCountrySelection = true
    }
    
    func handleOnAppearEvent(_ isBouncing: inout Bool){
        isBouncing = false
    }
    
    func errorActionCallback(){
        useCaseSelectionSubject.send(.worldwide)
    }
}
