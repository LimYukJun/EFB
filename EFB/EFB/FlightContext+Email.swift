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

        // MARK: - Actual Times  ✅ ADDED
        text += "ACTUAL TIMES (UTC)\n"
        text += "Out: \(actualOut)\n"
        text += "Off: \(actualOff)\n"
        text += "On: \(actualOn)\n"
        text += "In: \(actualIn)\n"
        text += "Block Time: \(blockTime)\n\n"

        // MARK: - Performance
        text += "PERFORMANCE\n"
        text += "Planned Fuel: \(plannedFuel)\n"
        text += "\n"

        text += "LOAD\n"
        text += "PAX: \(paxCountActual)\n"
        text += "Cargo: \(cargo)\n"
        text += "Payload: \(payload)\n"
        text += "\n"

        text += "WEIGHTS\n"
        text += "Est ZFW: \(estZfw)\n"
        text += "Max ZFW: \(maxZfw)\n"
        text += "Est TOW: \(estTow)\n"
        text += "Max TOW: \(maxTow)\n"
        text += "Est LDW: \(estLdw)\n"
        text += "Max LDW: \(maxLdw)\n"
        text += "Est Ramp: \(estRamp)\n\n"

        // MARK: - Takeoff Performance
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
