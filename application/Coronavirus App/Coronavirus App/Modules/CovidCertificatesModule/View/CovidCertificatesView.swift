//
//  CovidCertificatesView.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 28.06.2022..
//

import SwiftUI

struct CovidCertificatesView: View {
    
    @ObservedObject var viewModel: CovidCertificatesViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    init(viewModel: CovidCertificatesViewModel){
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        initAppereance()
    }
    
    private func initAppereance(){
        UITableView.appearance().separatorColor = .clear
        if let font = UIFont(name: "Montserrat-Bold", size: 25) {
            UINavigationBar.appearance().titleTextAttributes = [.font : font]
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isScanViewPresented {
                    ScanView(handler: viewModel, colorScheme: colorScheme)
                    
                } else {
                    if let certificates = viewModel.certificates {
                        if !certificates.isEmpty {
                            ScrollView(showsIndicators: false) {
                                ForEach(certificates){ item in
                                    CovidCertificatesListItem(data: item)
                                        .onTapGesture {
                                            viewModel.handleListItemTapAction(item)
                                        }
                                    if item == certificates.last {
                                        Button {
                                            viewModel.handleCertificatesTypeButtonAction()
                                        } label: {
                                            HStack {
                                                Image(systemName: viewModel.imageName)
                                                
                                                Text(viewModel.buttonTitle)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                            
                        } else {
                            Spacer()
                            
                            Text("No certificates to show!")
                                .commonFont(.semiBold, style: .body)
                                .padding(.bottom)
                            
                            if let validCertificates = viewModel.validCertificates,
                               let allCertificates = viewModel.allCertificates,
                                validCertificates.isEmpty && !allCertificates.isEmpty {
                                Button {
                                    viewModel.handleCertificatesTypeButtonAction()
                                } label: {
                                    Text("Show all certificates")
                                }
                            }
                        }
                        Spacer()
                        
                        Button {
                            viewModel.handleNewScanButtonAction()
                        } label: {
                            Text("Scan new certificate")
                                .coronaVirusAppButtonStyle()
                        }
                        .padding(.bottom)
                        
                    } else {
                        ErrorView(.general)
                    }
                }
            }
            .sheet(isPresented: $viewModel.isDetailSheetPresented, content: {
                CertificateDetailsView(handler: viewModel)
                    .onDisappear {
                        viewModel.handleOnDisappearEvent()
                    }
            })
            .sheet(isPresented: $viewModel.isErrorSheetPresented, content: {
                error()
            })
            .navigationBarTitle("Covid-19 certificates", displayMode: .inline)
            .addAppThemeBackground()
        }
    }
}

extension CovidCertificatesView {
    @ViewBuilder
    private func error() -> some View {
        VStack {
            Spacer()
            
            Text("Error while validating QR Code.")
                .commonFont(.semiBold, style: .body)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            
            Spacer()
            
            HStack {
                Button {
                    viewModel.handleErrorButtonAction(.scanAgain)
                } label: {
                    Text("Scan again")
                }
                .frame(width: UIScreen.main.bounds.width * 0.35)
                .coronaVirusAppButtonStyle()
                
                Button {
                    viewModel.handleErrorButtonAction(.back)
                } label: {
                    Text("Back")
                }
                .frame(width: UIScreen.main.bounds.width * 0.35)
                .coronaVirusAppButtonStyle()
            }
            
            Spacer()
            Spacer()
        }
        .padding()
    }
}

struct CovidCertificatesView_Previews: PreviewProvider {
    static var previews: some View {
        CovidCertificatesView(
            viewModel: CovidCertificatesViewModel(
                repository: CovidScannerRepositoryImpl()
            )
        )
    }
}
