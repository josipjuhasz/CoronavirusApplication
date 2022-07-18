//
//  EmptyStateView.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 01.03.2022..
//

import SwiftUI

struct EmptyStateView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isShowingCountrySelection: Bool
    
    var body: some View {
            GeometryReader{ geo in
                ZStack {
                    virusImage()
                        .frame(width: 100, height: 100)
                        .offset(x: geo.size.width * 0.37, y: geo.size.height * (-0.41))
                    
                    virusImage()
                        .frame(width: 100, height: 100)
                        .offset(x: geo.size.width * (-0.5), y: geo.size.height * (-0.3))
                    
                    virusImage()
                        .frame(width: 50, height: 50)
                        .offset(x: geo.size.width * 0.48, y: geo.size.height * 0.1)
                    
                    virusImage()
                        .frame(width: 50, height: 50)
                        .offset(x: geo.size.width * (-0.4), y: geo.size.height * 0.25)
                    
                    virusImage()
                        .frame(width: 100, height: 100)
                        .offset(x: geo.size.width * 0.4, y: geo.size.height * 0.35)
                    
                    VStack(spacing: 15) {
                        
                        Spacer()
                        
                        LottieView(animationName: "virusAnimation")
                            .frame(width: geo.size.width * 0.85, height: geo.size.height * 0.4)
                        
                        Text(verbatim: .emptyStateErrorTitle)
                            .commonFont(.semiBold, style: .title3)
                            .multilineTextAlignment(.center)
                        
                        Text(verbatim: .emptyStateErrorDescription)
                            .commonFont(.regular, style: .title3)
                            .multilineTextAlignment(.center)
                        
                        Button {
                            isShowingCountrySelection.toggle()
                        } label: {
                            Text("Back to Search")
                                .coronaVirusAppButtonStyle()
                        }
                        
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                    .frame(width: geo.size.width * 0.8)
                }
                .addAppThemeBackground()
            }
    }
}

extension EmptyStateView {
    @ViewBuilder
    private func virusImage() -> some View {
        Image("virus")
            .resizable()
            .scaledToFit()
            .opacity(0.68)
            .blur(radius: 2)
    }
}
