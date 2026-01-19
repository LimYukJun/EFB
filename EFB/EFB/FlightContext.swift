//
//  FlightContext.swift
//  EFB
//
//  Created by Yuk Jun Lim on 18/1/26.
//


import Foundation
import Combine

final class FlightContext: ObservableObject {
    @Published var airline = ""          // e.g. SIA
    @Published var flightNumber = ""      // e.g. 325
    
    var callsign: String {
        "\(airline)\(flightNumber)"
    }

    @Published var departure = ""
    @Published var arrival = ""
    @Published var depRunway = ""
    @Published var arrRunway = ""
    @Published var plannedFuel = ""
    @Published var takeoffWeight = ""
    @Published var landingWeight = ""

    @Published var waypoints: [WaypointLog] = []
    
    @Published var metar = ""
    @Published var notams = ""
    
    var waypointOffsets: [Int] = []
    @Published var delays: [DelayEntry] = []
    
    @Published var v1: String = ""
    @Published var vr: String = ""
    @Published var v2: String = ""
    @Published var flexTemp: String = ""
}
