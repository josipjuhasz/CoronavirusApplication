//
//  CountrySelectionViewModel.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 20.01.2022..
//

import Foundation
import Combine

class CountrySelectionViewModel: ObservableObject {
    
    private var repository: CountriesSelectionRepository
    
    @Published var countries: [Country] = []
    @Published var error: ErrorType?
    @Published var loader = true
    @Published var searchText = ""
    private var baseCountries: [Country] = []
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(repository: CountriesSelectionRepository){
        self.repository = repository
        getAllCountries()
        filterCountries()
    }
    
    func getAllCountries() {
        repository
            .getCountriesList()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [unowned self] completion in
                if case let .failure(error) = completion {
                    self.error = error
                    self.loader = false
                }
            }, receiveValue: { [unowned self] result in
                let newCountries = result.sorted(by: {$0.name < $1.name})
                self.baseCountries = newCountries
                self.countries = newCountries
                self.loader = false
                self.error = nil
            })
            .store(in: &cancellables)
    }
    
    private func filterCountries() {
        $searchText
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] value in
                
                if !self.searchText.isEmpty {
                    self.countries = self.baseCountries.filter {
                        $0.name.localizedCaseInsensitiveContains(value)
                    }
                } else {
                    self.countries = self.baseCountries
                }
            })
            .store(in: &cancellables)
    }
}


