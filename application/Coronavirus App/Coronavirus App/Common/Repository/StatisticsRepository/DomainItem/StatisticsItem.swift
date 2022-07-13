//
//  StatisticsItem.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 22.03.2022..
//

import Foundation

enum StatisticsCaseType: String {
    case active = "ACTIVE"
    case deaths = "DECEASED"
    case confirmed = "CONFIRMED"
    case recovered = "RECOVERED"
}

struct StatisticsItem: Equatable {
    
    let type: StatisticsCaseType
    let value: Int
    let delta: Int
    
    init(value: Int){
        self.type = .active
        self.value = value
        self.delta = 0
    }
    
    init(type: StatisticsCaseType, value: Int, delta: Int) {
        self.type = type
        self.value = value
        self.delta = delta
    }
}
