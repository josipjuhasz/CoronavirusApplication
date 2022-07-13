//
//  LatestNewsResponseItem.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 13.05.2022..
//

import Foundation

struct LatestNewsResponseItem: Codable {
    let pagination: PaginationInformation
    let data: [LatestNewsDetails]
}

struct LatestNewsDetails: Codable, Hashable, Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let url: String
    let source: String
    let image: String?
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "description"
        case url = "url"
        case source = "source"
        case image = "image"
        case date = "published_at"
    }
    
    var passedTime: String {
        let dateString = DateUtils.parseToDate(date)
        let formattedDate = RelativeDateTimeFormatter.standard.localizedString(for: dateString, relativeTo: Date())
        return "\(source) • \(formattedDate)"
    }
}

struct PaginationInformation: Codable {
    var limit: Int
    var offset: Int
    var count: Int
    var total: Int
}

