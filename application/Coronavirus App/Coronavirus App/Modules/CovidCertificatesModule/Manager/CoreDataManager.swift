//
//  CertificateCoreDataManager.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 26.06.2022..
//

import Foundation
import CoreData
import Combine

class CoreDataManager {
    
    static let shared: CoreDataManager = CoreDataManager()
    
    private let container: NSPersistentContainer
    
    private init(){
        container = NSPersistentContainer(name: "CovidCertificatesContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func getCertificates() -> [CovidCertificateEntity] {
        let request = NSFetchRequest<CovidCertificateEntity>(entityName: "CovidCertificateEntity")
        
        do {
            return try container.viewContext.fetch(request)
        } catch let error {
            print(error)
            return []
        }
    }
    	
    func addCertificate(_ value: String){
        if checkDuplicateCertificate(value){
            let newCertificate = CovidCertificateEntity(context: container.viewContext)
            newCertificate.qrCodeRawData = value
            saveData()
        }
    }
    
    func deleteCertificate(_ value: String){
        let certificates = getCertificates()
        
        for certificate in certificates where certificate.qrCodeRawData == value {
            container.viewContext.delete(certificate)
        }
        
        saveData()
    }
    
    private func checkDuplicateCertificate(_ value: String) -> Bool {
        let request = NSFetchRequest<CovidCertificateEntity>(entityName: "CovidCertificateEntity")
        
        do {
            let certificates = try container.viewContext.fetch(request)
            if certificates.contains(where: { $0.qrCodeRawData == value }){
                return false
            }
        } catch let error {
            print(error)
        }
        
        return true
    }
    
    private func saveData(){
        do {
            try container.viewContext.save()
        } catch let error {
            print(error)
        }
    }
}
