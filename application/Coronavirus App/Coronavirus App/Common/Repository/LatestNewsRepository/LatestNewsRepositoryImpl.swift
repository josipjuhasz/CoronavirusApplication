//
//  LatestNewsRepositoryImpl.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 13.05.2022..
//

import Foundation
import Combine

class LatestNewsRepositoryImpl: LatestNewsRepository {
    func getLatestNews(offset: Int) -> AnyPublisher<Result<LatestNewsResponseItem, ErrorType>, Never> {
        let url = RestEndpoints.latestNews(offset).endpoint()
        return RestManager.fetchData(url: url)
    }
}
