//
//  CovidCertificateDomainItem.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 26.06.2022..
//

import SwiftUI
import EUDCC
import EUDCCValidator

struct CovidCertificateDomainItem: Identifiable, Equatable {
    
    let qrCodeRawData: String
    
    let id = UUID()
    
    var icon: Image?
    var title: String?
    var subtitle: String?
    var certificateTypeDetails: String?
    var certificateGeneralInfo: String?
    var activeTitle: String?
    var dateOfBirth: String?
    var country: String?
    var certificateValidationMessage: String?
    var isCertificationValid: Bool?
    
    init(eudcc: EUDCC, qrCodeRawData: String) throws {
        self.qrCodeRawData = qrCodeRawData
        try checkCertificateType(eudcc)
    }
    
    private mutating func checkCertificateType(_ eudcc: EUDCC) throws {
        if eudcc.recovery != nil {
            try setRecoveryData(eudcc, isValid: getValidationResult(EUDCCValidator().validate(eudcc: eudcc, rule: .isRecoveryValid)))
        } else if eudcc.vaccination != nil {
            try setVaccinationData(eudcc, isValid: getValidationResult(EUDCCValidator().validate(eudcc: eudcc, rule: .isVaccinationExpired())))
        } else {
            try setRecoveryData(eudcc, isValid: getValidationResult(EUDCCValidator().validate(eudcc: eudcc, rule: .isTestValid())))
        }
    }
}

extension CovidCertificateDomainItem {
    private mutating func setRecoveryData(_ eudcc: EUDCC, isValid: Bool) throws {
        guard let certificateValidUntil = eudcc.recovery?.certificateValidUntil,
              let certificateIssuer = eudcc.recovery?.certificateIssuer,
              let firstPositiveTestResult = eudcc.recovery?.dateOfFirstPositiveTestResult,
              let testCountry = eudcc.recovery?.countryOfTest.localizedString()
        else {
            throw ErrorType.general
        }
        
        self.isCertificationValid = isValid
        self.certificateValidationMessage = isValid == true ? "Certificate has expired." : ""
        self.icon = Image("recovery")
        self.title = eudcc.name.formatted()
        self.subtitle = "Recovery Certificate"
        self.certificateTypeDetails = "Valid until - \(DateFormatter.dayMonthYear.parseToString(date: certificateValidUntil))"
        self.certificateGeneralInfo = "Certificate issuer - \(certificateIssuer)"
        self.activeTitle = "First positive test - \(DateFormatter.dayMonthYear.parseToString(date: firstPositiveTestResult))"
        self.dateOfBirth = "Date of birth - \(DateFormatter.dayMonthYear.parseToString(date: eudcc.dateOfBirth))"
        self.country = "Test country - \(testCountry)"
    }
    
    private mutating func setVaccinationData(_ eudcc:EUDCC, isValid: Bool) throws {
        guard let vaccineType = eudcc.vaccination?.vaccineMedicinalProduct.wellKnownValue?.rawValue,
              let doseNumber = eudcc.vaccination?.doseNumber,
              let totalDoseNumber = eudcc.vaccination?.totalSeriesOfDoses,
              let vaccinationDate = eudcc.vaccination?.dateOfVaccination,
              let vaccinationCountry = eudcc.vaccination?.countryOfVaccination.localizedString()
        else {
            throw ErrorType.general
        }
        
        self.isCertificationValid = isValid
        self.certificateValidationMessage = isValid == true ? "Certificate has expired." : ""
        self.icon = Image("vaccination")
        self.title = eudcc.name.formatted()
        self.subtitle = "Vaccination Certificate"
        self.certificateTypeDetails = "Vaccine type - \(getVaccineMedicalProduct(vaccineType))"
        self.certificateGeneralInfo = "Dose - \(doseNumber) of \(totalDoseNumber)"
        self.activeTitle = "Vaccinated - \(DateFormatter.dayMonthYear.parseToString(date: vaccinationDate))"
        self.dateOfBirth = "Date of birth - \(DateFormatter.dayMonthYear.parseToString(date: eudcc.dateOfBirth))"
        self.country = "Vaccination country - \(vaccinationCountry)"
    }
    
    private mutating func setTestData(_ eudcc: EUDCC, isValid: Bool) throws {
        guard let testType = eudcc.test?.typeOfTest.value,
              let testingCentre = eudcc.test?.testingCentre,
              let dateOfSampleCollection = eudcc.test?.dateOfSampleCollection,
              let testCountry = eudcc.test?.countryOfTest.localizedString()
        else {
            throw ErrorType.general
        }
        
        self.isCertificationValid = isValid
        self.certificateValidationMessage = isValid == true ? "Certificate has expired." : ""
        self.icon = Image("test")
        self.title = eudcc.name.formatted()
        self.subtitle = "Test Certificate"
        self.certificateTypeDetails = "Test type - \(getTestType(testType))"
        self.certificateGeneralInfo = "Testing centre - \(testingCentre)"
        self.activeTitle = "Tested on - \(DateFormatter.dayMonthYear.parseToString(date: dateOfSampleCollection))"
        self.dateOfBirth = "Date of birth - \(DateFormatter.dayMonthYear.parseToString(date: eudcc.dateOfBirth))"
        self.country = "Test country - \(testCountry)"
    }
    
    private func getVaccineMedicalProduct(_ value: String) -> String {
        switch value {
        case "EU/1/20/1528":
            return "BioNTech - Pfizer"
        case "EU/1/20/1507":
            return "Moderna"
        case "EU/1/21/1529":
            return "AstraZeneca"
        case "EU/1/20/1525":
            return "Janssen"
        default:
            return value
        }
    }
    
    private func getTestType(_ value: String) -> String {
        switch value {
        case "LP6464-4":
            return "Nucleic acid amplification with probe detection"
        default:
            return "Rapid immunoassay"
        }
    }
    
    private func getValidationResult(_ result: EUDCCValidator.ValidationResult) -> Bool {
        switch result {
        case .success():
            return true
        case.failure(_):
            return false
        }
    }
}
