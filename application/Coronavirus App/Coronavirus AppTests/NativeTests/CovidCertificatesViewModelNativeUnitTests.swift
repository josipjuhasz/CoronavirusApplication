//
//  CovidCertificatesViewModelNativeUnitTests.swift
//  Coronavirus AppTests
//
//  Created by Josip Juhasz on 15.07.2022..
//

import XCTest
@testable import Coronavirus_App

class CovidCertificatesViewModelNativeUnitTests: XCTestCase {
    
    var sut: CovidCertificatesViewModel!

    override func setUpWithError() throws {
        let covidCertificate = "HC1:6BFOXN%TSMAHN-HISCCPV4DU30PMXK/R89PPNDC2LE%$CAJ9AIVG8QB/I:VPI7ONO4*J8/Y4IGF5JNBPINXUQXJ $U H9IRIBPI$RU2G0BI6QJAWVH/UI2YU-H6/V7Y0W*VBCZ79XQLWJM27F75R540T9S/FP1JXGGXHGTGK%12N:IN1MPK9PYL+Q6JWE 0R746QW6T3R/Q6ZC6:66746+O615F631$02VB1%96$01W.M.NEQ7VU+U-RUV*6SR6H 1PK9//0OK5UX4795Y%KBAD5II+:LQ12J%44$2%35Y.IE.KD+2H0D3ZCU7JI$2K3JQH5-Y3$PA$HSCHBI I799.Q5*PP:+P*.1D9R+Q0$*OWGOKEQEC5L64HX6IAS3DS2980IQODPUHLO$GAHLW 70SO:GOLIROGO3T59YLLYP-HQLTQ9R0+L6G%5TW5A 6YO67N6N7E931U9N%QLXVT*VHHP7VRDSIEAP5M9N0SB9BODZV0JEY9KQ7KEWP.T2E:7*CAC:C5Z873UF C+9OB.5TDU1PT %F6NATW6513TMG.:A+5AOPG"
        
        sut = CovidCertificatesViewModel(repository: CovidScannerRepositoryImpl())
        sut.handleScannedValue(covidCertificate)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testSuccessfullyInitializedViewModel(){
        // Then
        XCTAssertNotNil(sut.data)
        XCTAssertNotNil(sut.allCertificates)
        XCTAssertNotNil(sut.validCertificates)
        XCTAssertTrue(sut.isRescan)
        XCTAssertFalse(sut.isAlertPresented)
        XCTAssertFalse(sut.isScanViewPresented)
        XCTAssertFalse(sut.isErrorSheetPresented)
        XCTAssertTrue(sut.isDetailSheetPresented)
    }
    
    func testIsRescanWhenIsDetailSheetPresentedIsTrue(){
        // When
        sut.isDetailSheetPresented = true
        
        // Then
        XCTAssertTrue(sut.isRescan)
    }
    
    func testIsRescanWhenIsErrorSheetPresentedIsTrue(){
        // When
        sut.isErrorSheetPresented = true
        
        // Then
        XCTAssertTrue(sut.isRescan)
    }
    
    func testIsRescanWhenIsErrorSheetPresentedAndIsDetailSheetPresentedAreFalse(){
        // When
        sut.isErrorSheetPresented = false
        sut.isDetailSheetPresented = false
        
        // Then
        XCTAssertFalse(sut.isRescan)
    }
    
    func testButtonTitleWhenAllCertificates(){
        // When
        sut.selectedCertificates = .allCertificates
        
        // Then
        XCTAssertEqual(sut.buttonTitle, "Show valid certificates")
    }
    
    func testButtonTitleWhenValidCertificates(){
        // When
        sut.selectedCertificates = .validCertificates
        
        // Then
        XCTAssertEqual(sut.buttonTitle, "Show all certificates")
    }
    
    func testImageNameWhenAllCertificates(){
        // When
        sut.selectedCertificates = .allCertificates
        
        // Then
        XCTAssertEqual(sut.imageName, "arrow.up")
    }
    
    func testImageNameWhenValidCertificates(){
        // When
        sut.selectedCertificates = .validCertificates
        
        // Then
        XCTAssertEqual(sut.imageName, "arrow.down")
    }
    
    func testHandleNewScanButtonAction(){
        // When
        sut.handleNewScanButtonAction()
        
        // Then
        XCTAssertTrue(sut.isScanViewPresented)
    }
    
    func testHandleDeleteButtonAction(){
        // Given
        var isAlertPresented = false
        
        // When
        sut.handleDeleteButtonAction(&isAlertPresented)
        
        // Then
        XCTAssertTrue(isAlertPresented)
    }
    
    func testHandleErrorButtonActionWhenScanAgain(){
        // Given
        let isScanViewPresented = sut.isScanViewPresented
        
        // When
        sut.handleErrorButtonAction(.scanAgain)
        
        // Then
        XCTAssertFalse(sut.isErrorSheetPresented)
        XCTAssertEqual(isScanViewPresented, sut.isScanViewPresented)
    }
    
    func testHandleErrorButtonActionWhenBack(){
        // When
        sut.handleErrorButtonAction(.back)
        
        // Then
        XCTAssertFalse(sut.isErrorSheetPresented)
        XCTAssertFalse(sut.isScanViewPresented)
    }
    
    func testHandleOnDisappearEvent(){
        // When
        sut.handleOnDisappearEvent()
        
        // Then
        XCTAssertFalse(sut.isScanViewPresented)
    }
    
    func testHandleCertificatesTypeButtonActionWhenAllCertificates(){
        // Given
        sut.selectedCertificates = .allCertificates
        
        // When
        sut.handleCertificatesTypeButtonAction()
        
        // Then
        XCTAssertEqual(sut.selectedCertificates, .validCertificates)
    }
    
    func testHandleCertificatesTypeButtonActionWhenValidCertificates(){
        // Given
        sut.selectedCertificates = .validCertificates
        
        // When
        sut.handleCertificatesTypeButtonAction()
        
        // Then
        XCTAssertEqual(sut.selectedCertificates, .allCertificates)
    }
    
    func testHandleOKButtonAction(){
        // When
        sut.handleOKButtonAction()
        
        // Then
        XCTAssertFalse(sut.isScanViewPresented)
        XCTAssertFalse(sut.isDetailSheetPresented)
    }
    
    func testHandleAlertButtonActionWhenDefault(){
        // Given
        var isAlertPresented = true
        
        // When
        sut.handleAlertButtonAction(type: .default, isAlertPresented: &isAlertPresented)
        
        // Then
        XCTAssertFalse(isAlertPresented)
    }
    
    func testHandleAlertButtonActionWhenDestructive(){
        // Given
        var isAlertPresented = true
        
        // When
        sut.handleAlertButtonAction(type: .destructive, isAlertPresented: &isAlertPresented)
        
        // Then
        XCTAssertFalse(isAlertPresented)
    }
}
