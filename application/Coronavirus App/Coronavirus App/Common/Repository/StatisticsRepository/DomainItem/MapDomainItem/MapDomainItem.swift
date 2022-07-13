//
//  MapDomainItem.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 07.05.2022..
//

import SwiftUI

class MapDomainItem: StatisticsDomainItem {
    
    var countryCoordinates: [CountryCoordinates]?
    var worldwideItems: [CountryDayOneResponseItem]?
    
    init(title: String, confirmed: StatisticsItem, active: StatisticsItem, recovered: StatisticsItem, death: StatisticsItem){
        super.init(
            title: title,
            confirmedCases: confirmed,
            activeCases: active,
            recoveredCases: recovered,
            deathCases: death
        )
    }
    
    init(item: [CountryDayOneResponseItem]) throws {
        super.init()
        guard let first = item.first else { throw ErrorType.general }
        title = first.name
        try setCountryStats(item: first)
        countryCoordinates = try getCountryCoordinates(country: first)
    }
    
    init(responseItem: WorldwideResponseItem, items: [CountryDayOneResponseItem]?) throws {
        super.init()
        title = "Worldwide"
        try setWorldwideStats(item: responseItem)
        worldwideItems = try getWorldwideItems(items: items)
    }
    
    private func setCountryStats(item: CountryDayOneResponseItem) throws {
        confirmedCases = StatisticsItem(value: item.confirmed)
        activeCases = StatisticsItem(value: item.active)
        recoveredCases = StatisticsItem(value: item.recovered)
        deathCases = StatisticsItem(value: item.deaths)
    }
    
    private func setWorldwideStats(item: WorldwideResponseItem) throws {
        confirmedCases = StatisticsItem(value: item.global.totalConfirmed)
        activeCases = StatisticsItem(value: item.global.totalConfirmed - item.global.totalRecovered)
        recoveredCases = StatisticsItem(value: item.global.totalRecovered)
        deathCases = StatisticsItem(value: item.global.totalDeaths)
    }
    
    private func getCountryCoordinates(country: CountryDayOneResponseItem) throws -> [CountryCoordinates]{
        var newArray = [CountryCoordinates]()
        let newItem = CountryCoordinates(lat: country.lat, lon: country.lon)
        newArray.append(newItem)
        return newArray
    }
    
    private func getWorldwideItems(items: [CountryDayOneResponseItem]?) throws -> [CountryDayOneResponseItem] {
        guard let newItems = items else {
            throw ErrorType.general
        }
        
        worldwideItems = []
        return newItems
    }
}
