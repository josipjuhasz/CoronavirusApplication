//
//  HomeListItemView.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 27.03.2022..
//

import SwiftUI

struct HomeListItemView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var title: String
    var confirmed: String
    var active: String
    var deaths: String
    var recovered: String
    
    private var firstListItem: Bool {
        return title == "Date" || title == "State"
    }
    
    var body: some View {
        
        GeometryReader { geo in
            
            HStack {
                renderHomeListItem(value: "\(title)", color: .black, width: geo.size.width * 2)
                
                renderHomeListItem(value: "\(confirmed)", color: Color(UIColor.systemRed), width: geo.size.width)
                
                renderHomeListItem(value: "\(active)", color: Color(UIColor.systemBlue), width: geo.size.width)
                
                renderHomeListItem(value: "\(recovered)", color: Color(UIColor.systemGreen), width: geo.size.width)
                
                renderHomeListItem(value: "\(deaths)", color: Color(UIColor.systemGray), width: geo.size.width)
            }
        }
    }
}

extension HomeListItemView {
    @ViewBuilder
    private func renderHomeListItem(value: String, color: Color, width: CGFloat) -> some View {
        
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
        HomeListItemView(title: "State1", confirmed: "13132123123213", active: "2131232311232213", deaths: "213123321213213", recovered: "12331212321")
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}

