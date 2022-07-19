//
//  LatestNewsViewModelUnitTests.swift
//  Coronavirus AppTests
//
//  Created by Josip Juhasz on 14.07.2022..
//

import XCTest
@testable import Coronavirus_App

class LatestNewsViewModelNativeUnitTests: XCTestCase {
    
    var sut: LatestNewsViewModel!
    
    override func setUpWithError() throws {
        sut = LatestNewsViewModel(repository: LatestNewsRepositoryMock())
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testSuccessfullyInitializedViewModel(){
        // Then
        XCTAssertNotNil(sut.news)
        XCTAssertFalse(sut.loader)
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.isWebViewPresented)
        XCTAssertFalse(sut.isLastNews)
    }
    
    func testIsWebViewPresentedOnPresentedCase(){
        // When
        sut.handleWebViewPresentation(
            status: .presented,
            item: LatestNewsDetails(title: "", description: "", url: "", source: "", image: "", date: "")
        )
        
        // Then
        XCTAssertTrue(sut.isWebViewPresented)
    }
    
    func testIsWebViewPresentedOnDismissedCase(){
        // When
        sut.handleWebViewPresentation(status: .presented)
        
        // Then
        XCTAssertFalse(sut.isWebViewPresented)
    }
    
    func testHandleOnAppearEvent(){
        // Given
        var isBouncing = false
        
        // When
        sut.handleOnAppearEvent(&isBouncing)
        
        // Then
        XCTAssertTrue(isBouncing)
    }
}
