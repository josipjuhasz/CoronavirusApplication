//
//  HomeView.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 28.03.2022..
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: HomeViewModel
    @Binding var useCase: UseCaseSelection
    
    init(viewModel: HomeViewModel, useCase: Binding<UseCaseSelection>){
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self._useCase = useCase
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                if viewModel.loader {
                    VStack(){
                        LoaderView()
                            .frame(height: geo.size.height * 0.5)
                            .navigationBarHidden(true)
                        
                        Spacer()
                    }
                    .addAppThemeBackground()
                }
                else if let error = viewModel.error {
                    errorViewBuilder(error)
                        .navigationBarHidden(true)
                }
                else {
                    if let data = viewModel.data {
                        ScrollView {
                            ZStack(alignment: .top){
                                VStack(spacing: 0) {
                                    ZStack {
                                        Rectangle()
                                            .fill(Color.appBackground)
                                            .frame(width: geo.size.width, height: geo.size.height * 0.33)
                                            .background(Color.appBackground)
                                            .environment(\.colorScheme, .dark)
                                        
                                        virusImage(blur: 0)
                                            .frame(width: (geo.size.width * 0.3), height: (geo.size.width * 0.3))
                                            .offset(x: -(geo.size.width * 0.45), y: geo.size.height * 0.12)
                                        
                                        virusImage(blur: 1)
                                            .frame(width: (geo.size.width * 0.2), height: (geo.size.width * 0.2))
                                            .offset(x: geo.size.width * 0.46, y: -(geo.size.height * 0.05))
                                        
                                        virusImage(blur: 1.5)
                                            .frame(width: (geo.size.width * 0.15), height: (geo.size.width * 0.15))
                                            .offset(x: geo.size.width * 0.45, y: geo.size.height * 0.1)
                                    }
                                    
                                    Rectangle()
                                        .fill(Color.appBackground)
                                }
                                
                                VStack {
                                    header(data: data)
                                        .padding(.top)
                                    dashboards(data: data)
                                    list(data: data)
                                }
                                .padding()
                            }
                        }
                        .ignoresSafeArea()
                        .addAppThemeBackground()
                        .navigationBarHidden(true)
                    } else {
                        ErrorView(.general)
                    }
                }
            }
            .background(
                NavigationLink(isActive: $viewModel.isShowingCountrySelection) {
                    CountrySelectionView(viewModel: CountrySelectionViewModel(repository: CountriesSelectionRepositoryImpl()), useCase: $useCase)
                        .navigationBarBackButtonHidden(true)
                } label: {}
            )
        }
        .onAppear {
            viewModel.handleOnAppearEvent(&UIScrollView.appearance().bounces)
        }
    }
}


extension HomeView {
    @ViewBuilder
    private func virusImage(blur: CGFloat) -> some View {
        Image("virus")
            .resizable()
            .scaledToFit()
            .opacity(0.68)
            .blur(radius: blur)
    }
    
    @ViewBuilder
    private func header(data: HomeDomainItem) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                
                Text(verbatim: .covidTrackerTitle)
                    .commonFont(.semiBold, style: .callout)
                    .foregroundColor(.white)
                
                Button {
                    viewModel.handleHeaderButtonAction()
                } label: {
                    HStack() {
                        if let title = data.title {
                            Text(title)
                                .commonFont(.bold, style: .title1)
                                .foregroundColor(.white)
                        }
                        
                        Image(systemName: "arrowtriangle.down.fill")
                            .foregroundColor(Color(UIColor.systemGray))
                    }
                }
                
                if let date = data.lastUpdateDate {
                    Text(date)
                        .commonFont(.regular, style: .subheadline)
                        .foregroundColor(Color(UIColor.systemGray).opacity(0.9))
                }
            }
            .padding(.top)
            
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    private func dashboardElement(_ item: StatisticsItem, color: Color) -> some View {
        VStack(alignment: .leading) {
            Text(item.type.rawValue)
                .commonFont(.bold, style: .caption2)
                .foregroundColor(Color(UIColor.systemGray))
            
            HStack(alignment: .firstTextBaseline){
                Text("\(item.value.abbreviate())")
                    .commonFont(.bold, style: .body)
                
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Image(systemName: item.delta == 0 ? "arrow.right" : "arrow.up")
                        .resizable()
                        .rotation3DEffect(Angle(degrees:item.delta > 0 ? 0 : 180), axis: (x: 1, y: 0, z: 0))
                        .frame(width: 10, height: 10)
                    
                    Text("\(item.delta.abbreviate())")
                        .commonFont(.regular, style: .caption1)
                }
            }
            .foregroundColor(color.opacity(0.7))
            
            Image(item.delta == 0 ? "lineChartEqual" : "lineChartDifference")
                .renderingMode(.template)
                .foregroundColor(color)
                .rotation3DEffect(Angle(degrees:item.delta > 0 ? 0 : 180), axis: (x: 1, y: 0, z: 0))
        }
        .padding([.top, .bottom])
        .frame(maxWidth: .infinity)
        .background(Color.darkGrayBackground)
        .shadow(color: Color.black.opacity(0.15), radius: 35, x: 5.0, y: 0.0)
    }
    
    @ViewBuilder
    private func dashboards(data: HomeDomainItem) -> some View {
        if let confirmed = data.confirmedCases,
           let recovered = data.recoveredCases,
           let active = data.activeCases,
           let death = data.deathCases {
            
            VStack(spacing: 20){
                HStack(spacing: 20) {
                    dashboardElement(confirmed, color: Color(UIColor.systemRed))
                    dashboardElement(active, color: Color(UIColor.systemBlue))
                }
                
                HStack(spacing: 20) {
                    dashboardElement(recovered, color: Color(UIColor.systemGreen))
                    dashboardElement(death, color: Color(UIColor.systemGray))
                }
            }
            .padding([.leading, .trailing, .bottom])
        }
    }
    
    @ViewBuilder
    private func list(data: HomeDomainItem) -> some View {
        let size = UIScreen.main.bounds.height
        
        LazyVStack (spacing: 25){
            HomeListItemView(
                title: viewModel.useCase == .worldwide ? "State" : "Date",
                confirmed: "C",
                active: "A",
                deaths: "D",
                recovered: "R"
            )
            .frame(height: size / 25)
            
            if let list = data.listStats {
                ForEach(list) { value in
                    HomeListItemView(title: value.title,
                                     confirmed: value.confirmed,
                                     active: value.active,
                                     deaths: value.deaths,
                                     recovered: value.recovered)
                    .frame(height: size / 25)
                }
            }
            
            Spacer()
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    private func errorViewBuilder(_ error: ErrorType) -> some View {
        switch error {
        case .general:
            ErrorView(.general) {
                viewModel.errorActionCallback()
            }
        case .noInternetConnection:
            ErrorView(.noInternetConnection) {
                viewModel.errorActionCallback()
            }
        case .empty:
            EmptyStateView(isShowingCountrySelection: $viewModel.isShowingCountrySelection)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            viewModel: HomeViewModel(
                repository: StatisticsRepositoryImpl(),
                useCase: .worldwide
            ),
            useCase: .constant(.worldwide)
        )
    }
}
