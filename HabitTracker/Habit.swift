//
//  Habit.swift
//  HabitTracker
//

import Foundation
import SwiftData

@Model
final class Habit {
    var name: String
    var createdAt: Date
    var completedDates: [Date]

    init(name: String, createdAt: Date = .now, completedDates: [Date] = []) {
        self.name = name
        self.createdAt = createdAt
        self.completedDates = completedDates
    }
}

extension Habit {
    var isCompletedToday: Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        return completedDates.contains { calendar.isDate($0, inSameDayAs: today) }
    }

    func toggleToday() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        if let index = completedDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: today) }) {
            completedDates.remove(at: index)
        } else {
            completedDates.append(today)
        }
    }

    var streak: Int {
        let calendar = Calendar.current
        let completedDays = Set(completedDates.map { calendar.startOfDay(for: $0) })

        var day = calendar.startOfDay(for: .now)
        if !completedDays.contains(day) {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: day) else { return 0 }
            day = yesterday
        }

        var streakCount = 0
        while completedDays.contains(day) {
            streakCount += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = previousDay
        }
        return streakCount
    }
}
