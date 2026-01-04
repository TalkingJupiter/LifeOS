//
//  PostureModule.swift
//  LifeOS
//
//  Created by Batuhan Sencer on 1/3/26.
//

import Foundation
import UserNotifications

enum PostureModule {
    static let id: ModuleID = .posture

    static let notificationCategoryId = "LIFEOS_POSTURE_REMINDER"
    static let notificationPrefix = "lifeos-posture-"

    static func content() -> UNMutableNotificationContent {
        let c = UNMutableNotificationContent()
        c.title = "Posture reset"
        c.body  = "Feet flat • ribs over hips • shoulders down • chin tucked (10s)"
        c.sound = .default
        c.categoryIdentifier = notificationCategoryId
        return c
    }
}
