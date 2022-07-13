//
//  ProjectFont.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 14.12.2021..
//


import SwiftUI

enum FontType: String {
    
    case regular = "Montserrat"
    case bold = "Montserrat-Bold"
    case semiBold = "Montserrat-SemiBold"
}

extension View {
    func commonFont(_ type: FontType, style: UIFont.TextStyle) -> some View {
        
        return self.modifier(CommonFont(type: type, style: style))
    }
    
    func navigationOverride(colorScheme: ColorScheme, actionBack: @escaping () -> Void) -> some View {
        
        navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button(action: actionBack) {
                    Image(systemName: "chevron.backward")
                        .frame(width: 50, alignment: .leading)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .offset(x: 20)
                })
    }
    
    func addAppThemeBackground() -> some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            self
        }
    }
    
    func coronaVirusAppButtonStyle() -> some View {
        
        return self.modifier(CoronaVirusAppButtonStyle())
    }
}
