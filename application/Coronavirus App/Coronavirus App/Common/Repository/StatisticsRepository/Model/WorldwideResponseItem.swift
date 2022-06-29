//
//  WorldwideResponseItem.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 21.03.2022..
//

import Foundation

struct WorldwideResponseItem: Codable {
    
    let global: WorldwideResponseDetails
    var countries: [WorldwideResponseDetails]
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case global = "Global"
        case countries = "Countries"
        case date = "Date"
    }
}

struct WorldwideResponseDetails: Codable {
    
    let countryName: String?
    let newConfirmed: Int
    var totalConfirmed: Int
    let newDeaths: Int
    let totalDeaths: Int
    let newRecovered: Int
    let totalRecovered: Int
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case countryName = "Country"
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
        case date = "Date"
    }
}
