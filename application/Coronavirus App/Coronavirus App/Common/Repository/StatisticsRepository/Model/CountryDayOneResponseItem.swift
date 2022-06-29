//
//  CountryDayOneResponseItem.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 21.03.2022..
//

import Foundation

struct CountryDayOneResponseItem: Codable {
    
    let name: String
    let lat: String
    let lon: String
    let confirmed: Int
    let deaths: Int
    let recovered: Int
    let active: Int
    let date: String

    enum CodingKeys: String, CodingKey {
        case name = "Country"
        case lat = "Lat"
        case lon = "Lon"
        case confirmed = "Confirmed"
        case deaths = "Deaths"
        case recovered = "Recovered"
        case active = "Active"
        case date = "Date"
    }
}
