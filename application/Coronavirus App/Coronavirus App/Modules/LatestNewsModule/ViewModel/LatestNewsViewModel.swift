//
//  LatestNewsViewModel.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 13.05.2022..
//

import Foundation
import Combine

enum WebViewPresentationStatus {
    case presented
    case dismissed
}

class LatestNewsViewModel: ObservableObject {
    
    private let repository: LatestNewsRepository
    
    @Published var news: [LatestNewsDetails]?
    @Published var error: ErrorType?
    @Published var webViewUrl = URL(string: "")
    @Published var loader = true
    @Published var count = 0
    @Published var isLastNews = false
    @Published var isWebViewPresented = false
    private var offset = 0
    
    private let shouldRefreshSubject = CurrentValueSubject<Bool, Never>.init(false)
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(repository: LatestNewsRepository){
        self.repository = repository
        initPipelines()
    }
    
    private func initPipelines() {
        shouldRefreshSubject
            .flatMap { [weak self] value -> AnyPublisher<Result<(LatestNewsResponseItem, Bool), ErrorType>, Never> in
                guard let self = self else {
                    return Just(Result.failure(ErrorType.general)).eraseToAnyPublisher()
                }
                
                if value {
                    self.loader = true
                    self.error = nil
                }
        
                return self.getLatestNewsPublisher(value)
            }
            .map { [weak self] response -> Result<([LatestNewsDetails], Bool), ErrorType> in
                guard let self = self else {
                    return Result.failure(ErrorType.general)
                }
                switch response {
                case .success(let item):
                    self.count = item.0.pagination.total
                    return Result.success((self.removeDuplicates(news: item.0.data), item.1))
                    
                case.failure(let error):
                    return Result.failure(error)
                }
            }
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let item):
                    self.news = self.handleResult(result: item.0, isRefreshing: item.1)
                    self.loader = false
                    self.error = nil
                case .failure(let error):
                    self.loader = false
                    self.error = error
                }
            }
            .store(in: &cancellables)
    }
    
    private func getLatestNewsPublisher(_ isRefreshing: Bool) -> AnyPublisher<Result<(LatestNewsResponseItem, Bool), ErrorType>, Never> {
        return repository
            .getLatestNews(offset: isRefreshing ? 0 : offset)
            .map { result in
                switch result {
                case .success(let item):
                    return Result.success((item, isRefreshing))
                    
                case .failure(let error):
                    return Result.failure(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func handleResult(result: [LatestNewsDetails], isRefreshing: Bool) -> [LatestNewsDetails] {
        if isRefreshing {
            return result
        } else {
            return (news ?? []) + result
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
        shouldRefreshSubject.send(false)
    }
    
    func refreshLatestNews(_ value: Bool){
        shouldRefreshSubject.send(value)
    }
    
    func handleWebViewPresentation(status: WebViewPresentationStatus, item: LatestNewsDetails? = nil){
        switch status {
        case .presented:
            if let item = item {
                webViewUrl = URL(string: item.url)
                isWebViewPresented = true
            }
        case .dismissed:
            webViewUrl = URL(string: "")
            isWebViewPresented = false
        }
    }
    
    func handleOnAppearEvent(_ isBouncing: inout Bool){
        isBouncing = true
    }
    
    func errorActionCallback(){
        shouldRefreshSubject.send(false)
    }
}
