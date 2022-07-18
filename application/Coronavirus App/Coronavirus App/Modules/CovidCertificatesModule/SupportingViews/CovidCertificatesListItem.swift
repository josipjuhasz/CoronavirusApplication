//
//  CovidCertificatesListItem.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 29.06.2022..
//

import SwiftUI
import EUDCC
import EUDCCValidator

struct CovidCertificatesListItem: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let data: CovidCertificateDomainItem?
    
    init(data: CovidCertificateDomainItem?){
        self.data = data
    }
    
    var body: some View {
        VStack {
            if let data = data,
               let title = data.title,
               let subtitle = data.subtitle,
               let icon = data.icon,
               let isValid = data.isCertificationValid {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.darkGrayBackground)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(colorScheme == .light ? Color(UIColor.systemGray2).opacity(0.2) : Color.clear, lineWidth: 2)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            icon
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.13, height: UIScreen.main.bounds.height * 0.13)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text(title)
                                    .commonFont(.semiBold, style: .headline)
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                
                                Text(subtitle)
                                    .commonFont(.regular, style: .subheadline)
                                    .foregroundColor(Color(UIColor.systemGray))
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.leading)
                            
                            Spacer()
                            
                            Image(systemName: isValid ? "xmark" : "checkmark")
                                .resizable()
                                .foregroundColor(isValid == true ? Color(UIColor.systemRed) : Color(UIColor.systemGreen))
                                .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.width * 0.08)
                        }
                    }
                    .padding()
                }
            } else {
                ErrorView(.general)
            }
        }
    }
}
