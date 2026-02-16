//
//  TimeUtils.swift
//  EFB
//
//  Created by Yuk Jun Lim on 19/1/26.
//

import Foundation

func addSecondsToUTC(_ utcTime: String, seconds: Int) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HHmm"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)

    guard
        let date = formatter.date(from: utcTime),
        let newDate = Calendar.current.date(byAdding: .second, value: seconds, to: date)
    else {
        return ""
    }

    return formatter.string(from: newDate)
}
