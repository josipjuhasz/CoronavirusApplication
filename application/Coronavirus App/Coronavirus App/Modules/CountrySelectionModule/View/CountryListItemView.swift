//
//  CountryListItemView.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 25.02.2022..
//

import SwiftUI

struct CountryListItemView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let icon: String
    let name: String
    
    var body: some View {
        HStack() {
            Text("\(icon)")
            
            Text("\(name)")
                .commonFont(name == "Worldwide" ? .bold : .semiBold, style: .title3)
            
            Spacer()
        }
        .padding()
    }
}

struct CountryListItem_Previews: PreviewProvider {
    static var previews: some View {
        CountryListItemView(icon: "", name: "")
            .previewLayout(.sizeThatFits)
    }
}
