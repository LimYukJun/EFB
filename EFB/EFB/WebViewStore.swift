//
//  WebViewStore.swift
//  EFB
//
//  Created by Yuk Jun Lim on 24/1/26.
//


import SwiftUI
import WebKit
import Combine

final class WebViewStore: ObservableObject {
    let webView: WKWebView

    init(url: URL) {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()

        self.webView = WKWebView(frame: .zero, configuration: config)
        self.webView.load(URLRequest(url: url))
    }

    // ✅ ADD THIS
    func load(url: URL) {
        webView.load(URLRequest(url: url))
    }
}
