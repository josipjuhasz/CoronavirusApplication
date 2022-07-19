//
//  CountrySelectionViewModelFrameworkUnitTests.swift
//  Coronavirus AppTests
//
//  Created by Josip Juhasz on 16.07.2022..
//

import XCTest
import Cuckoo
import Nimble
import Quick
import Combine

@testable import Coronavirus_App
class CountrySelectionViewModelFrameworkUnitTests: QuickSpec {

    override func spec(){
        describe("Test for view model") {
            let mockRepository = MockCountriesSelectionRepositoryImpl()
            var sut: CountrySelectionViewModel!

            context("View model initialized successfully") {
                beforeEach {
                    stubCountries(error: nil)
                    sut = CountrySelectionViewModel(repository: mockRepository)
                }

                it("Test view model properties") {
                    expect(sut.loader).to(beFalse())
                    expect(sut.error).to(beNil())
                    expect(sut.countries).notTo(beNil())
                    expect(sut.searchText).to(equal(""))
                    
                    expect(sut.countries?[0].name).to(equal("ALA Aland Islands"))
                }
                
                it("Test view model handleListItemOnTapGesture method") {
                    var expected: UseCaseSelection = .worldwide
                    let actual: UseCaseSelection = .country("croatia")
                    
                    sut.handleListItemOnTapGesture(useCase: &expected, value: actual)
                    
                    expect(expected).to(equal(actual))
                }
            }
            
            context("View model initialized with error") {
                beforeEach {
                    stubCountries(error: .general)
                    sut = CountrySelectionViewModel(repository: mockRepository)
                }

                it("Test view model properties") {
                    expect(sut.loader).to(beFalse())
                    expect(sut.error).to(equal(.general))
                    expect(sut.countries).to(beNil())
                    expect(sut.searchText).to(equal(""))
                }
            }

            func stubCountries(error: ErrorType?){
                if let error = error {
                    stub(mockRepository){ mock in
                        let publisher = Just<Result<[CountryDetails], ErrorType>>(.failure(error)).eraseToAnyPublisher()
                        when(mock.getCountriesList()).thenReturn(publisher)
                    }
                    
                } else {
                    stub(mockRepository){ mock in
                        guard let response: [CountryDetails] = MockUtils.decodeResource(fileName: "Covid19CountryList") else { return }
                        let publisher = Just<Result<[CountryDetails], ErrorType>>(.success(response)).eraseToAnyPublisher()
                        when(mock.getCountriesList()).thenReturn(publisher)
                    }
                }
            }
        }
    }
}
