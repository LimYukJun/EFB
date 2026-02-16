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
    
    @Published var paxCountActual = ""
    @Published var payload = ""
    @Published var cargo = ""
    @Published var estZfw = ""
    @Published var maxZfw = ""
    @Published var estTow = ""
    @Published var maxTow = ""
    @Published var estLdw = ""
    @Published var maxLdw = ""
    @Published var estRamp = ""

    @Published var estTimeEnroute = ""
    @Published var schedTimeEnroute = ""
    @Published var schedBlock = ""
    @Published var estBlock = ""
    @Published var taxiOut = ""
    @Published var taxiIn = ""
    @Published var reserveTime = ""
    @Published var endurance = ""
    @Published var contfuelTime = ""
    @Published var etopsfuelTime = ""
    @Published var extrafuelTime = ""
    @Published var schedOut = ""
    @Published var schedOff = ""
    @Published var schedOn = ""
    @Published var schedIn = ""
    @Published var estOut = ""
    @Published var estOff = ""
    @Published var estOn = ""
    @Published var estIn = ""
    @Published var actualOut: String = ""
    @Published var actualOff: String = ""
    @Published var actualOn: String = ""
    @Published var actualIn: String = ""
    

    
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
    
    var blockTime: String {
        guard actualOut.count == 4,
              actualIn.count == 4,
              let outHour = Int(actualOut.prefix(2)),
              let outMin = Int(actualOut.suffix(2)),
              let inHour = Int(actualIn.prefix(2)),
              let inMin = Int(actualIn.suffix(2)) else {
            return ""
        }

        let outTotal = outHour * 60 + outMin
        var inTotal = inHour * 60 + inMin

        // Handle midnight crossing
        if inTotal < outTotal {
            inTotal += 24 * 60
        }

        let diff = inTotal - outTotal
        let hours = diff / 60
        let minutes = diff % 60

        return "\(hours) h \(minutes) min"
    }


}

extension FlightContext {

    func secondsToMinutes(_ seconds: String?) -> String {
        guard let sec = Double(seconds ?? "") else { return "" }

        let totalMinutes = Int((sec / 60.0).rounded())
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        if hours > 0 {
            return "\(hours) h \(minutes) min"
        } else {
            return "\(minutes) min"
        }
    }


    func epochToTime(_ epoch: String?) -> String {
        guard let sec = Double(epoch ?? "") else { return "" }
        let date = Date(timeIntervalSince1970: sec)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "UTC") // Use UTC instead of local
        return formatter.string(from: date)
    }


}
