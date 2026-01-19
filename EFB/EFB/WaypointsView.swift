//
//  WaypointsView.swift
//  EFB
//
//  Created by Yuk Jun Lim on 18/1/26.
//
import SwiftUI

struct WaypointsView: View {

    @ObservedObject var ctx: FlightContext

    var body: some View {
        List {
            ForEach($ctx.waypoints) { $wp in
                Section(wp.name) {

                    HStack {
                        Text("Planned UTC")
                        Spacer()
                        Text(wp.plannedUTC)
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Planned FOB")
                        Spacer()
                        Text(wp.plannedFOB)
                            .foregroundStyle(.secondary)
                    }


                    TextField("Actual UTC", text: $wp.actualUTC)
                    TextField("Actual FOB", text: $wp.actualFOB)
                        .keyboardType(.numberPad)
                }
            }
        }
        .refreshable {
            print("Refresh")
        }
        .navigationTitle("Waypoints")
    }
}
