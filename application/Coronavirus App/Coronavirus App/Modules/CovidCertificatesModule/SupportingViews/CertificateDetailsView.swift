//
//  CertificateDetailsView.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 23.06.2022..
//

import SwiftUI

struct CertificateDetailsView: View {
    
    let handler: CovidCertificatesViewModel
    
    @State var isAlertPresented = false
    
    init(handler: CovidCertificatesViewModel){
        self.handler = handler
    }
    
    var body: some View {
        VStack {
            List {
                if let data = handler.data,
                   let isCertificationValid = data.isCertificationValid,
                   let icon = data.icon,
                   let subtitle = data.subtitle {
                    Section {
                        HStack(spacing: 10) {
                            icon
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width * 0.17, height: UIScreen.main.bounds.width * 0.17)
                            
                            Text(subtitle)
                                .commonFont(.bold, style: .title3)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.leading)
                            
                            Spacer()
                            
                            certificateValidationImage(isCertificationValid)
                        }
                        .padding()
                        
                        listRow(text: data.title)
                    }
                    
                    Section {
                        
                        listRow(text: data.dateOfBirth)
                        
                        listRow(text: data.country)
                        
                        listRow(text: data.certificateGeneralInfo)
                        
                        listRow(text: data.certificateTypeDetails)
                        
                        listRow(text: data.activeTitle)
                        
                        if isCertificationValid {
                            HStack(spacing: 10) {
                                Image(systemName: "info.circle.fill")
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.width * 0.08)
                                
                                listRow(text: data.certificateValidationMessage)
                            }
                            .padding(.leading)
                        }
                        
                        Button {
                            handler.handleDeleteButtonAction(&isAlertPresented)
                        } label: {
                            HStack {
                                Spacer()
                                
                                Text("Delete certificate")
                                    .foregroundColor(Color(UIColor.systemRed))
                                
                                Spacer()
                            }
                        }
                        
                        Button {
                            handler.handleOKButtonAction()
                        } label: {
                            HStack {
                                Spacer()
                                
                                Text("OK")
                                    .padding([.leading, .trailing])
                                    .coronaVirusAppButtonStyle()
                                
                                Spacer()
                            }
                        }
                    }
                    .alert(isPresented: $isAlertPresented) {
                        Alert(
                            title: Text("Are you sure you want to delete certificate?"),
                            primaryButton: .default(Text("No"), action: {
                                handler.handleAlertButtonAction(type: .default, isAlertPresented: &isAlertPresented)
                            }),
                            secondaryButton: .destructive(Text("Yes"), action: {
                                handler.handleAlertButtonAction(type: .destructive, isAlertPresented: &isAlertPresented)
                            })
                        )
                    }
                } else {
                    ErrorView(.general)
                }
            }
        }
    }
}

extension CertificateDetailsView {
    @ViewBuilder
    private func listRow(text: String?) -> some View {
        if let text = text {
            Text(text)
                .commonFont(.semiBold, style: .body)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func certificateValidationImage(_ isValid: Bool) -> some View {
        Image(systemName: isValid ? "xmark" : "checkmark")
            .resizable()
            .foregroundColor(isValid == true ? Color(UIColor.systemRed) : Color(UIColor.systemGreen))
            .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.width * 0.08)
    }
}

struct CertificateDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CertificateDetailsView(
            handler: CovidCertificatesViewModel(
                repository: CovidScannerRepositoryImpl()
            )
        )
    }
}
