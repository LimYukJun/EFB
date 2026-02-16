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

        ScrollViewReader { proxy in

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
                    // 👇 This is required so we can scroll to it
                    .id(wp.id)
                }
            }
            .navigationTitle("Waypoints")
            .navigationBarTitleDisplayMode(.inline)


            // ✅ Top bar with waypoint shortcuts
            .safeAreaInset(edge: .top) {
                waypointBar(proxy: proxy)
            }
        }
    }

    // MARK: - Waypoint jump bar
    @ViewBuilder
    private func waypointBar(proxy: ScrollViewProxy) -> some View {

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {

                ForEach(ctx.waypoints) { wp in
                    Button {
                        withAnimation {
                            proxy.scrollTo(wp.id, anchor: .top)
                        }
                    } label: {
                        Text(wp.name)
                            .font(.footnote)
                            .monospaced()
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(.thinMaterial)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
        }
        .background(.ultraThinMaterial)
    }
}
