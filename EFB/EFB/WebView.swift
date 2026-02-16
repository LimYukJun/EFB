//
//  WebView.swift
//  EFB
//
//  Created by Yuk Jun Lim on 24/1/26.
//


import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    @ObservedObject var store: WebViewStore

    func makeUIView(context: Context) -> WKWebView {
        store.webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // intentionally empty — prevents reload
    }
}
