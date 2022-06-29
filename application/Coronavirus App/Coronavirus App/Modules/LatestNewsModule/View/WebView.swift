//
//  WebView.swift
//  Coronavirus App
//
//  Created by Josip Juhasz on 13.05.2022..
//

import SwiftUI
import WebKit
import UIKit

struct WebView: UIViewRepresentable {
    
    let url: URL
    var webView = WKWebView()
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
