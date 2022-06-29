//
//  ErrorExtension.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 26.04.2022..
//

import Foundation

extension Error {
    var asErrorType: ErrorType {
        return self as? ErrorType ?? .empty
    }
}
