//
//  HomeListItemView.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 27.03.2022..
//

import SwiftUI

struct HomeListItemView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let title: String?
    let confirmed: String?
    let active: String?
    let deaths: String?
    let recovered: String?
    
    init(title: String?, confirmed: String?, active: String?, deaths: String?, recovered: String?){
        self.title = title
        self.confirmed = confirmed
        self.active = active
        self.deaths = deaths
        self.recovered = recovered
    }
    
    private var firstListItem: Bool {
        title == "Date" || title == "State"
    }
    
    var body: some View {
        GeometryReader { geo in
            if let title = title,
               let confirmed = confirmed,
               let active = active,
               let deaths = deaths,
               let recovered = recovered {
                HStack {
                    listItem(value: "\(title)", color: .black, width: geo.size.width * 2)
                    
                    listItem(value: "\(confirmed)", color: Color(UIColor.systemRed), width: geo.size.width)
                    
                    listItem(value: "\(active)", color: Color(UIColor.systemBlue), width: geo.size.width)
                    
                    listItem(value: "\(recovered)", color: Color(UIColor.systemGreen), width: geo.size.width)
                    
                    listItem(value: "\(deaths)", color: Color(UIColor.systemGray), width: geo.size.width)
                }
            } else {
                ErrorView(.general)
            }
        }
    }
}

extension HomeListItemView {
    @ViewBuilder
    private func listItem(value: String, color: Color, width: CGFloat) -> some View {
        Text(value)
            .padding([.top, .bottom])
            .frame(width: width * 0.15)
            .commonFont(firstListItem == true ? .bold : .regular, style: .caption2)
            .foregroundColor(firstListItem == true ? color : .black)
            .background(firstListItem == true ? Color.homeViewCellHeader : Color.homeViewCell)
            .cornerRadius(5)
    }
}

struct HomeListItemView_Previews: PreviewProvider {
    static var previews: some View {
        HomeListItemView(
            title: "Title",
            confirmed: "Confirmed",
            active: "Active",
            deaths: "Deaths",
            recovered: "Recovered"
        )
    }
}
