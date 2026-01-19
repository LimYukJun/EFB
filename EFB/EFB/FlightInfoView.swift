//
//  FlightInfoView.swift
//  EFB
//
//  Created by Yuk Jun Lim on 18/1/26.
//

import SwiftUI

struct FlightInfoView: View {
    @EnvironmentObject var ctx: FlightContext
    @State private var simbriefID = ""
    @State private var isLoading = false
    @State var depTime: String
    @Binding var chartsLIDO: Bool

    let simbrief = SimBriefService()

    var body: some View {
        Form {
            Section("SimBrief and Navigraph") {
                TextField("SimBrief Pilot ID", text: $simbriefID)
                Button(isLoading ? "Loading..." : "Import OFP") {
                    Task { await loadSimBrief() }
                }
                Toggle("LIDO Charts", isOn: $chartsLIDO)
            }

            Section("Flight") {
                TextField("Airline (ICAO)", text: $ctx.airline)
                    .textInputAutocapitalization(.characters)

                TextField("Flight Number", text: $ctx.flightNumber)
                    .keyboardType(.numberPad)

                HStack {
                    Text("Callsign")
                    Spacer()
                    Text(ctx.callsign.isEmpty ? "—" : ctx.callsign)
                        .bold()
                        .monospaced()
                }

                TextField("Departure", text: $ctx.departure)
                    .textInputAutocapitalization(.characters)

                TextField("Arrival", text: $ctx.arrival)
                    .textInputAutocapitalization(.characters)
                
                // Update waypoints if depTime changes
                TextField("Departure Time (HHmm)", text: $depTime)
                    .textInputAutocapitalization(.characters)
                    .onChange(of: depTime) { oldValue, newValue in
                        rebuildWaypoints(from: newValue)
                    }
            }

            Section("Runways & Fuel") {
                TextField("DEP Runway", text: $ctx.depRunway)
                TextField("ARR Runway", text: $ctx.arrRunway)
                TextField("Planned Fuel", text: $ctx.plannedFuel)
            }
        }
        .navigationTitle("Flight Info")
    }

    // MARK: - Load SimBrief OFP
    func loadSimBrief() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let ofp = try await simbrief.fetchOFP(pilotID: simbriefID)

            let rawCallsign =
                ofp.general.callsign ??
                ofp.atc?.callsign ??
                "\(ofp.general.airline_icao ?? "")\(ofp.general.flight_number ?? "")"

            let extractedAirline = rawCallsign.prefix { $0.isLetter }

            if ctx.airline.isEmpty {
                ctx.airline = extractedAirline.uppercased()
            }
            ctx.flightNumber = ofp.general.flight_number ?? ""
            ctx.departure = ofp.origin.icao_code ?? ""
            ctx.arrival = ofp.destination.icao_code ?? ""
            ctx.depRunway = ofp.origin.plan_rwy ?? ""
            ctx.arrRunway = ofp.destination.plan_rwy ?? ""
            ctx.plannedFuel = ofp.fuel.plan_ramp ?? ""
            ctx.takeoffWeight = ofp.weights.takeoff ?? ""
            ctx.landingWeight = ofp.weights.landing ?? ""

            // Build waypoints initially
            let departureUTC = ofp.origin.time_out ?? ofp.origin.time_dep ?? depTime

            await MainActor.run {
                var elapsedSeconds = 0
                ctx.waypointOffsets = []
                
                ctx.waypoints = ofp.navlog.fix.map { fix in
                    let seconds = Int(fix.time_total ?? "") ?? 0
                    ctx.waypointOffsets.append(seconds)
                    elapsedSeconds += seconds
                    
                    return WaypointLog(
                        name: fix.ident,
                        plannedUTC: addSecondsToUTC(departureUTC, seconds: elapsedSeconds),
                        plannedFOB: fix.fuel_plan_onboard ?? "",
                        actualUTC: "",
                        actualFOB: ""
                    )
                }
            }

        } catch {
            print("SimBrief error:", error)
        }
    }

    // MARK: - Rebuild Waypoints when depTime changes
    func rebuildWaypoints(from newDepTime: String) {
        guard !newDepTime.isEmpty, ctx.waypoints.count == ctx.waypointOffsets.count else { return }

        var elapsedSeconds = 0
        ctx.waypoints = zip(ctx.waypoints, ctx.waypointOffsets).map { wp, offset in
            elapsedSeconds += offset
            return WaypointLog(
                name: wp.name,
                plannedUTC: addSecondsToUTC(newDepTime, seconds: elapsedSeconds),
                plannedFOB: wp.plannedFOB,
                actualUTC: wp.actualUTC,
                actualFOB: wp.actualFOB
            )
        }
    }


    // MARK: - Add seconds helper
    func addSecondsToUTC(_ utcTime: String, seconds: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard
            let date = formatter.date(from: utcTime),
            let newDate = Calendar.current.date(byAdding: .second, value: seconds, to: date)
        else { return "" }

        return formatter.string(from: newDate)
    }
}
