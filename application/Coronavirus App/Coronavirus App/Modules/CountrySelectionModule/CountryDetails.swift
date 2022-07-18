//
//  Country.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 19.01.2022..
//

import Foundation

struct CountryDetails: Codable, Identifiable {
    
    let id = UUID()
    let name: String
    let slug: String
    let iso2: String
    
    enum CodingKeys: String, CodingKey {
        case name = "Country"
        case slug = "Slug"
        case iso2 = "ISO2"
    }
    
    var icon: String {
        iso2
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
}

