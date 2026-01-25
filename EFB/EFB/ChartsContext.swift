//
//  ChartsContext.swift
//  EFB
//
//  Created by Yuk Jun Lim on 24/1/26.
//


import SwiftUI
import WebKit
import Combine

final class ChartsContext: ObservableObject {

    let lidoStore: WebViewStore
    let navigraphStore: WebViewStore

    @Published var chartsLIDO: Bool = false

    init() {
        self.lidoStore = WebViewStore(
            url: URL(string: "https://planner.flightsimulator.com/landing.html")!
        )
        self.navigraphStore = WebViewStore(
            url: URL(string: "https://charts.navigraph.com/flights")!
        )
    }
}
