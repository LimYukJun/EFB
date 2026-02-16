//
//  SidebarView.swift
//  EFB
//
//  Created by Yuk Jun Lim on 18/1/26.
//

import SwiftUI

struct SidebarView: View {
    
    @ObservedObject var ctx: FlightContext
    
    var body: some View {
        List {
            NavigationLink("Flight Info") {
                FlightInfoView(depTime: "")
            }
            
            Section {
                NavigationLink("Fuel & Weights") {
                    FuelView()
                }
            }

            NavigationLink("Performance") {
                PerformanceView()
            }
            
            NavigationLink("Times") {
                TimesView()
                    .environmentObject(ctx)
            }

            NavigationLink("Waypoints") {
                WaypointsView(ctx: ctx)
            }

            NavigationLink("Weather") {
                WeatherNotamView()
            }
            
            NavigationLink("NOTAMs") {
                NotamView()
            }

            NavigationLink("Delay Codes") {
                DelayCodesView(ctx:ctx)
            }
            NavigationLink("Charts") {
                ChartsView()
            }
            NavigationLink("OFP") {
                ofpView()
                    .environmentObject(OfpContext(ctx: ctx))
            }
            NavigationLink("Submit Flight") {
                SubmitView(ctx: ctx)
            }

        }
        .navigationTitle("Pilot EFB")
    }
}
