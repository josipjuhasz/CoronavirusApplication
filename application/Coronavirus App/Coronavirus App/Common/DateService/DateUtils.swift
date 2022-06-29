//
//  DateUtils.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 11.04.2022..
//

import Foundation

class DateUtils {
    
    let dateType: String = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    func parseToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateType
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        
        return Date()
    }
}
