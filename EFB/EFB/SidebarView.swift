//
//  SidebarView.swift
//  EFB
//
//  Created by Yuk Jun Lim on 18/1/26.
//

import SwiftUI

struct SidebarView: View {
    
    @ObservedObject var ctx: FlightContext
    @State private var chartsLIDO = false
    
    var body: some View {
        List {
            NavigationLink("Flight Info") {
                FlightInfoView(depTime: "", chartsLIDO: $chartsLIDO)
            }

            NavigationLink("Performance") {
                PerformanceView()
            }

            NavigationLink("Waypoints") {
                WaypointsView(ctx: ctx)
            }

            NavigationLink("Weather") {
                WeatherNotamView()
            }

            NavigationLink("Delay Codes") {
                DelayCodesView(ctx:ctx)
            }
            NavigationLink("Charts") {
                ChartsView(chartsLIDO: $chartsLIDO)
            }
            NavigationLink("Submit Flight") {
                SubmitView(ctx: ctx)
            }

        }
        .navigationTitle("Pilot EFB")
    }
}
