//
//  HomeViewModelUnitTests.swift
//  Coronavirus AppTests
//
//  Created by Josip Juhasz on 14.07.2022..
//

import XCTest
@testable import Coronavirus_App

class HomeViewModelNativeUnitTests: XCTestCase {
    
    var sut: HomeViewModel!
    
    override func setUpWithError() throws {
        sut = HomeViewModel(repository: StatisticsRepositoryMock(), useCase: .worldwide)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testSuccessfullyInitializedViewModel(){
        // Then
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.loader)
        XCTAssertNotNil(sut.data)
        XCTAssertNotNil(sut.data?.listStats)
        XCTAssertNotNil(sut.data?.lastUpdateDate)
        XCTAssertNotNil(sut.data?.activeCases)
        XCTAssertNotNil(sut.data?.recoveredCases)
        XCTAssertNotNil(sut.data?.deathCases)
        XCTAssertNotNil(sut.data?.confirmedCases)
        XCTAssertNotNil(sut.data?.title)
    }
    
    func testIsShowingCountrySelectionWhenButtonPressed(){
        // When
        sut.handleHeaderButtonAction()
        
        // Then
        XCTAssertTrue(sut.isShowingCountrySelection)
    }
    
    func testHandleOnAppearEvent(){
        // Given
        var isBouncing = true
        
        // When
        sut.handleOnAppearEvent(&isBouncing)
        
        // Then
        XCTAssertEqual(isBouncing, false)
    }
}
