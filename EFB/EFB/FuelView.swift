//
//  FuelView.swift
//  EFB
//
//  Created by Yuk Jun Lim on 16/2/26.
//


import SwiftUI

struct FuelView: View {

    @EnvironmentObject var ctx: FlightContext

    var body: some View {

        Form {

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
        .navigationTitle("Fuel")
        .navigationBarTitleDisplayMode(.inline)
    }
}
