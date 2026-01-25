//
//  FlightContext+Email.swift
//  EFB
//
//  Created by Yuk Jun Lim on 19/1/26.
//

import Foundation
extension FlightContext {

    func buildEmailBody() -> String {

        var text = ""

        // MARK: - Flight
        text += "FLIGHT\n"
        text += "Airline: \(airline)\n"
        text += "Flight Number: \(flightNumber)\n"
        text += "Departure: \(departure)\n"
        text += "Arrival: \(arrival)\n"
        text += "Step Alts: \(stepclimb_string)\n"
        text += "Route: \(route)\n\n"

        // MARK: - Performance
        text += "PERFORMANCE\n"
        text += "Planned Fuel: \(plannedFuel)\n"
        text += "Takeoff Weight: \(takeoffWeight)\n"
        text += "Landing Weight: \(landingWeight)\n\n"

        // MARK: - Takeoff Performance  ✅ NEW
        text += "TAKEOFF PERFORMANCE\n"
        text += "V1: \(v1)\n"
        text += "VR: \(vr)\n"
        text += "V2: \(v2)\n"
        text += "FLEX: \(flexTemp)\n\n"

        // MARK: - Waypoints
        text += "WAYPOINTS\n"
        for wp in waypoints {
            text += "\(wp.name) | "
            text += "PLN UTC \(wp.plannedUTC) | "
            text += "PLN FOB \(wp.plannedFOB) | "
            text += "ACT UTC \(wp.actualUTC) | "
            text += "ACT FOB \(wp.actualFOB)\n"
        }
        text += "\n"

        // MARK: - Delays
        if !delays.isEmpty {
            text += "DELAYS\n"
            for d in delays {
                text += "Code \(d.code) – \(d.minutes) min"
                if !d.remarks.isEmpty {
                    text += " (\(d.remarks))"
                }
                text += "\n"
            }
        }

        return text
    }

}
