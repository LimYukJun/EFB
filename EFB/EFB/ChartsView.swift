//
//  ChartsView.swift
//  EFB
//
//  Created by Yuk Jun Lim on 19/1/26.
//

import SwiftUI

struct ChartsView: View {

    @EnvironmentObject var chartsCtx: ChartsContext

    var body: some View {
        Group {
            if chartsCtx.chartsLIDO {
                WebView(store: chartsCtx.lidoStore)
            } else {
                WebView(store: chartsCtx.navigraphStore)
            }
        }
        .navigationTitle(chartsCtx.chartsLIDO ? "LIDO Charts" : "Navigraph")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Toggle("LIDO", isOn: $chartsCtx.chartsLIDO)
                    .toggleStyle(.switch)
            }
        }
    }
}
