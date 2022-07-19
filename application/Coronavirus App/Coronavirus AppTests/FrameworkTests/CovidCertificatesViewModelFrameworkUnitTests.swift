//
//  CovidCertificatesViewModelFrameworkUnitTests.swift
//  Coronavirus AppTests
//
//  Created by Josip Juhasz on 16.07.2022..
//

import XCTest
import Cuckoo
import Nimble
import Quick
import Combine
import EUDCC

@testable import Coronavirus_App

class CovidCertificatesViewModelFrameworkUnitTests: QuickSpec {
    
    override func spec() {
        describe("Test for view model") {
            
            let mockRepository = MockCovidScannerRepositoryImpl()
            var sut: CovidCertificatesViewModel!
            
            let covidCertificate = "HC1:6BFOXN%TSMAHN-HISCCPV4DU30PMXK/R89PPNDC2LE%$CAJ9AIVG8QB/I:VPI7ONO4*J8/Y4IGF5JNBPINXUQXJ $U H9IRIBPI$RU2G0BI6QJAWVH/UI2YU-H6/V7Y0W*VBCZ79XQLWJM27F75R540T9S/FP1JXGGXHGTGK%12N:IN1MPK9PYL+Q6JWE 0R746QW6T3R/Q6ZC6:66746+O615F631$02VB1%96$01W.M.NEQ7VU+U-RUV*6SR6H 1PK9//0OK5UX4795Y%KBAD5II+:LQ12J%44$2%35Y.IE.KD+2H0D3ZCU7JI$2K3JQH5-Y3$PA$HSCHBI I799.Q5*PP:+P*.1D9R+Q0$*OWGOKEQEC5L64HX6IAS3DS2980IQODPUHLO$GAHLW 70SO:GOLIROGO3T59YLLYP-HQLTQ9R0+L6G%5TW5A 6YO67N6N7E931U9N%QLXVT*VHHP7VRDSIEAP5M9N0SB9BODZV0JEY9KQ7KEWP.T2E:7*CAC:C5Z873UF C+9OB.5TDU1PT %F6NATW6513TMG.:A+5AOPG"
            
            context("View model initialized with error") {
                beforeEach {
                    stubCertificate(error: .general)
                    sut = CovidCertificatesViewModel(repository: mockRepository)
                    sut.handleScannedValue(covidCertificate)
                }
                
                it("Test view model properties") {
                    expect(sut.data).to(beNil())
                    expect(sut.allCertificates).to(equal([]))
                    expect(sut.validCertificates).to(equal([]))
                    expect(sut.isRescan).to(beTrue())
                    expect(sut.isAlertPresented).to(beFalse())
                    expect(sut.isScanViewPresented).to(beFalse())
                    expect(sut.isErrorSheetPresented).to(beTrue())
                    expect(sut.isDetailSheetPresented).to(beFalse())
                }
            }
            
            context("View model initialized successfully") {
                beforeEach {
                    stubCertificate(error: nil)
                    sut = CovidCertificatesViewModel(repository: mockRepository)
                    sut.handleScannedValue(covidCertificate)
                }
                
                it("Test view model properties") {
                    expect(sut.data).notTo(beNil())
                    expect(sut.allCertificates).notTo(beNil())
                    expect(sut.validCertificates).notTo(beNil())
                    expect(sut.isRescan).to(beTrue())
                    expect(sut.isAlertPresented).to(beFalse())
                    expect(sut.isScanViewPresented).to(beFalse())
                    expect(sut.isErrorSheetPresented).to(beFalse())
                    expect(sut.isDetailSheetPresented).to(beTrue())
                    
                    expect(sut.data?.title).to(equal("Biontech Pfizer21"))
                }
                
                it("Test isRescan when isErrorSheetPresented is true"){
                    sut.isErrorSheetPresented = true
                    
                    expect(sut.isRescan).to(beTrue())
                }
                
                it("Test isRescan when isDetailSheetPresented is true"){
                    sut.isDetailSheetPresented = true
                    
                    expect(sut.isRescan).to(beTrue())
                }
                
                it("Test isRescan when isDetailSheetPresented and isErrorSheetPresented are false"){
                    sut.isDetailSheetPresented = false
                    sut.isErrorSheetPresented = false
                    
                    expect(sut.isRescan).to(beFalse())
                }
                
                it("Test Button Title when selectedCertificates is allCertificates") {
                    sut.selectedCertificates = .allCertificates
                    
                    expect(sut.buttonTitle).to(equal("Show valid certificates"))
                }
                
                it("Test Button Title when selectedCertificates is validCertificates") {
                    sut.selectedCertificates = .validCertificates
                    
                    expect(sut.buttonTitle).to(equal("Show all certificates"))
                }
                
                it("Test Image Name when selectedCertificates is allCertificates") {
                    sut.selectedCertificates = .allCertificates
                    
                    expect(sut.imageName).to(equal("arrow.up"))
                }
                
                it("Test Image Name when selectedCertificates is validCertificates") {
                    sut.selectedCertificates = .validCertificates
                    
                    expect(sut.imageName).to(equal("arrow.down"))
                }
                
                it("Test handleNewScanButtonAction method"){
                    sut.handleNewScanButtonAction()
                    
                    expect(sut.isScanViewPresented).to(beTrue())
                }
                
                it("Test handleDeleteButtonAction method"){
                    var isAlertPresented = false
                    
                    sut.handleDeleteButtonAction(&isAlertPresented)
                    
                    expect(isAlertPresented).to(beTrue())
                }
                
                it("Test handleErrorButtonAction method when case is scanAgain"){
                    let isScanViewPresented = sut.isScanViewPresented
                    
                    sut.handleErrorButtonAction(.scanAgain)
                    
                    expect(sut.isErrorSheetPresented).to(beFalse())
                    expect(sut.isScanViewPresented).to(equal(isScanViewPresented))
                }
                
                it("Test handleErrorButtonAction method when case is back"){
                    sut.handleErrorButtonAction(.back)
                    
                    expect(sut.isErrorSheetPresented).to(beFalse())
                    expect(sut.isScanViewPresented).to(beFalse())
                }
                
                it("Test handleOnDisappearEvent method"){
                    sut.handleOnDisappearEvent()
                    
                    expect(sut.isScanViewPresented).to(beFalse())
                }
                
                it("Test handleCertificatesTypeButtonAction method when case is allCertificates"){
                    sut.selectedCertificates = .allCertificates
                    sut.handleCertificatesTypeButtonAction()
                    
                    expect(sut.selectedCertificates).to(equal(.validCertificates))
                }
                
                it("Test handleCertificatesTypeButtonAction method when case is validCertificates"){
                    sut.selectedCertificates = .validCertificates
                    sut.handleCertificatesTypeButtonAction()
                    
                    expect(sut.selectedCertificates).to(equal(.allCertificates))
                }
                
                it("Test handleOKButtonAction method"){
                    sut.handleOKButtonAction()
                    
                    expect(sut.isErrorSheetPresented).to(beFalse())
                    expect(sut.isDetailSheetPresented).to(beFalse())
                }
                
                it("Test handleAlertButtonAction method when button type is default"){
                    var isAlertPresented = true
                    
                    sut.handleAlertButtonAction(type: .default, isAlertPresented: &isAlertPresented)
                    
                    expect(isAlertPresented).to(beFalse())
                }
                
                it("Test handleAlertButtonAction method when button type is destructive"){
                    var isAlertPresented = true
                    
                    sut.handleAlertButtonAction(type: .destructive, isAlertPresented: &isAlertPresented)
                    
                    expect(isAlertPresented).to(beFalse())
                }
            }
            
            func stubCertificate(error: ErrorType?){
                if let error = error {
                    stub(mockRepository){ mock in
                        let publisher = Just<Result<EUDCC, ErrorType>>(.failure(error)).eraseToAnyPublisher()
                        when(mock.getCertificateDetails(any())).thenReturn(publisher)
                    }
                    
                } else {
                    stub(mockRepository){ mock in
                        
                        let response = CovidCertificateDecoder().decodeData(covidCertificate)
                        
                        when(mock.getCertificateDetails(any())).thenReturn(response)
                    }
                }
            }
        }
    }
}
