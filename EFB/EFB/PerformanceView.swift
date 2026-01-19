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
                TextField("Takeoff Weight", text: $ctx.takeoffWeight)
                TextField("Landing Weight", text: $ctx.landingWeight)
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
