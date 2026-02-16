//
//  PerformanceView.swift
//  EFB
//
//  Created by Yuk Jun Lim on 18/1/26.
//
import SwiftUI

struct PerformanceView: View {
    @EnvironmentObject var ctx: FlightContext

    var body: some View {
        Form {
            Section("Weights") {
                LabeledValueRow(label: "PAX", value: ctx.paxCountActual)
                LabeledValueRow(label: "Payload", value: ctx.payload)
                LabeledValueRow(label: "Cargo", value: ctx.cargo)
                LabeledValueRow(label: "Est ZFW", value: ctx.estZfw)
                LabeledValueRow(label: "Max ZFW", value: ctx.maxZfw)
                LabeledValueRow(label: "Est TOW", value: ctx.estTow)
                LabeledValueRow(label: "Max TOW", value: ctx.maxTow)
                LabeledValueRow(label: "Est LDW", value: ctx.estLdw)
                LabeledValueRow(label: "Max LDW", value: ctx.maxLdw)
                LabeledValueRow(label: "Est Ramp", value: ctx.estRamp)
            }


            Section("Takeoff Performance") {

                    TextField("V1", text: $ctx.v1)
                        .keyboardType(.numberPad)

                    TextField("VR", text: $ctx.vr)
                        .keyboardType(.numberPad)

                    TextField("V2", text: $ctx.v2)
                        .keyboardType(.numberPad)

                    TextField("FLEX Temp", text: $ctx.flexTemp)
                        .keyboardType(.numberPad)
                }
        }
        .navigationTitle("Performance")
    }
}
