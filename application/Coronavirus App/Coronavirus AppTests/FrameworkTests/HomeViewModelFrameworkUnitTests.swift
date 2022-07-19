//
//  HomeViewModelFrameworkUnitTests.swift
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

class HomeViewModelFrameworkUnitTests: QuickSpec {
    
    override func spec(){
        describe("Test for view model") {
            let mockRepository = MockStatisticsRepositoryImpl()
            var sut: HomeViewModel!
            
            context("Viewmodel with worldwide usecase initialized successfully") {
                beforeEach {
                    stubWorldwide(error: nil)
                    sut = HomeViewModel(repository: mockRepository, useCase: .worldwide)
                }
                
                it("Test view model properties"){
                    expect(sut.useCase).to(equal(.worldwide))
                    expect(sut.loader).to(beFalse())
                    expect(sut.error).to(beNil())
                    expect(sut.data).notTo(beNil())
                }
                
                it("Test worldwide data") {
                    expect(sut.data).notTo(beNil())
                    expect(sut.data?.listStats).notTo(beNil())
                    expect(sut.data?.lastUpdateDate).notTo(beNil())
                    expect(sut.data?.title).notTo(beNil())
                    expect(sut.data?.confirmedCases).notTo(beNil())
                    expect(sut.data?.activeCases).notTo(beNil())
                    expect(sut.data?.recoveredCases).notTo(beNil())
                    expect(sut.data?.deathCases).notTo(beNil())
                    
                    expect(sut.data?.title).to(equal("Worldwide"))
                    expect(sut.data?.listStats?.count).to(equal(10))
                    expect(sut.data?.confirmedCases?.value).to(equal(475130090))
                }
                
                it("Test view model handleHeaderButtonAction method") {
                    sut.handleHeaderButtonAction()
                    
                    expect(sut.isShowingCountrySelection).to(beTrue())
                }
                
                it("Test view model handleOnAppearEvent method") {
                    var isBouncing = true
                    sut.handleOnAppearEvent(&isBouncing)
                    
                    expect(isBouncing).to(beFalse())
                }
            }
            
            context("Viewmodel with worldwide usecase initialized with error") {
                beforeEach {
                    stubWorldwide(error: .general)
                    sut = HomeViewModel(repository: mockRepository, useCase: .worldwide)
                }
                
                it("Test view model properties"){
                    expect(sut.useCase).to(equal(.worldwide))
                    expect(sut.loader).to(beFalse())
                    expect(sut.error).to(equal(.general))
                    expect(sut.data).to(beNil())
                }
            }
            
            context("Viewmodel with country usecase initialized successfully") {
                beforeEach {
                    stubCountry(error: nil)
                    sut = HomeViewModel(repository: mockRepository, useCase: .country("croatia"))
                }
                
                it("Test view model properties"){
                    expect(sut.useCase).to(equal(.country("croatia")))
                    expect(sut.loader).to(beFalse())
                    expect(sut.error).to(beNil())
                    expect(sut.data).notTo(beNil())
                }
                
                it("Test Country data") {
                    expect(sut.data).notTo(beNil())
                    expect(sut.data?.listStats).notTo(beNil())
                    expect(sut.data?.lastUpdateDate).notTo(beNil())
                    expect(sut.data?.title).notTo(beNil())
                    expect(sut.data?.confirmedCases).notTo(beNil())
                    expect(sut.data?.activeCases).notTo(beNil())
                    expect(sut.data?.recoveredCases).notTo(beNil())
                    expect(sut.data?.deathCases).notTo(beNil())
                    
                    expect(sut.data?.title).to(equal("Croatia"))
                    expect(sut.data?.listStats?.count).to(equal(10))
                    expect(sut.data?.confirmedCases?.value).to(equal(1073527))
                }
                
                it("Test view model handleHeaderButtonAction method") {
                    sut.handleHeaderButtonAction()
                    
                    expect(sut.isShowingCountrySelection).to(beTrue())
                }
                
                it("Test view model handleOnAppearEvent method") {
                    var isBouncing = true
                    sut.handleOnAppearEvent(&isBouncing)
                    
                    expect(isBouncing).to(beFalse())
                }
            }
            
            context("Viewmodel with country usecase initialized with error") {
                beforeEach {
                    stubCountry(error: .general)
                    sut = HomeViewModel(repository: mockRepository, useCase: .country(""))
                }
                
                it("Test view model properties"){
                    expect(sut.useCase).to(equal(.country("")))
                    expect(sut.loader).to(beFalse())
                    expect(sut.error).to(equal(.general))
                    expect(sut.data).to(beNil())
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
                        when(stub.getCountryData(for: "croatia")).thenReturn(publisher)
                    }
                }
            }
        }
    }
}
