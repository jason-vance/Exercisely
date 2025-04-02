//
//  WebView.swift
//  Exercisely
//
//  Created by Jason Vance on 4/1/25.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let html: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: nil)
    }
}

#Preview {
    WebView(html: "<h1>Hello, World!</h1>")
}
