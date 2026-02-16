//
//  WeatherNotamView.swift
//  EFB
//
//  Created by Yuk Jun Lim on 18/1/26.
//
import SwiftUI

struct WeatherNotamView: View {
    @EnvironmentObject var ctx: FlightContext
    @State private var depMETAR = ""
    @State private var arrMETAR = ""
    @State private var isLoading = false

    private let service = WeatherService()

    var body: some View {
        Form {
            Section("Departure METAR (\(ctx.departure))") {
                TextEditor(text: $depMETAR)
                    .frame(height: 80)
                    .font(.system(.body, design: .monospaced))
            }

            Section("Arrival METAR (\(ctx.arrival))") {
                TextEditor(text: $arrMETAR)
                    .frame(height: 80)
                    .font(.system(.body, design: .monospaced))
            }

            Button {
                Task { await refreshMETARs() }
            } label: {
                HStack {
                    if isLoading {
                        ProgressView()
                    }
                    Text("Refresh METARs")
                }
            }
        }
        .navigationTitle("Weather")
        .task {
            await refreshMETARs()
        }
    }

    @MainActor
    private func refreshMETARs() async {
        guard !ctx.departure.isEmpty, !ctx.arrival.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            depMETAR = try await service.fetchMETAR(icao: ctx.departure)
            arrMETAR = try await service.fetchMETAR(icao: ctx.arrival)
        } catch {
            depMETAR = "METAR fetch failed"
            arrMETAR = "METAR fetch failed"
        }
    }
}
