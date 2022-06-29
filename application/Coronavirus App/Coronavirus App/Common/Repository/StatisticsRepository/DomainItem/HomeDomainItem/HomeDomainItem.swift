//
//  Covid19StatisticsDomainItem.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 22.03.2022..
//

import Foundation

class HomeDomainItem: StatisticsDomain {
    
    var title: String?
    var confirmedCases: StatisticsItem?
    var activeCases: StatisticsItem?
    var recoveredCases: StatisticsItem?
    var deathCases: StatisticsItem?
    var listStats: [DataListItem]?
    var lastUpdateDate: String?
    
    init(response: [CountryDayOneResponseItem]) throws {
        if response.count > 2 {
            title = response[0].name
            try createCountryDayOneListStats(items: response)
            try createCountryDayOneDashboardStats(first: response[0], second: response[1])
            updateDate(date: response[0].date)
        } else {
            throw ErrorType.empty
        }
    }
    
    init(response: WorldwideResponseItem) throws {
        title = "Worldwide"
        try createWorldwideListStats(items: response.countries)
        try createWorldwideDashboardStats(item: response)
        updateDate(date: response.date)
    }
    
    private func createCountryDayOneDashboardStats(first: CountryDayOneResponseItem, second: CountryDayOneResponseItem) throws {
        guard let confirmed = StatisticsItem(type: .confirmed,
                                             value: first.confirmed,
                                             delta: first.confirmed - second.confirmed) else {
            throw ErrorType.empty
        }
        
        guard let active = StatisticsItem(type: .active,
                                          value: first.active,
                                          delta: first.active - second.active) else {
            throw ErrorType.empty
        }
        
        guard let death = StatisticsItem(type: .deaths,
                                         value: first.deaths,
                                         delta: first.deaths - second.deaths) else {
            throw ErrorType.empty
        }
        
        guard let recovered = StatisticsItem(type: .recovered,
                                             value: first.recovered,
                                             delta: first.recovered - second.recovered) else {
            throw ErrorType.empty
        }
        
        confirmedCases = confirmed
        activeCases = active
        recoveredCases = recovered
        deathCases = death
    }
    
    private func createWorldwideDashboardStats(item: WorldwideResponseItem) throws {
        
        guard let confirmed = StatisticsItem(type: .confirmed,
                                             value: item.global.totalConfirmed,
                                             delta: item.global.newConfirmed) else {
            throw ErrorType.empty
        }
        
        guard let active = StatisticsItem(type: .active,
                                          value: item.global.totalConfirmed - item.global.totalRecovered,
                                          delta: item.global.newConfirmed - item.global.newRecovered) else {
            throw ErrorType.empty
        }
        
        guard let death = StatisticsItem(type: .deaths,
                                         value: item.global.totalDeaths,
                                         delta: item.global.newDeaths) else {
            throw ErrorType.empty
        }
        
        guard let recovered = StatisticsItem(type: .recovered,
                                             value: item.global.totalRecovered,
                                             delta: item.global.newRecovered) else {
            throw ErrorType.empty
        }
        
        confirmedCases = confirmed
        activeCases = active
        recoveredCases = recovered
        deathCases = death
    }
    
    private func createCountryDayOneListStats(items: [CountryDayOneResponseItem]) throws {
        var newStats = [DataListItem]()
        
        for(index, currentItem) in items.enumerated() {
            
            if index == 0 {
                guard let item = DataListItem(
                    title: DateFormatter.dayMonthYear.parseToString(date: DateUtils().parseToDate(dateString: currentItem.date)),
                    confirmed: currentItem.confirmed.abbreviate(),
                    recovered: currentItem.recovered.abbreviate(),
                    deaths: currentItem.deaths.abbreviate(),
                    active: currentItem.active.abbreviate())
                else {
                    throw ErrorType.empty
                }
                newStats.append(item)
            }
            else {
                let previousItem = items[index - 1]
                
                guard let item = DataListItem(
                    title: DateFormatter.dayMonthYear.parseToString(date: DateUtils().parseToDate(dateString: currentItem.date)),
                    confirmed: (previousItem.confirmed - currentItem.confirmed).abbreviate(),
                    recovered: (previousItem.recovered - currentItem.recovered).abbreviate(),
                    deaths: (previousItem.deaths - currentItem.deaths).abbreviate(),
                    active: (previousItem.active - currentItem.active).abbreviate())
                else {
                    throw ErrorType.empty
                }
                newStats.append(item)
            }
        }
        
        listStats = newStats
    }
    
    private func createWorldwideListStats(items: [WorldwideResponseDetails]) throws {
        var newStats = [DataListItem]()
        
        for item in items {
            guard let newItem = DataListItem(
                title: item.countryName ?? "",
                confirmed: item.totalConfirmed.abbreviate(),
                recovered: item.totalRecovered.abbreviate(),
                deaths: item.totalDeaths.abbreviate(),
                active: (item.totalConfirmed - item.totalRecovered).abbreviate())
            else {
                throw ErrorType.empty
            }
            
            newStats.append(newItem)
        }
        
        listStats = newStats
    }
    
    private func updateDate(date: String) {
        var dateFormatter = DateFormatter()
        
        if date.count > 20 {
            dateFormatter = DateFormatter.yearMonthDayHourMinuteSecondMilisecond
        } else {
            dateFormatter = DateFormatter.yearMonthDayHourMinuteSecond
        }

        let responseDate = dateFormatter.date(from: date)

        if let responseDate = responseDate {
            self.lastUpdateDate = "Last updated \(RelativeDateTimeFormatter.standard.localizedString(for: responseDate, relativeTo: Date()))"
        }
    }
    
    private func handleError(){
        title = ""
        confirmedCases = nil
        recoveredCases = nil
        activeCases = nil
        deathCases = nil
        lastUpdateDate = ""
    }
}
