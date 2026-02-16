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
                ctx.paxCountActual = ofp.weights.pax_count_actual ?? ""
                ctx.payload = ofp.weights.payload ?? ""
                ctx.cargo = ofp.weights.cargo ?? ""
                ctx.estZfw = ofp.weights.est_zfw ?? ""
                ctx.maxZfw = ofp.weights.max_zfw ?? ""
                ctx.estTow = ofp.weights.est_tow ?? ""
                ctx.maxTow = ofp.weights.max_tow ?? ""
                ctx.estLdw = ofp.weights.est_ldw ?? ""
                ctx.maxLdw = ofp.weights.max_ldw ?? ""
                ctx.estRamp = ofp.weights.est_ramp ?? ""
                ctx.stepclimb_string = ofp.general.stepclimb_string ?? ""
                ctx.route = ofp.general.route ?? ""
                
                let times = ofp.times
                ctx.estTimeEnroute = ctx.secondsToMinutes(times.est_time_enroute)
                ctx.schedTimeEnroute = ctx.secondsToMinutes(times.sched_time_enroute)
                ctx.schedBlock = ctx.secondsToMinutes(times.sched_block)
                ctx.estBlock = ctx.secondsToMinutes(times.est_block)
                ctx.taxiOut = ctx.secondsToMinutes(times.taxi_out)
                ctx.taxiIn = ctx.secondsToMinutes(times.taxi_in)
                ctx.reserveTime = ctx.secondsToMinutes(times.reserve_time)
                ctx.endurance = ctx.secondsToMinutes(times.endurance)
                ctx.contfuelTime = ctx.secondsToMinutes(times.contfuel_time)
                ctx.etopsfuelTime = ctx.secondsToMinutes(times.etopsfuel_time)
                ctx.extrafuelTime = ctx.secondsToMinutes(times.extrafuel_time)
                ctx.schedOut = ctx.epochToTime(times.sched_out)
                ctx.schedOff = ctx.epochToTime(times.sched_off)
                ctx.schedOn = ctx.epochToTime(times.sched_on)
                ctx.schedIn = ctx.epochToTime(times.sched_in)
                ctx.estOut = ctx.epochToTime(times.est_out)
                ctx.estOff = ctx.epochToTime(times.est_off)
                ctx.estOn = ctx.epochToTime(times.est_on)
                ctx.estIn = ctx.epochToTime(times.est_in)

                
                // Update waypoints (time_total is seconds from departure)
                ctx.waypointOffsets = []

                let departureUTC = ofp.origin.time_out ?? ofp.origin.time_dep ?? ""

                ctx.waypoints = ofp.navlog.fix.map { fix in

                    let seconds = Int(fix.time_total ?? "") ?? 0
                    ctx.waypointOffsets.append(seconds)

                    return WaypointLog(
                        name: fix.ident,
                        plannedUTC: addSecondsToHHmm(
                            baseUTC: departureUTC,
                            seconds: seconds
                        ),
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
                

            }
            
        } catch {
            print("SimBrief error:", error)
        }
    }


    // MARK: - Rebuild Waypoints when depTime changes
    func rebuildWaypoints(from newDepTime: String) {

        guard newDepTime.count == 4,
              ctx.waypoints.count == ctx.waypointOffsets.count
        else { return }

        ctx.waypoints = zip(ctx.waypoints, ctx.waypointOffsets).map { wp, offset in

            return WaypointLog(
                name: wp.name,
                plannedUTC: addSecondsToHHmm(
                    baseUTC: newDepTime,
                    seconds: offset
                ),
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

func addSecondsToHHmm(baseUTC: String, seconds: Int) -> String {

    guard baseUTC.count == 4,
          let bh = Int(baseUTC.prefix(2)),
          let bm = Int(baseUTC.suffix(2)) else {
        return ""
    }

    let baseSeconds = (bh * 3600) + (bm * 60)

    let total = (baseSeconds + seconds) % (24 * 3600)

    let h = total / 3600
    let m = (total % 3600) / 60

    return String(format: "%02d%02d", h, m)
}
