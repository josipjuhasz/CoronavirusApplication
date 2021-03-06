// MARK: - Mocks generated from file: Coronavirus App/Common/Repository/CountriesSelectionRepository/CountriesSelectionRepositoryImpl.swift at 2022-07-18 10:27:48 +0000

//
//  CountriesSelectionRepositoryImpl.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 03.02.2022..
//

import Cuckoo
@testable import Coronavirus_App

import Combine
import Foundation






 class MockCountriesSelectionRepositoryImpl: CountriesSelectionRepositoryImpl, Cuckoo.ClassMock {
    
     typealias MocksType = CountriesSelectionRepositoryImpl
    
     typealias Stubbing = __StubbingProxy_CountriesSelectionRepositoryImpl
     typealias Verification = __VerificationProxy_CountriesSelectionRepositoryImpl

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: CountriesSelectionRepositoryImpl?

     func enableDefaultImplementation(_ stub: CountriesSelectionRepositoryImpl) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func getCountriesList() -> AnyPublisher<Result<[CountryDetails], ErrorType>, Never> {
        
    return cuckoo_manager.call(
    """
    getCountriesList() -> AnyPublisher<Result<[CountryDetails], ErrorType>, Never>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.getCountriesList()
                ,
            defaultCall: __defaultImplStub!.getCountriesList())
        
    }
    
    

     struct __StubbingProxy_CountriesSelectionRepositoryImpl: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getCountriesList() -> Cuckoo.ClassStubFunction<(), AnyPublisher<Result<[CountryDetails], ErrorType>, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockCountriesSelectionRepositoryImpl.self, method:
    """
    getCountriesList() -> AnyPublisher<Result<[CountryDetails], ErrorType>, Never>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_CountriesSelectionRepositoryImpl: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getCountriesList() -> Cuckoo.__DoNotUse<(), AnyPublisher<Result<[CountryDetails], ErrorType>, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getCountriesList() -> AnyPublisher<Result<[CountryDetails], ErrorType>, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}

 class CountriesSelectionRepositoryImplStub: CountriesSelectionRepositoryImpl {
    

    

    
    
    
    
     override func getCountriesList() -> AnyPublisher<Result<[CountryDetails], ErrorType>, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Result<[CountryDetails], ErrorType>, Never>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Coronavirus App/Common/Repository/CovidScannerRepository/CovidScannerRepositoryImpl.swift at 2022-07-18 10:27:48 +0000

//
//  CovidScannerRepositoryImpl.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 13.06.2022..
//

import Cuckoo
@testable import Coronavirus_App

import Combine
import EUDCC
import Foundation






 class MockCovidScannerRepositoryImpl: CovidScannerRepositoryImpl, Cuckoo.ClassMock {
    
     typealias MocksType = CovidScannerRepositoryImpl
    
     typealias Stubbing = __StubbingProxy_CovidScannerRepositoryImpl
     typealias Verification = __VerificationProxy_CovidScannerRepositoryImpl

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: CovidScannerRepositoryImpl?

     func enableDefaultImplementation(_ stub: CovidScannerRepositoryImpl) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func getCertificateDetails(_ code: String) -> AnyPublisher<Result<EUDCC, ErrorType>, Never> {
        
    return cuckoo_manager.call(
    """
    getCertificateDetails(_: String) -> AnyPublisher<Result<EUDCC, ErrorType>, Never>
    """,
            parameters: (code),
            escapingParameters: (code),
            superclassCall:
                
                super.getCertificateDetails(code)
                ,
            defaultCall: __defaultImplStub!.getCertificateDetails(code))
        
    }
    
    

     struct __StubbingProxy_CovidScannerRepositoryImpl: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getCertificateDetails<M1: Cuckoo.Matchable>(_ code: M1) -> Cuckoo.ClassStubFunction<(String), AnyPublisher<Result<EUDCC, ErrorType>, Never>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: code) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCovidScannerRepositoryImpl.self, method:
    """
    getCertificateDetails(_: String) -> AnyPublisher<Result<EUDCC, ErrorType>, Never>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_CovidScannerRepositoryImpl: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getCertificateDetails<M1: Cuckoo.Matchable>(_ code: M1) -> Cuckoo.__DoNotUse<(String), AnyPublisher<Result<EUDCC, ErrorType>, Never>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: code) { $0 }]
            return cuckoo_manager.verify(
    """
    getCertificateDetails(_: String) -> AnyPublisher<Result<EUDCC, ErrorType>, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}

 class CovidScannerRepositoryImplStub: CovidScannerRepositoryImpl {
    

    

    
    
    
    
     override func getCertificateDetails(_ code: String) -> AnyPublisher<Result<EUDCC, ErrorType>, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Result<EUDCC, ErrorType>, Never>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Coronavirus App/Common/Repository/LatestNewsRepository/LatestNewsRepositoryImpl.swift at 2022-07-18 10:27:48 +0000

//
//  LatestNewsRepositoryImpl.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 13.05.2022..
//

import Cuckoo
@testable import Coronavirus_App

import Combine
import Foundation






 class MockLatestNewsRepositoryImpl: LatestNewsRepositoryImpl, Cuckoo.ClassMock {
    
     typealias MocksType = LatestNewsRepositoryImpl
    
     typealias Stubbing = __StubbingProxy_LatestNewsRepositoryImpl
     typealias Verification = __VerificationProxy_LatestNewsRepositoryImpl

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: LatestNewsRepositoryImpl?

     func enableDefaultImplementation(_ stub: LatestNewsRepositoryImpl) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func getLatestNews(offset: Int) -> AnyPublisher<Result<LatestNewsResponseItem, ErrorType>, Never> {
        
    return cuckoo_manager.call(
    """
    getLatestNews(offset: Int) -> AnyPublisher<Result<LatestNewsResponseItem, ErrorType>, Never>
    """,
            parameters: (offset),
            escapingParameters: (offset),
            superclassCall:
                
                super.getLatestNews(offset: offset)
                ,
            defaultCall: __defaultImplStub!.getLatestNews(offset: offset))
        
    }
    
    

     struct __StubbingProxy_LatestNewsRepositoryImpl: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getLatestNews<M1: Cuckoo.Matchable>(offset: M1) -> Cuckoo.ClassStubFunction<(Int), AnyPublisher<Result<LatestNewsResponseItem, ErrorType>, Never>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: offset) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLatestNewsRepositoryImpl.self, method:
    """
    getLatestNews(offset: Int) -> AnyPublisher<Result<LatestNewsResponseItem, ErrorType>, Never>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_LatestNewsRepositoryImpl: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getLatestNews<M1: Cuckoo.Matchable>(offset: M1) -> Cuckoo.__DoNotUse<(Int), AnyPublisher<Result<LatestNewsResponseItem, ErrorType>, Never>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: offset) { $0 }]
            return cuckoo_manager.verify(
    """
    getLatestNews(offset: Int) -> AnyPublisher<Result<LatestNewsResponseItem, ErrorType>, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}

 class LatestNewsRepositoryImplStub: LatestNewsRepositoryImpl {
    

    

    
    
    
    
     override func getLatestNews(offset: Int) -> AnyPublisher<Result<LatestNewsResponseItem, ErrorType>, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Result<LatestNewsResponseItem, ErrorType>, Never>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Coronavirus App/Common/Repository/StatisticsRepository/StatisticsRepositoryImpl.swift at 2022-07-18 10:27:48 +0000

//
//  StatisticsRepositoryImpl.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 21.03.2022..
//

import Cuckoo
@testable import Coronavirus_App

import Combine
import Foundation






 class MockStatisticsRepositoryImpl: StatisticsRepositoryImpl, Cuckoo.ClassMock {
    
     typealias MocksType = StatisticsRepositoryImpl
    
     typealias Stubbing = __StubbingProxy_StatisticsRepositoryImpl
     typealias Verification = __VerificationProxy_StatisticsRepositoryImpl

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: StatisticsRepositoryImpl?

     func enableDefaultImplementation(_ stub: StatisticsRepositoryImpl) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     override func getCountryData(for name: String) -> AnyPublisher<Result<[CountryDayOneResponseItem], ErrorType>, Never> {
        
    return cuckoo_manager.call(
    """
    getCountryData(for: String) -> AnyPublisher<Result<[CountryDayOneResponseItem], ErrorType>, Never>
    """,
            parameters: (name),
            escapingParameters: (name),
            superclassCall:
                
                super.getCountryData(for: name)
                ,
            defaultCall: __defaultImplStub!.getCountryData(for: name))
        
    }
    
    
    
    
    
     override func getWorldwideData() -> AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never> {
        
    return cuckoo_manager.call(
    """
    getWorldwideData() -> AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.getWorldwideData()
                ,
            defaultCall: __defaultImplStub!.getWorldwideData())
        
    }
    
    

     struct __StubbingProxy_StatisticsRepositoryImpl: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getCountryData<M1: Cuckoo.Matchable>(for name: M1) -> Cuckoo.ClassStubFunction<(String), AnyPublisher<Result<[CountryDayOneResponseItem], ErrorType>, Never>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: name) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockStatisticsRepositoryImpl.self, method:
    """
    getCountryData(for: String) -> AnyPublisher<Result<[CountryDayOneResponseItem], ErrorType>, Never>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getWorldwideData() -> Cuckoo.ClassStubFunction<(), AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockStatisticsRepositoryImpl.self, method:
    """
    getWorldwideData() -> AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_StatisticsRepositoryImpl: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getCountryData<M1: Cuckoo.Matchable>(for name: M1) -> Cuckoo.__DoNotUse<(String), AnyPublisher<Result<[CountryDayOneResponseItem], ErrorType>, Never>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: name) { $0 }]
            return cuckoo_manager.verify(
    """
    getCountryData(for: String) -> AnyPublisher<Result<[CountryDayOneResponseItem], ErrorType>, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getWorldwideData() -> Cuckoo.__DoNotUse<(), AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getWorldwideData() -> AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}

 class StatisticsRepositoryImplStub: StatisticsRepositoryImpl {
    

    

    
    
    
    
     override func getCountryData(for name: String) -> AnyPublisher<Result<[CountryDayOneResponseItem], ErrorType>, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Result<[CountryDayOneResponseItem], ErrorType>, Never>).self)
    }
    
    
    
    
    
     override func getWorldwideData() -> AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never>).self)
    }
    
    
}




