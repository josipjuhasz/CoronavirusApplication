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
    @StateObject private var viewModel: CountrySelectionViewModel
    @Binding var useCase: UseCaseSelection
    
    init(viewModel: CountrySelectionViewModel, useCase: Binding<UseCaseSelection>){
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._useCase = useCase
        initAppereance()
    }
    
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
                if let countries = viewModel.countries {
                    VStack() {
                        textField()
                        CountryListItemView(icon: "🌎", name: "Worldwide")
                            .onTapGesture {
                                DispatchQueue.main.async {
                                    viewModel.handleListItemOnTapGesture(useCase: &useCase, value: .worldwide)
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        
                        Divider()
                            .padding([.leading, .trailing])
                        
                        list(data: countries)
                        Spacer()
                    }
                } else {
                    ErrorView(.general)
                }
            }
            .navigationOverride(colorScheme: colorScheme) {
                presentationMode.wrappedValue.dismiss()
            }
            .navigationBarTitle(
                Text(verbatim: .chooseCountryTitle), displayMode: .inline
            )
            .addAppThemeBackground()
        }
    }
}

extension CountrySelectionView {
    @ViewBuilder
    private func textField() -> some View {
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
    private func list(data: [CountryDetails]) -> some View {
        if data.isEmpty {
            HStack {
                Text("No results found")
                    .commonFont(.regular, style: .title2)
                    .padding()
                Spacer()
            }
        } else {
            ScrollView {
                ForEach(data) { country in
                    CountryListItemView(icon: country.icon, name: country.name)
                        .onTapGesture {
                            DispatchQueue.main.async {
                                viewModel.handleListItemOnTapGesture(useCase: &useCase, value: .country(country.slug))
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
            ErrorView(.general) {
                viewModel.errorActionCallback()
            }
        case .noInternetConnection:
            ErrorView(.noInternetConnection) {
                viewModel.errorActionCallback()
            }
        case .empty:
            EmptyView()
        }
    }
}

struct CountrySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CountrySelectionView(
            viewModel: CountrySelectionViewModel(
                repository: CountriesSelectionRepositoryImpl()
            ),
            useCase: .constant(.worldwide)
        )
    }
}
