//
//  MapViewModelUnitTests.swift
//  Coronavirus AppTests
//
//  Created by Josip Juhasz on 14.07.2022..
//

import XCTest
@testable import Coronavirus_App
import MapKit

class MapViewModelNativeUnitTests: XCTestCase {
    
    var sut: MapViewModel!
    
    override func setUpWithError() throws {
        sut = MapViewModel(repository: StatisticsRepositoryMock(), useCase: .worldwide)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testSuccessfullyInitializedViewModel(){
        // Then
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.loader)
        XCTAssertNotNil(sut.domainItem)
        XCTAssertNil(sut.domainItem?.countryCoordinates)
        XCTAssertNotNil(sut.domainItem?.worldwideItems)
        XCTAssertNotNil(sut.domainItem?.activeCases)
        XCTAssertNotNil(sut.domainItem?.recoveredCases)
        XCTAssertNotNil(sut.domainItem?.deathCases)
        XCTAssertNotNil(sut.domainItem?.confirmedCases)
        XCTAssertNotNil(sut.domainItem?.title)
    }
    
    func testUpdateDomainStaySameOnWrongAnnotation(){
        // Given
        let annotation = MKAnnotationView()
        let domain = sut.domainItem
        
        // When
        if let annotation = annotation.annotation {
            sut.updateDomain(annotation: annotation)
        }
        
        // Then
        XCTAssertEqual(sut.domainItem, domain)
    }
}
