//
//  CountrySelectionView.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 24.02.2022..
//

import SwiftUI

struct CountrySelectionView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel: CountrySelectionViewModel = CountrySelectionViewModel(repository: CountriesSelectionRepositoryImpl())
    @Binding var useCase: UseCaseSelection
    
    private func initAppereance(){
        if let font = UIFont(name: "Montserrat-Bold", size: 20) {
            UINavigationBar.appearance().titleTextAttributes = [.font : font]
        }
    }
    
    var body: some View {
        
        if let error = viewModel.error {
            errorViewBuilder(error)
                .navigationBarBackButtonHidden(true)
        } else if viewModel.loader {
            GeometryReader { geo in
                VStack() {
                    LoaderView()
                        .frame(height: geo.size.height * 0.5)
                    
                    Spacer()
                }
                .addAppThemeBackground()
            }
        } else {
            VStack() {
                VStack() {
                    renderCountrySelectionTextField()
                    CountryListItemView(icon: "🌎", name: "Worldwide")
                        .onTapGesture {
                            DispatchQueue.main.async {
                                useCase = .worldwide
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    Divider()
                        .padding([.leading, .trailing])
                    renderCountrySelectionCountriesList()
                    Spacer()
                }
            }
            .navigationOverride(colorScheme: colorScheme) {
                presentationMode.wrappedValue.dismiss()
            }
            .navigationBarTitle(Text(verbatim: .chooseCountryTitle), displayMode: .inline)
            .addAppThemeBackground()
        }
    }
}

extension CountrySelectionView {
    
    @ViewBuilder
    private func renderCountrySelectionTextField() -> some View {
        
        HStack {
            
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(Color(UIColor.systemGray).opacity(0.8))
                .padding()
            
            TextField("Search...", text: $viewModel.searchText)
                .commonFont(.semiBold, style: .headline)
        }
        .background(Color(UIColor.systemGray).opacity(0.25))
        .cornerRadius(15)
        .padding()
    }
    
    @ViewBuilder
    private func renderCountrySelectionCountriesList() -> some View {
        
        if viewModel.countries.isEmpty {
            HStack {
                Text("No results found")
                    .commonFont(.regular, style: .title2)
                    .padding()
                Spacer()
            }
        } else {
            ScrollView {
                ForEach(viewModel.countries) { country in
                    CountryListItemView(icon: country.icon, name: country.name)
                        .onTapGesture {
                            DispatchQueue.main.async {
                                useCase = .country(country.slug)
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                }
            }
        }
    }
    
    @ViewBuilder
    private func errorViewBuilder(_ error: ErrorType) -> some View {
        
        switch error {
        case .general:
            ErrorView(errorType: .general)
        case .noInternetConnection:
            ErrorView(errorType: .noInternetConnection)
        case .empty:
            EmptyView()
        }
    }
}
