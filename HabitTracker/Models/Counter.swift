//
//  Counter.swift
//  HabitTracker
//

import Foundation
import SwiftData

@Model
final class Counter {
    var name: String
    var startDate: Date
    var longestRecord: Int = 0

    init(name: String, startDate: Date = .now, longestRecord: Int = 0) {
        self.name = name
        self.startDate = startDate
        self.longestRecord = longestRecord
    }
}

extension Counter {
    var elapsedDays: Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: startDate)
        let today = calendar.startOfDay(for: .now)
        return calendar.dateComponents([.day], from: start, to: today).day ?? 0
    }

    var displayedLongestRecord: Int {
        max(longestRecord, elapsedDays)
    }
}
