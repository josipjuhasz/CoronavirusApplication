//
//  LatestNewsListItemView.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 13.05.2022..
//

import SwiftUI
import Kingfisher

struct LatestNewsListItemView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let item: LatestNewsDetails?
    let geo: GeometryProxy
    
    init(item: LatestNewsDetails?, geo: GeometryProxy){
        self.item = item
        self.geo = geo
    }
    
    var body: some View {
        VStack {
            if let item = item {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.darkGrayBackground)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(colorScheme == .light ? Color(UIColor.systemGray2).opacity(0.2) : Color.clear, lineWidth: 2)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            if let image = item.image {
                                KFImage(URL(string: image))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.15)
                                    .cornerRadius(10)
                                
                            } else {
                                Image("broken")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.15)
                                    .cornerRadius(10)
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text(item.title)
                                    .commonFont(.semiBold, style: .headline)
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                                    .lineLimit(3)
                                    .multilineTextAlignment(.leading)
                                
                                Text(item.description)
                                    .commonFont(.regular, style: .subheadline)
                                    .foregroundColor(Color(UIColor.systemGray))
                                    .lineLimit(3)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .padding([.top, .leading, .trailing])
                        
                        Text(item.passedTime)
                            .commonFont(.regular, style: .subheadline)
                            .foregroundColor(Color(UIColor.systemGray2))
                            .padding()
                            .lineLimit(1)
                    }
                    .cornerRadius(50)
                }
            } else {
                ErrorView(.general)
            }
        }
    }
}

struct LatestNewsListItemView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { item in
            LatestNewsListItemView(
                item: LatestNewsDetails(
                    title: "Titlte",
                    description: "Description",
                    url: "URL",
                    source: "SOURCE",
                    image: "IMAGE",
                    date: "DATE"),
                geo: item)
        }
    }
}
