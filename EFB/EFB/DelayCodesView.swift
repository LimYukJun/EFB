//
//  DelayCodesView.swift
//  EFB
//
//  Created by Yuk Jun Lim on 18/1/26.
//
import SwiftUI

struct DelayCodesView: View {

    @State private var codeText: String = ""
    @State private var minutesText: String = ""
    @State private var remarks: String = ""

    @ObservedObject var ctx: FlightContext

    // Reference list only (not enforced)
    let codes = [
        DelayCode(code: "00", description: "PILOT DECISION TO DELAY FLIGHT"),
        DelayCode(code: "01", description: "PILOT ERROR DURING BOOKING PROCESS"),
        DelayCode(code: "06", description: "NO FINGER AT THE AIRPORT"),
        DelayCode(code: "07", description: "SLOW DEBOARDING OF PREVIOUS FLIGHT"),
        DelayCode(code: "09", description: "INSUFFICIENT GROUND TIME"),
        DelayCode(code: "15", description: "LATE BOARDING"),
        DelayCode(code: "22", description: "LATE LOADING OF CARGO OR MAIL"),
        DelayCode(code: "31", description: "WRONG DISPATCHING"),
        DelayCode(code: "36", description: "LATE REQUEST OF REFUELLING"),
        DelayCode(code: "37", description: "LATE REQUEST OF CATERING"),
        DelayCode(code: "41", description: "AIRCRAFT FAILURE"),
        DelayCode(code: "46", description: "AIRCRAFT CHANGE"),
        DelayCode(code: "49", description: "APU INOP"),
        DelayCode(code: "51", description: "DAMAGE DURING FLIGHT OPERATIONS"),
        DelayCode(code: "52", description: "DAMAGE WHILE GROUNDED"),
        DelayCode(code: "57", description: "SIMBRIEF OR KRISWORLD EFB FAILURE"),
        DelayCode(code: "58", description: "SIM FAILURE"),
        DelayCode(code: "59", description: "WASM CRASH"),
        DelayCode(code: "61", description: "WRONG FLIGHT DISPATCH"),
        DelayCode(code: "62", description: "MORE FUEL NEEDED"),
        DelayCode(code: "64", description: "PILOT SICKNESS"),
        DelayCode(code: "71", description: "DEPARTURE AIRPORT WEATHER RESTRICTIONS"),
        DelayCode(code: "72", description: "ARRIVAL AIRPORT WEATHER RESTRICTIONS"),
        DelayCode(code: "73", description: "ENROUTE ALTERNATE WEATHER RESTRICTIONS"),
        DelayCode(code: "75", description: "DE-ICING"),
        DelayCode(code: "76", description: "RUNWAY CLEANING"),
        DelayCode(code: "81", description: "ATC CAPACITY ENROUTE"),
        DelayCode(code: "83", description: "ATC CAPACITY AT DEPARTURE"),
        DelayCode(code: "84", description: "ATC CAPACITY AT ARRIVAL"),
        DelayCode(code: "88", description: "RUNWAY CLOSED AT DESTINATION"),
        DelayCode(code: "89", description: "RUNWAY CLOSED AT DEPARTURE"),
        DelayCode(code: "93", description: "AIRCRAFT LATE LANDING"),
        DelayCode(code: "96", description: "FLIGHT CANCELLED"),
    ]

    var body: some View {
        
        List(codes, id: \.code) { delay in
            VStack(alignment: .leading, spacing: 4) {
                Text("Code \(delay.code)")
                    .font(.headline)

                Text(delay.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        
        
        Form {

            // MARK: - Add Delay
            Section("Add Delay") {

                TextField("Delay Code (e.g. 41)", text: $codeText)
                    .keyboardType(.numberPad)

                TextField("Minutes", text: $minutesText)
                    .keyboardType(.numberPad)

                TextEditor(text: $remarks)
                    .frame(height: 80)
            }

            Button {
                submitDelay()
            } label: {
                HStack {
                    Spacer()
                    Text("Submit Delay").bold()
                    Spacer()
                }
            }
            .disabled(!canSubmit)

            // MARK: - Submitted Delays
            if !ctx.delays.isEmpty {
                Section("Recorded Delays") {
                    ForEach(ctx.delays) { delay in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Code \(delay.code) – \(delay.minutes) min")
                                .bold()

                            if !delay.remarks.isEmpty {
                                Text(delay.remarks)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete { ctx.delays.remove(atOffsets: $0) }
                }
            }

        }
        .navigationTitle("Delay Codes")
    }

    // MARK: - Helpers

    private var canSubmit: Bool {
        !codeText.isEmpty && Int(minutesText) != nil
    }

    private func submitDelay() {
        guard let minutes = Int(minutesText) else { return }

        ctx.delays.append(
            DelayEntry(code: codeText, minutes: minutes, remarks: remarks)
        )


        codeText = ""
        minutesText = ""
        remarks = ""
    }
}
