//
//  HomeListStats.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 23.03.2022..
//

import Foundation

struct HomeListStats: Identifiable {
    
    let id = UUID()
    var title: String
    var confirmed: Int
    var recovered: Int
    var deaths: Int
    var active: Int
    
    init() {
        self.title = ""
        self.confirmed = 0
        self.recovered = 0
        self.deaths = 0
        self.active = 0
    }
}
