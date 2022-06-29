//
//  ErrorModule.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 30.03.2022..
//

import SwiftUI

enum ErrorViewType {
    case general
    case noInternetConnection
}

struct ErrorView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    let errorType: ErrorViewType
    
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        
        VStack(spacing: 30) {
            
            Spacer()
            
            switch errorType {
            case .general:
                Image("generalError")
                    .resizable()
                    .foregroundColor(Color.red.opacity(0.5))
                    .frame(width: width * 0.7, height: width / 2.1)
                
            case .noInternetConnection:
                Image(systemName: "wifi.slash")
                    .resizable()
                    .foregroundColor(Color.red.opacity(0.5))
                    .frame(width: width * 0.6, height: width / 2.1)
            }
            
            Text(verbatim: errorType == .noInternetConnection ? .noInternetErrorTitle : .generalErrorTitle)
                .commonFont(.regular, style: .title2)
            
            Text(verbatim: errorType == .noInternetConnection ? .noInternetErrorDescription : .generalErrorDescription)
                .commonFont(.regular, style: .title3)
                .foregroundColor(Color(UIColor.systemGray))
            
            Button(errorType == .noInternetConnection ? String.noInternetErrorButtonTitle : String.generalErrorButtonTitle) {}
            .coronaVirusAppButtonStyle()
            
            Spacer()
            Spacer()
        }
        .addAppThemeBackground()
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(errorType: .noInternetConnection)
    }
}
