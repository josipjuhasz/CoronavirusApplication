//
//  LoaderView.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 28.12.2021..
//

import SwiftUI

struct LoaderView: View {
    
    var body: some View {
        LottieView(animationName: "virusAnimation")
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}
