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
    
    let item: LatestNewsDetails
    let geo: GeometryProxy
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.dashboard)
                
                RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(colorScheme == .light ? Color(UIColor.systemGray2).opacity(0.2) : Color.clear, lineWidth: 2)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        if item.image == nil {
                            Image("brokenImage")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.15)
                                .cornerRadius(10)
                            
                        } else {
                            KFImage(URL(string: item.image ?? ""))
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
                    
                    Text("\(item.source) • \(RelativeDateTimeFormatter.standard.localizedString(for: DateUtils().parseToDate(dateString: item.date), relativeTo: Date()))")
                        .commonFont(.regular, style: .subheadline)
                        .foregroundColor(Color(UIColor.systemGray2))
                        .padding()
                        .lineLimit(1)
                }
                .cornerRadius(50)
            }
        }
    }
}
