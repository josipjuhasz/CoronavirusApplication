//
//  MapViewModelFrameworkUnitTests.swift
//  Coronavirus AppTests
//
//  Created by Josip Juhasz on 16.07.2022..
//

import XCTest
import Cuckoo
import Nimble
import Quick
import Combine
import MapKit

@testable import Coronavirus_App

class MapViewModelFrameworkUnitTests: QuickSpec {

    override func spec(){
        describe("Test for view model") {
            let mockRepository = MockStatisticsRepositoryImpl()
            var sut: MapViewModel!
            
            context("Worldwide initialized successfully") {
                beforeEach {
                    stubWorldwide(error: nil)
                    sut = MapViewModel(repository: mockRepository, useCase: .worldwide)
                }
                
                it("Test view model properties"){
                    expect(sut.useCase).to(equal(.worldwide))
                    expect(sut.loader).to(beFalse())
                    expect(sut.error).to(beNil())
                    expect(sut.domainItem).notTo(beNil())
                }
                
                it("Test worldwide data") {
                    expect(sut.domainItem).notTo(beNil())
                    expect(sut.domainItem?.countryCoordinates).to(beNil())
                    expect(sut.domainItem?.worldwideItems).notTo(beNil())
                    expect(sut.domainItem?.title).notTo(beNil())
                    expect(sut.domainItem?.confirmedCases).notTo(beNil())
                    expect(sut.domainItem?.activeCases).notTo(beNil())
                    expect(sut.domainItem?.recoveredCases).notTo(beNil())
                    expect(sut.domainItem?.deathCases).notTo(beNil())
                    
                    expect(sut.domainItem?.title).to(equal("Worldwide"))
                    expect(sut.domainItem?.confirmedCases?.value).to(equal(475130090))
                }
                
                it("Test view model updateDomain method") {
                    let annotation = MKAnnotationView()
                    let domain = sut.domainItem
                    
                    if let annotation = annotation.annotation {
                        sut.updateDomain(annotation: annotation)
                    }
                    
                    expect(sut.domainItem).to(equal(domain))
                }
            }
            
            context("Worldwide initialized with error") {
                beforeEach {
                    stubWorldwide(error: .general)
                    sut = MapViewModel(repository: mockRepository, useCase: .worldwide)
                }
                
                it("Test view model properties"){
                    expect(sut.useCase).to(equal(.worldwide))
                    expect(sut.loader).to(beFalse())
                    expect(sut.error).to(equal(.general))
                    expect(sut.domainItem).to(beNil())
                }
            }
            
            context("Country initialized with error") {
                beforeEach {
                    stubCountry(error: .general)
                    sut = MapViewModel(repository: mockRepository, useCase: .country(""))
                }
                
                it("Test view model properties"){
                    expect(sut.useCase).to(equal(.country("")))
                    expect(sut.loader).to(beFalse())
                    expect(sut.error).to(equal(.general))
                    expect(sut.domainItem).to(beNil())
                }
            }
            
            context("Country initialized successfully") {
                beforeEach {
                    stubCountry(error: nil)
                    sut = MapViewModel(repository: mockRepository, useCase: .country("croatia"))
                }
                
                it("Test view model properties"){
                    expect(sut.useCase).to(equal(.country("croatia")))
                    expect(sut.loader).to(beFalse())
                    expect(sut.error).to(beNil())
                    expect(sut.domainItem).notTo(beNil())
                }
                
                it("Test Country data") {
                    expect(sut.domainItem).notTo(beNil())
                    expect(sut.domainItem?.countryCoordinates).notTo(beNil())
                    expect(sut.domainItem?.worldwideItems).to(beNil())
                    expect(sut.domainItem?.title).notTo(beNil())
                    expect(sut.domainItem?.confirmedCases).notTo(beNil())
                    expect(sut.domainItem?.activeCases).notTo(beNil())
                    expect(sut.domainItem?.recoveredCases).notTo(beNil())
                    expect(sut.domainItem?.deathCases).notTo(beNil())
                    
                    expect(sut.domainItem?.title).to(equal("Croatia"))
                    expect(sut.domainItem?.countryCoordinates?.count).to(equal(1))
                    expect(sut.domainItem?.confirmedCases?.value).to(equal(1073527))
                }
                
                it("Test view model updateDomain method") {
                    let annotation = MKAnnotationView()
                    let domain = sut.domainItem
                    
                    if let annotation = annotation.annotation {
                        sut.updateDomain(annotation: annotation)
                    }
                    
                    expect(sut.domainItem).to(equal(domain))
                }
            }
            
            func stubWorldwide(error: ErrorType?){
                if let error = error {
                    stub(mockRepository){ stub in
                        let publisher = Just<Result<WorldwideResponseItem, ErrorType>>(.failure(error)).eraseToAnyPublisher()
                        when(stub.getWorldwideData()).thenReturn(publisher)
                    }
                    
                } else {
                    stub(mockRepository){ stub in
                        guard let response: WorldwideResponseItem = MockUtils.decodeResource(fileName: "Covid19WorldwideData") else { return }
                        let publisher = Just<Result<WorldwideResponseItem, ErrorType>>(.success(response)).eraseToAnyPublisher()
                        when(stub.getWorldwideData()).thenReturn(publisher)
                    }
                    
                    stub(mockRepository){ stub in
                        guard let response: [CountryDayOneResponseItem] = MockUtils.decodeResource(fileName: "Covid19CroatiaDayOneData") else { return }
                        let publisher = Just<Result<[CountryDayOneResponseItem], ErrorType>>(.success(response)).eraseToAnyPublisher()
                        when(stub.getCountryData(for: any())).thenReturn(publisher)
                    }
                }
            }
            
            func stubCountry(error: ErrorType?){
                if let error = error {
                    stub(mockRepository){ stub in
                        let publisher = Just<Result<[CountryDayOneResponseItem], ErrorType>>(.failure(error)).eraseToAnyPublisher()
                        when(stub.getCountryData(for: any())).thenReturn(publisher)
                    }
                    
                } else {
                    stub(mockRepository){ stub in
                        guard let response: [CountryDayOneResponseItem] = MockUtils.decodeResource(fileName: "Covid19CroatiaDayOneData") else { return }
                        let publisher = Just<Result<[CountryDayOneResponseItem], ErrorType>>(.success(response)).eraseToAnyPublisher()
                        when(stub.getCountryData(for: any())).thenReturn(publisher)
                    }
                }
            }
        }
    }
    
}
