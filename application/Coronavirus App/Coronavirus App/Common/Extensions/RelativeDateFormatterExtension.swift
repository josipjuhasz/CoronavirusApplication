//
//  RelativeDateFormatterExtension.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 07.05.2022..
//

import Foundation

extension RelativeDateTimeFormatter {
    static var standard: RelativeDateTimeFormatter = {
        let relativeDatetimeFormatter = RelativeDateTimeFormatter()
        relativeDatetimeFormatter.unitsStyle = .full
        relativeDatetimeFormatter.locale = .init(identifier: "en")
        
        return relativeDatetimeFormatter
    }()
    
}
