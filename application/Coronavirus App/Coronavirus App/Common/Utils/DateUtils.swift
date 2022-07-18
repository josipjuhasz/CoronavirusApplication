//
//  DateUtils.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 11.04.2022..
//

import Foundation

struct DateUtils {
    public static func parseToDate(_ dateString: String) -> Date {
        if let date = DateFormatter.dayMonthYear.date(from: dateString) {
            return date
        }
        
        if let date = DateFormatter.yearMonthDayHourMinuteSecond.date(from: dateString) {
            return date
        }
        
        if let date = DateFormatter.yearMonthDayHourMinuteSecondMilisecond.date(from: dateString) {
            return date
        }
        
        return Date()
    }
}
