//
//  SubmitView.swift
//  EFB
//
//  Created by Yuk Jun Lim on 19/1/26.
//


import SwiftUI
import MessageUI

struct SubmitView: View {

    @ObservedObject var ctx: FlightContext
    @State private var showMail = false

    var body: some View {
        Form {

            Section("Submit Flight") {
                Button("Send Flight Report") {
                    showMail = true
                }
            }
        }
        .navigationTitle("Submit")
        .sheet(isPresented: $showMail) {
            MailComposerView(
                subject: "\(ctx.airline)\(ctx.flightNumber) Flight Report",
                body: ctx.buildEmailBody(),
                recipients: ["limyukjun24@gmail.com"]
            )
        }
    }
}
