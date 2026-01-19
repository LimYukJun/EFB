//
//  EFBApp.swift
//  EFB
//
//  Created by Yuk Jun Lim on 18/1/26.
//

import SwiftUI

@main
struct EFBApp: App {
    @StateObject private var ctx = FlightContext()

        var body: some Scene {
            WindowGroup {
                ContentView(ctx:ctx)
                    .environmentObject(ctx)
            }
        }
}
