//
//  LatestNewsViewModelFrameworkUnitTests.swift
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

class LatestNewsViewModelFrameworkUnitTests: QuickSpec {

    override func spec() {
        describe("Test for view model") {
            let mockRepository = MockLatestNewsRepositoryImpl()
            var sut: LatestNewsViewModel!
            
            context("View model initialized successfully") {
                beforeEach {
                    stubLatestNews(error: nil)
                    sut = LatestNewsViewModel(repository: mockRepository)
                }

                it("Test view model properties") {
                    expect(sut.loader).to(beFalse())
                    expect(sut.error).to(beNil())
                    expect(sut.news).notTo(beNil())
                    expect(sut.count).to(equal(423))
                    expect(sut.isLastNews).to(beFalse())
                    expect(sut.isWebViewPresented).to(beFalse())
                    
                    expect(sut.news?[0].source).to(equal("CubaSi.cu"))
                }
                
                it("Test view model handleWebViewPresentation method on presented case") {
                    sut.handleWebViewPresentation(
                        status: .presented,
                        item: LatestNewsDetails(title: "", description: "", url: "", source: "", image: "", date: "")
                    )
                    
                    expect(sut.isWebViewPresented).to(beTrue())
                }
                
                it("Test view model handleWebViewPresentation method on dismissed case") {
                    sut.handleWebViewPresentation(status: .dismissed)
                    
                    expect(sut.isWebViewPresented).to(beFalse())
                }
                
                it("Test view model handleOnAppearEvent method") {
                    var isBouncing = false
                    
                    sut.handleOnAppearEvent(&isBouncing)
                    
                    expect(isBouncing).to(beTrue())
                }
            }
            
            func stubLatestNews(error: ErrorType?){
                if let error = error {
                    stub(mockRepository){ mock in
                        let publisher = Just<Result<LatestNewsResponseItem, ErrorType>>(.failure(error)).eraseToAnyPublisher()
                        when(mock.getLatestNews(offset: any())).thenReturn(publisher)
                    }
                    
                } else {
                    stub(mockRepository){ mock in
                        guard let response: LatestNewsResponseItem = MockUtils.decodeResource(fileName: "LatestNewsData") else { return }
                        let publisher = Just<Result<LatestNewsResponseItem, ErrorType>>(.success(response)).eraseToAnyPublisher()
                        when(mock.getLatestNews(offset: any())).thenReturn(publisher)
                    }
                }
            }
        }
    }
}
