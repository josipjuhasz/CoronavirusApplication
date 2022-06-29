//
//  HomeScreenDataListItem.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 23.03.2022..
//

import Foundation

struct DataListItem: Identifiable {
    
    let id = UUID()
    var title: String
    var confirmed: String
    var recovered: String
    var deaths: String
    var active: String
    
    init?(title: String, confirmed: String, recovered: String, deaths: String, active: String) {
        self.title = title
        self.confirmed = confirmed
        self.recovered = recovered
        self.deaths = deaths
        self.active = active
    }
}
