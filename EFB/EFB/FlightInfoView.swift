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

    let simbrief = SimBriefService()

    var body: some View {
        Form {
            Section("SimBrief and Navigraph") {
                TextField("SimBrief Pilot ID", text: $simbriefID)
                Button(isLoading ? "Loading..." : "Import OFP") {
                    Task { await loadSimBrief() }
                }
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
                
                TextField("Step Alts (FL)", text: $ctx.stepclimb_string)
                    .textInputAutocapitalization(.characters)
                
                TextField("Route", text: $ctx.route)
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
            }
            
            Section("Fuel") {
                LabeledValueRow(label: "Taxi Fuel", value: ctx.fuelTaxi)
                LabeledValueRow(label: "Enroute Burn", value: ctx.fuelEnroute)
                LabeledValueRow(label: "Contingency", value: ctx.fuelContingency)
                LabeledValueRow(label: "Alternate", value: ctx.fuelAlternate)
                LabeledValueRow(label: "Reserve", value: ctx.fuelReserve)
                LabeledValueRow(label: "Extra", value: ctx.fuelExtra)
                LabeledValueRow(label: "Min Takeoff Fuel", value: ctx.fuelMinTakeoff)
                LabeledValueRow(label: "Planned Takeoff Fuel", value: ctx.fuelPlanTakeoff)
                LabeledValueRow(label: "Planned Ramp Fuel", value: ctx.plannedFuel)
                LabeledValueRow(label: "Planned Landing Fuel", value: ctx.fuelPlanLanding)
            }


        }
        .navigationTitle("Flight Info")
    }

    // MARK: - Load SimBrief OFP
    func loadSimBrief() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await simbrief.fetchOFP(pilotID: simbriefID)
            let ofp = result.response
            print("📦 SimBrief result.pdfLink:", result.pdfLink as Any)
            let rawCallsign =
                ofp.general.callsign ??
                ofp.atc?.callsign ??
                "\(ofp.general.icao_airline ?? "")\(ofp.general.flight_number ?? "")"
            let extractedAirline = rawCallsign.prefix { $0.isLetter }
            
            await MainActor.run {
                // Update flight info
                if ctx.airline.isEmpty { ctx.airline = extractedAirline.uppercased() }
                ctx.flightNumber = ofp.general.flight_number ?? ""
                ctx.departure = ofp.origin.icao_code ?? ""
                ctx.arrival = ofp.destination.icao_code ?? ""
                ctx.alternate = ofp.alternate.icao_code ?? ""
                ctx.depRunway = ofp.origin.plan_rwy ?? ""
                ctx.arrRunway = ofp.destination.plan_rwy ?? ""
                ctx.plannedFuel = ofp.fuel.plan_ramp ?? ""
                ctx.fuelTaxi = ofp.fuel.taxi ?? ""
                ctx.fuelEnroute = ofp.fuel.enroute_burn ?? ""
                ctx.fuelContingency = ofp.fuel.contingency ?? ""
                ctx.fuelAlternate = ofp.fuel.alternate_burn ?? ""
                ctx.fuelReserve = ofp.fuel.reserve ?? ""
                ctx.fuelExtra = ofp.fuel.extra ?? ""
                ctx.fuelMinTakeoff = ofp.fuel.min_takeoff ?? ""
                ctx.fuelPlanTakeoff = ofp.fuel.plan_takeoff ?? ""
                ctx.plannedFuel = ofp.fuel.plan_ramp ?? ""
                ctx.fuelPlanLanding = ofp.fuel.plan_landing ?? ""
                ctx.takeoffWeight = ofp.weights.takeoff ?? ""
                ctx.landingWeight = ofp.weights.landing ?? ""
                ctx.stepclimb_string = ofp.general.stepclimb_string ?? ""
                ctx.route = ofp.general.route ?? ""
                
                // Update waypoints
                var elapsedSeconds = 0
                ctx.waypointOffsets = []
                let departureUTC = ofp.origin.time_out ?? ofp.origin.time_dep ?? ""
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
                
                if let pdfLink = result.pdfLink {
                    ctx.pdfLink = pdfLink
                }

                // ORIGIN NOTAMs (raw text only)
                let originICAO = result.response.origin.icao_code ?? ""

                let notams: [Notam] =
                    result.response.origin.notam?.values
                        .compactMap { $0.notam_raw }
                        .map {
                            Notam(
                                airportICAO: originICAO,
                                rawText: $0
                            )
                        } ?? []

                DispatchQueue.main.async {
                    ctx.originNotams = notams
                }
                
                // DESTINATION NOTAMs (raw text only)
                let destinationICAO = result.response.destination.icao_code ?? ""

                let destinationNotams: [Notam] =
                    result.response.destination.notam?.values
                        .compactMap { $0.notam_raw }
                        .map {
                            Notam(
                                airportICAO: destinationICAO,
                                rawText: $0
                            )
                        } ?? []

                DispatchQueue.main.async {
                    ctx.destinationNotams = destinationNotams
                }
                
                // ALTERNATE NOTAMs (raw text only)
                let alternateICAO = result.response.alternate.icao_code ?? ""

                let alternateNotams: [Notam] =
                    result.response.alternate.notam?.values
                        .compactMap { $0.notam_raw }
                        .map {
                            Notam(
                                airportICAO: alternateICAO,
                                rawText: $0
                            )
                        } ?? []

                DispatchQueue.main.async {
                    ctx.destinationNotams = destinationNotams
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


struct LabeledValueRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value.isEmpty ? "—" : value)
                .bold()
                .monospacedDigit()
        }
    }
}
