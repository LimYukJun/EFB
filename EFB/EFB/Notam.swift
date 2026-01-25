//
//  Notam.swift
//  EFB
//
//  Created by Yuk Jun Lim on 24/1/26.
//

import Foundation

struct Notam: Identifiable, Hashable {
    let id = UUID()
    let airportICAO: String
    let rawText: String
}
