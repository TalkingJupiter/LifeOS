//
//  NotificationRouter.swift
//  LifeOS
//
//  Created by Batuhan Sencer on 1/3/26.
//

import Foundation
import UserNotifications

enum NotificationRouter {

    static func registerCategories() {
        // Actions
        let done   = UNNotificationAction(identifier: "DONE", title: "Done", options: [])
        let snooze = UNNotificationAction(identifier: "SNOOZE_15", title: "Snooze 15m", options: [])
        let pause  = UNNotificationAction(identifier: "PAUSE_60", title: "Pause 1h", options: [])

        // Categories (module-specific; more modules later)
        let postureCategory = UNNotificationCategory(
            identifier: PostureModule.notificationCategoryId,
            actions: [done, snooze, pause],
            intentIdentifiers: [],
            options: []
        )

        UNUserNotificationCenter.current().setNotificationCategories([postureCategory])
    }

    static func handle(response: UNNotificationResponse) async {
        let id = response.notification.request.identifier

        // For MVP, route only Posture by prefix.
        if id.hasPrefix(PostureModule.notificationPrefix) || response.notification.request.content.categoryIdentifier == PostureModule.notificationCategoryId {
            await handlePosture(response: response)
        }
    }

    private static func handlePosture(response: UNNotificationResponse) async {
        switch response.actionIdentifier {
        case "DONE":
            // MVP: just print / later log to LogStore
            LogStore.shared.logDone(module: .posture)

        case "SNOOZE_15":
            await ReminderEngine.scheduleSnooze(
                modulePrefix: PostureModule.notificationPrefix,
                content: PostureModule.content(),
                minutes: 15
            )

        case "PAUSE_60":
            // Store pause time in UserDefaults for now
            let until = Date().addingTimeInterval(60 * 60).timeIntervalSince1970
            UserDefaults.standard.set(until, forKey: "lifeos_posture_paused_until")
            await UNUserNotificationCenter.current().removePendingRequests(prefix: PostureModule.notificationPrefix)

        default:
            break
        }
    }
}
