//
//  CovidScannerRepository.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 13.06.2022..
//

import Foundation
import Combine
import EUDCC

protocol CovidScannerRepository {
    func getCertificateDetails(_ code: String) -> AnyPublisher<Result<EUDCC, ErrorType>, Never>
}
