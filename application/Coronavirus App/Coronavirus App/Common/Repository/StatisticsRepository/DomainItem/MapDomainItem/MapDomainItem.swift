//
//  MapDomainItem.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 07.05.2022..
//

import SwiftUI

class MapDomainItem: StatisticsDomain {
    
    var title: String?
    var confirmedCases: StatisticsItem?
    var activeCases: StatisticsItem?
    var recoveredCases: StatisticsItem?
    var deathCases: StatisticsItem?
    var countryCoordinates: [CountryCoordinates]?
    var worldwideItems: [CountryDayOneResponseItem]?
    
    init(title: String, confirmed: Int, active: Int, recovered: Int, death: Int){
        self.title = title
        self.confirmedCases = StatisticsItem(value: confirmed)
        self.activeCases = StatisticsItem(value: active)
        self.recoveredCases = StatisticsItem(value: recovered)
        self.deathCases = StatisticsItem(value: death)
    }
    
    init(item: [CountryDayOneResponseItem]) throws {
        guard let first = item.first else { return }
        title = first.name
        try createCountryStats(item: first)
        countryCoordinates = try getCountryCoordinates(country: first)
    }
    
    init(responseItem: WorldwideResponseItem, items: (CountryDayOneResponseItem, CountryDayOneResponseItem, CountryDayOneResponseItem)) throws {
        title = "Worldwide"
        try createWorldwideStats(item: responseItem)
        worldwideItems = try createWorlwideItem(items: items)
    }
    
    private func createCountryStats(item: CountryDayOneResponseItem) throws {
        guard let confirmed = StatisticsItem(value: item.confirmed) else {
            throw ErrorType.empty
        }
        
        guard let active = StatisticsItem(value: item.active) else {
            throw ErrorType.empty
        }
        
        guard let death = StatisticsItem(value: item.deaths) else {
            throw ErrorType.empty
        }
        
        guard let recovered = StatisticsItem(value: item.recovered) else {
            throw ErrorType.empty
        }
        
        confirmedCases = confirmed
        activeCases = active
        recoveredCases = recovered
        deathCases = death
    }
    
    private func createWorldwideStats(item: WorldwideResponseItem) throws {
        
        guard let confirmed = StatisticsItem(value: item.global.totalConfirmed) else {
            throw ErrorType.empty
        }
        
        guard let active = StatisticsItem(value: item.global.totalConfirmed - item.global.totalRecovered) else {
            throw ErrorType.empty
        }
        
        guard let death = StatisticsItem(value: item.global.totalDeaths) else {
            throw ErrorType.empty
        }
        
        guard let recovered = StatisticsItem(value: item.global.totalRecovered) else {
            throw ErrorType.empty
        }
        
        confirmedCases = confirmed
        activeCases = active
        recoveredCases = recovered
        deathCases = death
    }
    
    private func getCountryCoordinates(country: CountryDayOneResponseItem) throws -> [CountryCoordinates]{
        var newArray = [CountryCoordinates]()
        let newItem = CountryCoordinates(lat: country.lat, lon: country.lon)
        newArray.append(newItem)
        return newArray
    }
    
    func createWorlwideItem(items: (CountryDayOneResponseItem, CountryDayOneResponseItem, CountryDayOneResponseItem)) throws -> [CountryDayOneResponseItem]{
        
        self.worldwideItems = []
        
        var newArray = [CountryDayOneResponseItem]()
        newArray.append(items.0)
        newArray.append(items.1)
        newArray.append(items.2)
        return newArray
    }
}
