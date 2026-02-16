//
//  WaypointLog.swift
//  EFB
//
//  Created by Yuk Jun Lim on 18/1/26.
//
import Foundation

struct WaypointLog: Identifiable {
    let id = UUID()

    let name: String

    // Planned (immutable)
    let plannedUTC: String
    let plannedFOB: String

    // Actual (MUST be var for bindings)
    var actualUTC: String
    var actualFOB: String
}
