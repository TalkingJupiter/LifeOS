//
//  ReminderEngine.swift
//  LifeOS
//
//  Created by Batuhan Sencer on 1/3/26.
//

import Foundation
import UserNotifications

enum ReminderEngine {

    static func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
        } catch {
            return false
        }
    }

    static func reschedulePostureNext24h(rule: ReminderRule) async {
        // For MVP, we schedule only posture module.
        let center = UNUserNotificationCenter.current()

        // Remove existing posture reminders
        await center.removePendingRequests(prefix: PostureModule.notificationPrefix)

        guard rule.isEnabled else { return }

        let now = Date()
        if let paused = pausedUntilDateFromDefaults(), paused > now {
            return
        }

        let calendar = Calendar.current
        let end = calendar.date(byAdding: .hour, value: 24, to: now)!

        var cursor = nextAlignedTime(from: now, startHour: rule.startHour, intervalMins: rule.intervalMinutes)

        var idx = 0
        while cursor < end {
            if isAllowed(date: cursor, rule: rule) && !isPaused(date: cursor) {
                let comps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: cursor)
                let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)

                let req = UNNotificationRequest(
                    identifier: "\(PostureModule.notificationPrefix)\(Int(cursor.timeIntervalSince1970))",
                    content: PostureModule.content(),
                    trigger: trigger
                )

                try? await center.add(req)
                idx += 1
            }
            cursor = calendar.date(byAdding: .minute, value: rule.intervalMinutes, to: cursor)!
        }

        print("[LifeOS] Scheduled \(idx) posture reminders (next 24h)")
    }

    static func scheduleTestPosture(inSeconds seconds: Int = 5) async {
        let content = PostureModule.content()
        content.title = "Posture test"
        content.body = "If you see this, scheduling works ✅"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
        let req = UNNotificationRequest(
            identifier: "\(PostureModule.notificationPrefix)test-\(Int(Date().timeIntervalSince1970))",
            content: content,
            trigger: trigger
        )
        try? await UNUserNotificationCenter.current().add(req)
    }

    static func scheduleSnooze(modulePrefix: String, content: UNMutableNotificationContent, minutes: Int) async {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(minutes * 60), repeats: false)
        let req = UNNotificationRequest(
            identifier: "\(modulePrefix)snooze-\(Int(Date().timeIntervalSince1970))",
            content: content,
            trigger: trigger
        )
        try? await UNUserNotificationCenter.current().add(req)
    }

    // MARK: - Helpers

    private static func isAllowed(date: Date, rule: ReminderRule) -> Bool {
        let cal = Calendar.current
        let hour = cal.component(.hour, from: date)
        guard hour >= rule.startHour && hour < rule.endHour else { return false }

        if rule.weekdaysOnly {
            let weekday = cal.component(.weekday, from: date) // 1=Sun...7=Sat
            if weekday == 1 || weekday == 7 { return false }
        }

        return true
    }

    private static func nextAlignedTime(from now: Date, startHour: Int, intervalMins: Int) -> Date {
        let cal = Calendar.current

        var comps = cal.dateComponents([.year, .month, .day], from: now)
        comps.hour = startHour
        comps.minute = 0
        let startToday = cal.date(from: comps)!

        if now < startToday { return startToday }

        let minutesSinceStart = Int(now.timeIntervalSince(startToday) / 60)
        let nextMultiple = ((minutesSinceStart / intervalMins) + 1) * intervalMins
        return cal.date(byAdding: .minute, value: nextMultiple, to: startToday)!
    }

    private static func pausedUntilDateFromDefaults() -> Date? {
        let key = "lifeos_posture_paused_until"
        let t = UserDefaults.standard.double(forKey: key)
        if t <= 0 { return nil }
        return Date(timeIntervalSince1970: t)
    }

    private static func isPaused(date: Date) -> Bool {
        guard let pausedUntil = pausedUntilDateFromDefaults() else { return false }
        return date < pausedUntil
    }
}
