//
//  NotamView.swift
//  EFB
//
//  Created by Yuk Jun Lim on 24/1/26.
//


import SwiftUI

struct NotamView: View {
    @EnvironmentObject var ctx: FlightContext

    var body: some View {
        List {

            if !ctx.originNotams.isEmpty {
                Section(header: Text("Origin – \(ctx.departure)")) {
                    ForEach(ctx.originNotams) { notam in
                        Text(notam.rawText)
                            .font(.system(.body, design: .monospaced))
                    }
                }
            }

            if !ctx.destinationNotams.isEmpty {
                Section(header: Text("Destination – \(ctx.arrival)")) {
                    ForEach(ctx.destinationNotams) { notam in
                        Text(notam.rawText)
                            .font(.system(.body, design: .monospaced))
                    }
                }
            }

            if !ctx.alternateNotams.isEmpty {
                Section(header: Text("Alternative – \(ctx.alternate)")) {
                    ForEach(ctx.alternateNotams) { notam in
                        Text(notam.rawText)
                            .font(.system(.body, design: .monospaced))
                    }
                }
            }
        }
        .navigationTitle("NOTAMs")

    }
}
