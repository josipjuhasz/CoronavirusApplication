//
//  LatestNewsViewModel.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 13.05.2022..
//

import Foundation
import Combine

class LatestNewsViewModel: ObservableObject {
    
    private let repository: LatestNewsRepository
    
    @Published var news: [LatestNewsDetails]?
    @Published var error: ErrorType?
    @Published var loader = true
    @Published var count = 0
    @Published var isLastNews = false
    private var offset = 0
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(repository: LatestNewsRepository){
        self.repository = repository
        initPipeline(isRefreshing: false)
    }
    
    func initPipeline(isRefreshing: Bool) {
        if isRefreshing {
            self.loader = true
            self.error = nil
        }
        
        repository
            .getLatestNews(offset: isRefreshing ? 0 : offset)
            .receive(on: RunLoop.main)
            .map { [unowned self] response -> [LatestNewsDetails] in
                self.count = response.pagination.total
                return removeDuplicates(news: response.data)
            }
            .sink(receiveCompletion: { [unowned self] completion in
                if case let .failure(error) = completion {
                    self.error = error
                    self.loader = false
                }
            }, receiveValue: { [unowned self] result in
                handleResult(isRefreshing: isRefreshing, result: result)
                self.loader = false
                self.error = nil
            })
            .store(in: &cancellables)
    }
    
    private func handleResult(isRefreshing: Bool, result: [LatestNewsDetails]){
        if isRefreshing {
            self.news = result
        } else {
            self.news = (news ?? []) + result
        }
        
        if news?.count == count {
            self.isLastNews = true
        }
    }
    
    private func removeDuplicates(news: [LatestNewsDetails]) -> [LatestNewsDetails] {
        var uniqueNews = [LatestNewsDetails]()
        for new in news {
            if !uniqueNews.contains(where: {$0.title == new.title }) {
                uniqueNews.append(new)
            }
        }
        return uniqueNews
    }
    
    func loadMoreNews(){
        offset += 25
        initPipeline(isRefreshing: false)
    }
}
