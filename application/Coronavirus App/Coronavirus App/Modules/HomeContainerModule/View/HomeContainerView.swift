//
//  HomeContainerView.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 05.01.2022..
//

import SwiftUI

enum TabIcon: String {
    
    case home = "homeTabIcon"
    case latestNews = "latestNewsTabIcon"
    case statistics = "statisticsTabIcon"
    case pageComingSoon = "pageComingSoonTabIcon"
}

enum UseCaseSelection: Equatable {
    case worldwide
    case country(String)
}

struct HomeContainerView: View {
    
    @State var useCase: UseCaseSelection = .worldwide
    
    init() {
        initAppereance()
    }
    
    private func initAppereance(){
        UITabBar.appearance().backgroundColor = UIColor(Color.barTint)
    }
    
    var body: some View {
        TabView {
            HomeView(viewModel: HomeViewModel(repository: StatisticsRepositoryImpl(), useCase: useCase), useCase: $useCase)
                .tabItem {
                    renderAsImage(.home)
                }
            
            MapStatisticsView(viewModel: MapViewModel(repository: StatisticsRepositoryImpl(), useCase: useCase), useCase: $useCase)
                .tabItem {
                    renderAsImage(.statistics)
                }
            
            LatestNewsView(viewModel: LatestNewsViewModel(repository: LatestNewsRepositoryImpl()))
                .tabItem {
                    renderAsImage(.latestNews)
                }
            
            PageComingSoonView()
                .tabItem {
                    renderAsImage(.pageComingSoon)
                }
        }
        .accentColor(.red)
    }
}

extension HomeContainerView {
    private func renderAsImage(_ tabIcon: TabIcon) -> Image {
        return Image(tabIcon.rawValue)
            .renderingMode(.template)
    }
}

struct HomeContainerView_Previews: PreviewProvider {
    static var previews: some View {
        HomeContainerView()
            .preferredColorScheme(.light)
    }
}
