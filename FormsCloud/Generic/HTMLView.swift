//
//  HTMLView.swift
//  FormsCloud
//
//  Created by Guilherme Motti on 10/08/25.
//

import WebKit
import SwiftUI

struct HTMLView: UIViewRepresentable {
    let html: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: nil)
    }
}
