//
//  CountriesEndpoint.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 21.01.2022..
//

import Foundation

enum CountriesEnpoint: APIBuilder {
    var baseUrl: String {
        return "https://api.covid19api.com"
    }
    
    var path: String {
        return "/countries"
    }
    
    var url: URL {
        return URL(string: self.baseUrl + self.path)!
    }
}
