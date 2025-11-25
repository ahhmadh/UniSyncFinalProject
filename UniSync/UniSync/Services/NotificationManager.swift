//
//  NotificationManager.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//


import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { _,_ in }
    }

    /// Schedules a single notification on a specific date
    func schedule(title: String, body: String, at date: Date) {
        guard date > Date() else { return } // don't schedule in the past
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body

        let comps = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let id = UUID().uuidString

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    /// Schedules reminders 7 days, 3 days, and 1 day before the due date (at 9:00 AM)
    func schedulePreDueReminders(for assignment: Assignment) {
        let due = assignment.dueDate
        let scheduleHour = 9
        let offsets = [14,7, 3, 1] // days before

        for days in offsets {
            if let reminderDate = Calendar.current.date(byAdding: .day, value: -days, to: due) {
                var atNine = Calendar.current.date(bySettingHour: scheduleHour, minute: 0, second: 0, of: reminderDate) ?? reminderDate
                // If 9am already passed for today, still allow future dates only
                if atNine < Date() { continue }
                schedule(
                    title: "Upcoming: \(assignment.title)",
                    body: "Due in \(days) day\(days == 1 ? "" : "s") (\(formatted(due))).",
                    at: atNine
                )
            }
        }
    }

    private func formatted(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df.string(from: date)
    }
}
