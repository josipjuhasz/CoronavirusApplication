//
//  StatisticsDomain.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 04.05.2022..
//

import Foundation

class StatisticsDomainItem {
    
    var title: String?
    var confirmedCases: StatisticsItem?
    var activeCases: StatisticsItem?
    var recoveredCases: StatisticsItem?
    var deathCases: StatisticsItem?
    
    init(
        title: String? = nil,
        confirmedCases: StatisticsItem? = nil,
        activeCases: StatisticsItem? = nil,
        recoveredCases: StatisticsItem? = nil,
        deathCases: StatisticsItem? = nil
    ){
        self.title = title
        self.confirmedCases = confirmedCases
        self.activeCases = activeCases
        self.recoveredCases = recoveredCases
        self.deathCases = deathCases
    }
}
