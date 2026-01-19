//
//  ChartsView.swift
//  EFB
//
//  Created by Yuk Jun Lim on 19/1/26.
//

import SwiftUI
import WebKit

struct ChartsView: View {
    
    @Binding var chartsLIDO:Bool
    
    var body: some View {
        if chartsLIDO {
            WebView(url: URL(string: "https://planner.flightsimulator.com/landing.html"))
        }else{
            WebView(url: URL(string: "https://charts.navigraph.com/flights"))
        }
    }
}
