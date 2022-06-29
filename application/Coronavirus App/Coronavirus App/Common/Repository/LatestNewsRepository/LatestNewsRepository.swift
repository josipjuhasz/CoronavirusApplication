//
//  LatestNewsRepository.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 13.05.2022..
//

import Foundation
import Combine

protocol LatestNewsRepository {
    func getLatestNews(offset: Int) -> AnyPublisher<LatestNewsResponseItem, ErrorType> 
}
