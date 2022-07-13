//
//  Covid19StatisticsDomainItem.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 22.03.2022..
//

import Foundation

class HomeDomainItem: StatisticsDomainItem {
    
    var listStats: [DataListItem]?
    var lastUpdateDate: String?
    
    init(response: [CountryDayOneResponseItem]) throws {
        super.init()
        if response.count > 2 {
            title = response[0].name
            setCountryDayOneListStats(items: response)
            setCountryDayOneDashboardStats(first: response[0], second: response[1])
            updateDate(dateString: response[0].date)
        } else {
            throw ErrorType.general
        }
    }
    
    init(response: WorldwideResponseItem){
        super.init()
        title = "Worldwide"
        setWorldwideListStats(items: response.countries)
        setWorldwideDashboardStats(item: response)
        updateDate(dateString: response.date)
    }
    
    private func setCountryDayOneDashboardStats(first: CountryDayOneResponseItem, second: CountryDayOneResponseItem) {
        confirmedCases = StatisticsItem(type: .confirmed,
                                         value: first.confirmed,
                                         delta: first.confirmed - second.confirmed)
        
        activeCases = StatisticsItem(type: .active,
                                     value: first.active,
                                     delta: first.active - second.active)
        
        recoveredCases = StatisticsItem(type: .deaths,
                                        value: first.deaths,
                                        delta: first.deaths - second.deaths)
        
        deathCases = StatisticsItem(type: .recovered,
                                    value: first.recovered,
                                    delta: first.recovered - second.recovered)
    }
    
    private func setWorldwideDashboardStats(item: WorldwideResponseItem) {
        confirmedCases = StatisticsItem(type: .confirmed,
                                        value: item.global.totalConfirmed,
                                        delta: item.global.newConfirmed)
        
        activeCases = StatisticsItem(type: .active,
                                     value: item.global.totalConfirmed - item.global.totalRecovered,
                                     delta: item.global.newConfirmed - item.global.newRecovered)
        
        recoveredCases = StatisticsItem(type: .recovered,
                                        value: item.global.totalRecovered,
                                        delta: item.global.newRecovered)
        
        deathCases = StatisticsItem(type: .deaths,
                                    value: item.global.totalDeaths,
                                    delta: item.global.newDeaths)
    }
    
    private func setCountryDayOneListStats(items: [CountryDayOneResponseItem]) {
        var newStats = [DataListItem]()
        
        for(index, currentItem) in items.enumerated() {
            if index == 0 {
                let item = DataListItem(
                    title: DateFormatter.dayMonthYear.parseToString(date: DateUtils.parseToDate(currentItem.date)),
                    confirmed: currentItem.confirmed.abbreviate(),
                    recovered: currentItem.recovered.abbreviate(),
                    deaths: currentItem.deaths.abbreviate(),
                    active: currentItem.active.abbreviate()
                )
                newStats.append(item)
            }
            else {
                let previousItem = items[index - 1]
                
                let item = DataListItem(
                    title: DateFormatter.dayMonthYear.parseToString(date: DateUtils.parseToDate(currentItem.date)),
                    confirmed: (previousItem.confirmed - currentItem.confirmed).abbreviate(),
                    recovered: (previousItem.recovered - currentItem.recovered).abbreviate(),
                    deaths: (previousItem.deaths - currentItem.deaths).abbreviate(),
                    active: (previousItem.active - currentItem.active).abbreviate()
                    )
                
                newStats.append(item)
            }
        }
        
        listStats = newStats
    }
    
    private func setWorldwideListStats(items: [WorldwideResponseDetails]) {
        var newStats = [DataListItem]()
        
        for item in items {
            let newItem = DataListItem(
                title: item.countryName ?? "",
                confirmed: item.totalConfirmed.abbreviate(),
                recovered: item.totalRecovered.abbreviate(),
                deaths: item.totalDeaths.abbreviate(),
                active: (item.totalConfirmed - item.totalRecovered).abbreviate()
            )
                        
            newStats.append(newItem)
        }
        
        listStats = newStats
    }
    
    private func updateDate(dateString: String) {
        let date = DateUtils.parseToDate(dateString)

        self.lastUpdateDate = "Last updated \(RelativeDateTimeFormatter.standard.localizedString(for: date, relativeTo: Date()))"
    }
}
