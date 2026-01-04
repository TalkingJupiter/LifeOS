//
//  UNUserNotificationCenter+Helpers.swift
//  LifeOS
//
//  Created by Batuhan Sencer on 1/3/26.
//

import UserNotifications

extension UNUserNotificationCenter {
    func removePendingRequests(prefix: String) async {
        let reqs = await pendingNotificationRequests()
        let ids = reqs.map(\.identifier).filter { $0.hasPrefix(prefix) }
        removePendingNotificationRequests(withIdentifiers: ids)
    }
}
