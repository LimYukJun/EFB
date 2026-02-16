//
//  DelayCode.swift
//  EFB
//
//  Created by Yuk Jun Lim on 18/1/26.
//
import Foundation

struct DelayCode: Identifiable {
    let id = UUID()
    let code: String
    let description: String
}

struct DelayEntry: Identifiable {
    let id = UUID()
    let code: String
    let minutes: Int
    let remarks: String
}
