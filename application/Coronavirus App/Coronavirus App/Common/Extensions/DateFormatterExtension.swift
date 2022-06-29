//
//  DateFormatterExtension.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 11.04.2022..
//

import Foundation

public extension DateFormatter {
    
    static var dayMonthYear: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        return dateFormatter
    }()
    
    static var yearMonthDayHourMinuteSecondMilisecond: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
    
    static var yearMonthDayHourMinuteSecond: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
    
    func parseToString(date: Date) -> String {
        return string(from: date)
    }
}
