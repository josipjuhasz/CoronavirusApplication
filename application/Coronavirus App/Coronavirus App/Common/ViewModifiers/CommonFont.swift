//
//  CommonFont.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 08.03.2022..
//

import SwiftUI

struct CommonFont: ViewModifier {
    
    var type: FontType
    var style: UIFont.TextStyle
    
    func body(content: Content) -> some View {
        return content
            .font(Font.custom(type.rawValue, size: UIFont.preferredFont(forTextStyle: style).pointSize))
    }
}
