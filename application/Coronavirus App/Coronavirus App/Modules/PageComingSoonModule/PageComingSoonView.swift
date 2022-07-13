//
//  PageComingSoonView.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 30.12.2021..
//

import SwiftUI

struct PageComingSoonView: View {
    
    var body: some View {
        GeometryReader { geo in
            VStack() {
                LoaderView()
                    .frame(height: geo.size.height * 0.5)
                
                Text(verbatim: .pageComingSoonMessage)
                    .commonFont(.regular, style: .title1)
                
                Spacer()
            }
            .addAppThemeBackground()
        }
    }
}
