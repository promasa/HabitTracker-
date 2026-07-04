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
    var reminderTime: Date?
    var notificationID: String = UUID().uuidString

    init(
        name: String,
        createdAt: Date = .now,
        completedDates: [Date] = [],
        reminderTime: Date? = nil,
        notificationID: String = UUID().uuidString
    ) {
        self.name = name
        self.createdAt = createdAt
        self.completedDates = completedDates
        self.reminderTime = reminderTime
        self.notificationID = notificationID
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

    var longestStreak: Int {
        let calendar = Calendar.current
        let sortedDays = Set(completedDates.map { calendar.startOfDay(for: $0) }).sorted()
        guard !sortedDays.isEmpty else { return 0 }

        var longest = 1
        var current = 1
        for index in 1..<sortedDays.count {
            let daysBetween = calendar.dateComponents([.day], from: sortedDays[index - 1], to: sortedDays[index]).day ?? 0
            current = daysBetween == 1 ? current + 1 : 1
            longest = max(longest, current)
        }
        return longest
    }

    var totalCompletedDays: Int {
        Set(completedDates.map { Calendar.current.startOfDay(for: $0) }).count
    }
}
