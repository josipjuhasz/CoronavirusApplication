//
//  CountrySelectionViewModel.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 20.01.2022..
//

import Foundation
import Combine
import SwiftUI

class CountrySelectionViewModel: ObservableObject {
    
    private let repository: CountriesSelectionRepository
    
    @Published var countries: [CountryDetails]?
    @Published var error: ErrorType?
    @Published var loader = true
    @Published var searchText = ""
    private var baseCountries: [CountryDetails]?
    
    private let countriesSubject = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(repository: CountriesSelectionRepository){
        self.repository = repository
        initPipelines()
        filterCountries()
    }
    
    private func initPipelines() {
        countriesSubject
            .flatMap { [weak self] _ -> AnyPublisher<Result<[CountryDetails], ErrorType>, Never> in
                guard let self = self else {
                    return Just(
                        Result.failure(ErrorType.general)).eraseToAnyPublisher()
                }
                
                self.error = nil
                self.loader = true
                
                return self.repository.getCountriesList()
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let item):
                    self.countries = item.sorted(by: {$0.name < $1.name})
                    self.baseCountries = item.sorted(by: {$0.name < $1.name})
                    self.loader = false
                    self.error = nil
                    
                case .failure(let error):
                    self.loader = false
                    self.error = error
                }
            }
            .store(in: &cancellables)
        
        countriesSubject.send()
    }
    
    private func filterCountries() {
        $searchText
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                
                if !self.searchText.isEmpty {
                    self.countries = self.baseCountries?.filter {
                        $0.name.localizedCaseInsensitiveContains(value)
                    }
                } else {
                    self.countries = self.baseCountries
                }
            })
            .store(in: &cancellables)
    }
    
    func handleListItemOnTapGesture(useCase: inout UseCaseSelection, value: UseCaseSelection) {
        useCase = value
    }
    
    func errorActionCallback(){
        countriesSubject.send()
    }
}


