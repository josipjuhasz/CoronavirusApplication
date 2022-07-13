//
//  MapView.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 07.05.2022..
//

import SwiftUI
import MapKit

struct MapStatisticsView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: MapViewModel
    @Binding var useCase: UseCaseSelection
    
    init(viewModel: MapViewModel, useCase: Binding<UseCaseSelection>) {
        self.viewModel = viewModel
        self._useCase = useCase
        initAppereance()
    }
    
    private func initAppereance(){
        if let font = UIFont(name: "Montserrat-Bold", size: 25) {
            UINavigationBar.appearance().titleTextAttributes = [.font : font]
        }
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
                } else if let error = viewModel.error {
                    errorViewBuilder(error)
                        .navigationBarHidden(true)
                } else {
                    if let title = viewModel.domainItem?.title
                    {
                        VStack {
                            Spacer()
                            
                            MapView(viewModel: viewModel)
                                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.4)
                                .padding()
                            
                            Spacer()
                            Spacer()
                            statistics(title: title)
                            Spacer()
                        }
                        .padding()
                        .addAppThemeBackground()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarItems(leading:
                                                Text(verbatim: useCase == .worldwide ? .statisticsWorldwideTitle : .statisticsCountryTitle)
                            .commonFont(.semiBold, style: .title2)
                            .padding()
                        )
                    } else {
                        ErrorView(.general)
                    }
                }
            }
        }
    }
}

extension MapStatisticsView {
    @ViewBuilder
    private func statistics(title: String) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .commonFont(.semiBold, style: .headline)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("CONFIRMED")
                        .commonFont(.semiBold, style: .caption2)
                        .foregroundColor(Color(UIColor.systemGray))
                    
                    Text("\(viewModel.domainItem?.confirmedCases?.value ?? 0)")
                        .commonFont(.regular, style: .callout)
                        .foregroundColor(Color(UIColor.systemRed))
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("ACTIVE")
                        .commonFont(.semiBold, style: .caption2)
                        .foregroundColor(Color(UIColor.systemGray))
                        .multilineTextAlignment(.leading)
                    
                    
                    Text("\(viewModel.domainItem?.activeCases?.value ?? 0)")
                        .commonFont(.regular, style: .callout)
                        .foregroundColor(Color(UIColor.systemBlue))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("RECOVERED")
                        .commonFont(.semiBold, style: .caption2)
                        .foregroundColor(Color(UIColor.systemGray))
                        .multilineTextAlignment(.leading)
                    
                    Text("\(viewModel.domainItem?.recoveredCases?.value ?? 0)")
                        .commonFont(.regular, style: .callout)
                        .foregroundColor(Color(UIColor.systemGreen))
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("DECEASED")
                        .commonFont(.semiBold, style: .caption2)
                        .foregroundColor(Color(UIColor.systemGray))
                        .multilineTextAlignment(.leading)
                    
                    Text("\(viewModel.domainItem?.deathCases?.value ?? 0)")
                        .commonFont(.regular, style: .callout)
                        .foregroundColor(Color(UIColor.black))
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.darkGrayBackground)
        .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 0)
    }
    
    @ViewBuilder
    private func errorViewBuilder(_ error: ErrorType) -> some View {
        switch error {
        case .general:
            ErrorView(.general) {
                viewModel.errorActionCallback()
            }
        case .noInternetConnection:
            ErrorView(.noInternetConnection){
                viewModel.errorActionCallback()
            }
        case .empty:
            EmptyStateView(isShowingCountrySelection: $viewModel.isShowingCountrySelection)
        }
    }
}

struct MapStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        MapStatisticsView(
            viewModel: MapViewModel(
                repository: StatisticsRepositoryImpl(),
                useCase: .worldwide),
            useCase: .constant(.worldwide)
        )
    }
}
