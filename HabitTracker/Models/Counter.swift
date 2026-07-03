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

    init(name: String, startDate: Date = .now) {
        self.name = name
        self.startDate = startDate
    }
}

extension Counter {
    var elapsedDays: Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: startDate)
        let today = calendar.startOfDay(for: .now)
        return calendar.dateComponents([.day], from: start, to: today).day ?? 0
    }
}
