//
//  CountryListItemView.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 25.02.2022..
//

import SwiftUI

struct CountryListItemView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let icon: String?
    let name: String?
    
    init(icon: String?, name: String?){
        self.icon = icon
        self.name = name
    }
    
    var body: some View {
        if let icon = icon,
           let name = name {
            HStack() {
                Text("\(icon)")
                
                Text("\(name)")
                    .commonFont(name == "Worldwide" ? .bold : .semiBold, style: .title3)
                
                Spacer()
            }
            .padding()
        } else {
            ErrorView(.general)
        }
    }
}

struct CountryListItemView_Previews: PreviewProvider {
    static var previews: some View {
        CountryListItemView(icon: "Icon", name: "Name")
    }
}
