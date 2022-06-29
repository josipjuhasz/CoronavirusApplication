//
//  CountryCoordinate.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 07.05.2022..
//

import Foundation

struct CountryCoordinates {
    
    let lat: Double
    let lon: Double
    
    init(lat: String, lon: String){
        self.lat = Double(lat) ?? 0.0
        self.lon = Double(lon) ?? 0.0
    }
}
