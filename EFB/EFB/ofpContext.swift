//
//  ofpContext.swift
//  EFB
//
//  Created by Yuk Jun Lim on 24/1/26.
//

import SwiftUI
import Combine

final class OfpContext: ObservableObject {
    
    @Published var ofpStore: WebViewStore? = nil
    @EnvironmentObject var ctx: FlightContext
    private var cancellables = Set<AnyCancellable>()
    
    init(ctx: FlightContext) {
        
        // Observe pdfLink safely
        ctx.$pdfLink
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap { URL(string: $0) }
            .sink { [weak self] url in
                DispatchQueue.main.async {
                    self?.ofpStore = nil          // 🔁 force teardown
                    self?.ofpStore = WebViewStore(url: url)
                }
            }
            .store(in: &cancellables)

        print("FlightContext.pdfLink set to:", ctx.pdfLink ?? "nil")
        print("🛰 OfpContext bound to FlightContext:", ObjectIdentifier(ctx))


    }
}
