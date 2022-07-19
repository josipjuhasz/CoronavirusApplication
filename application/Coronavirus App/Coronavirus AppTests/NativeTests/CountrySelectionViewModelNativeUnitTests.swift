//
//  CountrySelectionViewModelUnitTests.swift
//  Coronavirus AppTests
//
//  Created by Josip Juhasz on 15.07.2022..
//

import XCTest
@testable import Coronavirus_App

class CountrySelectionViewModelNativeUnitTests: XCTestCase {
    
    var sut: CountrySelectionViewModel!

    override func setUpWithError() throws {
        sut = CountrySelectionViewModel(repository: CountrySelectionRepositoryMock())
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testSuccessfullyInitializedViewModel(){
        // Then
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.loader)
        XCTAssertNotNil(sut.countries)
        XCTAssertEqual(sut.searchText, "")
    }
    
    func testHandleListItemOnTapGesture(){
        // Given
        var expected: UseCaseSelection = .worldwide
        let actual: UseCaseSelection = .country("croatia")
        
        // When
        sut.handleListItemOnTapGesture(useCase: &expected, value: actual)
        
        // Then
        XCTAssertEqual(expected, actual)
    }
}
