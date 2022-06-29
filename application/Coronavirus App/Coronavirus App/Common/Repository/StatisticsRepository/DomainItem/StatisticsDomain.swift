//
//  StatisticsDomain.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 04.05.2022..
//

import Foundation

protocol StatisticsDomain {
    var title: String? { get set }
    var confirmedCases: StatisticsItem? { get set }
    var activeCases: StatisticsItem? { get set }
    var recoveredCases: StatisticsItem? { get set }
    var deathCases: StatisticsItem? { get set }
}
