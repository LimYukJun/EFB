//
//  TimesView.swift
//  EFB
//
//  Created by Yuk Jun Lim on 16/2/26.
//


import SwiftUI

struct TimesView: View {
    @EnvironmentObject var ctx: FlightContext

    var body: some View {
        List {

            Section("Enroute") {
                row("Scheduled", ctx.schedTimeEnroute)
                row("Estimated", ctx.estTimeEnroute)
            }

            Section("Block") {
                row("Scheduled Block", ctx.schedBlock)
                row("Estimated Block", ctx.estBlock)
                row("Taxi Out", ctx.taxiOut)
                row("Taxi In", ctx.taxiIn)
            }

            Section("Fuel Times") {
                row("Reserve", ctx.reserveTime)
                row("Endurance", ctx.endurance)
                row("Cont Fuel", ctx.contfuelTime)
                row("ETOPS Fuel", ctx.etopsfuelTime)
                row("Extra Fuel", ctx.extrafuelTime)
            }

            Section("Scheduled Times (UTC)") {
                row("OUT", ctx.schedOut)
                row("OFF", ctx.schedOff)
                row("ON", ctx.schedOn)
                row("IN", ctx.schedIn)
            }

            Section("Estimated Times (UTC)") {
                row("OUT", ctx.estOut)
                row("OFF", ctx.estOff)
                row("ON", ctx.estOn)
                row("IN", ctx.estIn)
            }
            
            Section(header: Text("Actual Times (UTC)")) {

                TextField("Out (HHMM)", text: $ctx.actualOut)
                    .keyboardType(.numberPad)

                TextField("Off (HHMM)", text: $ctx.actualOff)
                    .keyboardType(.numberPad)

                TextField("On (HHMM)", text: $ctx.actualOn)
                    .keyboardType(.numberPad)

                TextField("In (HHMM)", text: $ctx.actualIn)
                    .keyboardType(.numberPad)
            }

        }
        .navigationTitle("Times")
    }

    private func row(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}
