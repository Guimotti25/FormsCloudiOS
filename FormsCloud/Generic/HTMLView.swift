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
    
    // Cria a view do UIKit (WKWebView)
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    // Atualiza a view com os novos dados do SwiftUI
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: nil)
    }
}
