//
//  NotificationManager.swift
//  HabitTracker
//

import Foundation
import UserNotifications

@MainActor
final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    private let center = UNUserNotificationCenter.current()

    private override init() {
        super.init()
    }

    func requestAuthorization() async -> Bool {
        (try? await center.requestAuthorization(options: [.alert, .sound, .badge])) ?? false
    }

    func authorizationStatus() async -> UNAuthorizationStatus {
        await center.notificationSettings().authorizationStatus
    }

    func schedule(for habit: Habit) {
        center.removePendingNotificationRequests(withIdentifiers: [habit.notificationID])

        guard let reminderTime = habit.reminderTime else { return }

        let content = UNMutableNotificationContent()
        content.title = "習慣リマインド"
        content.body = habit.name
        content.sound = .default

        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: habit.notificationID, content: content, trigger: trigger)
        center.add(request)
    }

    func cancel(for habit: Habit) {
        center.removePendingNotificationRequests(withIdentifiers: [habit.notificationID])
    }

    func rescheduleAll(habits: [Habit]) {
        for habit in habits where habit.reminderTime != nil {
            schedule(for: habit)
        }
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
