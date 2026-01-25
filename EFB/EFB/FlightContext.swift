//
//  FlightContext.swift
//  EFB
//
//  Created by Yuk Jun Lim on 18/1/26.
//


import Foundation
import Combine

final class FlightContext: ObservableObject {

    @Published var airline = ""
    @Published var flightNumber = ""

    var callsign: String {
        "\(airline)\(flightNumber)"
    }

    @Published var departure = ""
    @Published var arrival = ""
    @Published var alternate = ""
    @Published var depRunway = ""
    @Published var arrRunway = ""
    @Published var plannedFuel = ""
    @Published var fuelTaxi = ""
    @Published var fuelEnroute = ""
    @Published var fuelContingency = ""
    @Published var fuelAlternate = ""
    @Published var fuelReserve = ""
    @Published var fuelExtra = ""
    @Published var fuelMinTakeoff = ""
    @Published var fuelPlanTakeoff = ""
    @Published var fuelPlanLanding = ""
    @Published var takeoffWeight = ""
    @Published var landingWeight = ""
    @Published var route = ""
    @Published var stepclimb_string = ""

    @Published var waypoints: [WaypointLog] = []

    @Published var metar = ""
    @Published var notams = ""

    var waypointOffsets: [Int] = []
    @Published var delays: [DelayEntry] = []

    @Published var v1: String = ""
    @Published var vr: String = ""
    @Published var v2: String = ""
    @Published var flexTemp: String = ""

    @Published var pdfLink: String? = nil {
        didSet {
            print("📌 FlightContext.pdfLink didSet →", pdfLink as Any)
            print("🧵 Thread:", Thread.isMainThread ? "main" : "background")
        }
    }
    
    @Published var originNotams: [Notam] = []
    @Published var destinationNotams: [Notam] = []
    @Published var alternateNotams: [Notam] = []

}
