//
//  CovidCertificateDecoder.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 13.06.2022..
//

import Foundation
import Combine
import EUDCC
import EUDCCDecoder

class CovidCertificateDecoder {
    func decodeData(_ code: String) -> AnyPublisher<Result<EUDCC, ErrorType>, Never> {
        Just(code)
            .map { data -> Result<EUDCC, ErrorType> in
                let decodingResult = EUDCCDecoder().decode(from: data)
                
                switch decodingResult {
                case .success(let eudcc):
                    return Result.success(eudcc)
                case.failure(_):
                    return Result.failure(ErrorType.empty)
                }
            }
            .eraseToAnyPublisher()
    }
}
