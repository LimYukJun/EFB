//
//  ofpView.swift
//  EFB
//
//  Created by Yuk Jun Lim on 24/1/26.
//

import SwiftUI

struct ofpView: View {
    @EnvironmentObject var ofpCtx: OfpContext
    
    var body: some View {
        Group {
            if let store = ofpCtx.ofpStore {
                WebView(store: store)
            } else {
                ProgressView("Loading OFP...")
            }
        }
    }
}
