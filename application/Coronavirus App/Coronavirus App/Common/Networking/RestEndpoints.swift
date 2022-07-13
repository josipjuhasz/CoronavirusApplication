//
//  RestEndpoints.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 02.02.2022..
//

import Foundation

enum RestEndpoints {
    
    case countries
    case countryStats(name: String)
    case worldwideStats
    case latestNews(Int)
    
    static let covidHost = "api.covid19api.com"
    static let newsHost = "api.mediastack.com/v1/news?"
    static let newsAccessKey = "access_key=5c0f6cbe3a0a9ef5d0c47087c6f262fd"
    
    static var ENDPOINT_COVID: String {
        return "https://" + covidHost
    }
    
    static var ENDPOINT_NEWS: String {
        return "http://" + newsHost + newsAccessKey
    }
    
    public func endpoint() -> URL {
        switch self {
        case .countries:
            return URL(string: RestEndpoints.ENDPOINT_COVID + "/countries")!
        case .countryStats(let name):
            return URL(string: RestEndpoints.ENDPOINT_COVID + "/dayone/country/" + name)!
        case .worldwideStats:
            return URL(string: RestEndpoints.ENDPOINT_COVID + "/summary")!
        case .latestNews(let offset):
            return URL(string: RestEndpoints.ENDPOINT_NEWS + "&keywords=corona&offset=\(offset)&languages=en&sort=published_desc&limit=25")!
        }
    }
}
