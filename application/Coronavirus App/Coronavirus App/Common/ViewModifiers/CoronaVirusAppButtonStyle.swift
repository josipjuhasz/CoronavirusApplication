//
//  CoronaVirusAppButtonStyle.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 30.03.2022..
//

import SwiftUI

struct CoronaVirusAppButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(.white)
            .background(Color(UIColor.systemRed).opacity(0.6))
            .cornerRadius(10)
    }
}
