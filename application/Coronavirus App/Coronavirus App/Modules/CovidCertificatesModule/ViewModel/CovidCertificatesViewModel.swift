//
//  CovidCertificatesViewModel.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 27.06.2022..
//

import Foundation
import Combine
import EUDCC
import EUDCCDecoder
import SwiftUI

enum CertificatesListType {
    case allCertificates
    case validCertificates
}

enum AlertButtonType {
    case `default`
    case destructive
}

enum ErrorButtonType {
    case scanAgain
    case back
}

class CovidCertificatesViewModel: ObservableObject {
    
    let repository: CovidScannerRepository
    
    @Published var allCertificates: [CovidCertificateDomainItem]?
    @Published var validCertificates: [CovidCertificateDomainItem]?
    @Published var data: CovidCertificateDomainItem?

    @Published var isScanViewPresented = false
    @Published var isDetailSheetPresented = false
    @Published var isErrorSheetPresented = false
    @Published var isAlertPresented = false
    @Published var selectedCertificates: CertificatesListType = .allCertificates
    private var qrCodeRawData = ""
    
    private let certificatesListPublisher = CurrentValueSubject<[CovidCertificateEntity], Never>
        .init(CoreDataManager.shared.getCertificates())
    
    private var scannedCertificatePublisher = PassthroughSubject<String, Never>()
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(repository: CovidScannerRepository){
        self.repository = repository
        initPipelines()
    }
    
    var certificates: [CovidCertificateDomainItem]? {
        selectedCertificates == .allCertificates ? allCertificates : validCertificates
    }
    
    var isRescan: Bool {
        isDetailSheetPresented || isErrorSheetPresented
    }
    
    var buttonTitle: String {
        selectedCertificates == .allCertificates ? "Show valid certificates" : "Show all certificates"
    }
    
    var imageName: String {
        selectedCertificates == .allCertificates ? "arrow.up" : "arrow.down"
    }
    
    private func initPipelines(){
        certificatesListPublisher
            .map { [weak self] result -> Result<[CovidCertificateDomainItem], ErrorType> in
                guard let certificates = self?.getLocalCertificates(result) else {
                    return Result.failure(ErrorType.empty)
                }
                return Result.success(certificates)
            }
            .sink { _ in } receiveValue: { [weak self] result in
                switch result {
                case .success(let certificates):
                    self?.allCertificates = certificates
                    self?.setValidCertificates(certificates)
                case .failure(_):
                    self?.allCertificates = nil
                }
            }
            .store(in: &cancellables)
        
        scannedCertificatePublisher
            .flatMap { [weak self] value -> AnyPublisher<Result<EUDCC, ErrorType>, Never> in
                self?.handleValue(value)
                guard let publisher = self?.repository.getCertificateDetails(value) else {
                    return Empty().eraseToAnyPublisher()
                }
                return publisher
            }
            .map { $0 }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] result in
                switch result {
                case .success(let result):
                    do {
                        if let qrCode = self?.qrCodeRawData {
                            self?.data = try CovidCertificateDomainItem(eudcc: result, qrCodeRawData: qrCode)
                            self?.isDetailSheetPresented = true
                        }
                    }
                    catch {
                        self?.isErrorSheetPresented = true
                    }
                case .failure(_):
                    self?.isErrorSheetPresented = true
                }
            })
            .store(in: &cancellables)
    }
    
    private func getLocalCertificates(_ data: [CovidCertificateEntity]) -> [CovidCertificateDomainItem]? {
        var newCertificates: [CovidCertificateDomainItem] = []
        
        for item in data {
            if let qrCodeRawValue = item.qrCodeRawData {
                repository
                    .getCertificateDetails(qrCodeRawValue)
                    .map { result -> CovidCertificateDomainItem? in
                        switch result {
                        case .success(let eudcc):
                            do {
                                return try CovidCertificateDomainItem(eudcc: eudcc, qrCodeRawData: qrCodeRawValue)
                            }
                            catch {
                                return nil
                            }
                        case.failure(_):
                            return nil
                        }
                    }
                    .compactMap { $0 }
                    .sink { result in
                        newCertificates.append(result)
                    }
                    .store(in: &cancellables)
            }
        }

        return newCertificates.reversed()
    }
    
    private func setValidCertificates(_ data: [CovidCertificateDomainItem]){
        var newCertificates: [CovidCertificateDomainItem] = []
        
        for value in data {
            if let isCertificationValid = value.isCertificationValid, !isCertificationValid {
                newCertificates.append(value)
            }
        }
        self.validCertificates = newCertificates
    }
    
    private func handleValue(_ value: String){
        qrCodeRawData = value
        CoreDataManager.shared.addCertificate(value)
        certificatesListPublisher.send(CoreDataManager.shared.getCertificates())
    }
    
    func handleListItemTapAction(_ data: CovidCertificateDomainItem){
        self.data = data
        isDetailSheetPresented = true
    }
    
    func handleNewScanButtonAction(){
        isScanViewPresented = true
    }
    
    func handleDeleteButtonAction(_ isAlertPresented: inout Bool){
        isAlertPresented = true
    }
    
    func handleScannedValue(_ value: String){
        scannedCertificatePublisher.send(value)
    }
    
    func handleErrorButtonAction(_ buttonType: ErrorButtonType){
        switch buttonType {
        case .scanAgain:
            isErrorSheetPresented = false
        case .back:
            isErrorSheetPresented = false
            isScanViewPresented = false
        }
    }
    
    func handleOnDisappearEvent(){
        isScanViewPresented = false
    }
    
    func handleCertificatesTypeButtonAction(){
        selectedCertificates = selectedCertificates == .allCertificates ? .validCertificates : .allCertificates
    }
    
    func handleOKButtonAction(){
        isDetailSheetPresented = false
        isScanViewPresented = false
    }
    
    func handleAlertButtonAction(type: AlertButtonType, isAlertPresented: inout Bool){
        switch type {
        case .default:
            isAlertPresented = false
        case .destructive:
            deleteCertificate()
            isAlertPresented = false
        }
    }
    
    private func deleteCertificate(){
        if let data = data?.qrCodeRawData {
            CoreDataManager.shared.deleteCertificate(data)
            self.isDetailSheetPresented = false
            self.isScanViewPresented = false
            self.certificatesListPublisher.send(CoreDataManager.shared.getCertificates())
        }
    }
}
