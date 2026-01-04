//
//  LogStore.swift
//  LifeOS
//
//  Created by Batuhan Sencer on 1/3/26.
//

import Foundation

final class LogStore {
    static let shared = LogStore()
    private init() {}

    private let key = "lifeos_logs" // array of dictionaries

    func logDone(module: ModuleID) {
        var logs = UserDefaults.standard.array(forKey: key) as? [[String: Any]] ?? []

        logs.append([
            "module": module.rawValue,
            "timestamp": Date().timeIntervalSince1970
        ])

        UserDefaults.standard.set(logs, forKey: key)
    }

    func doneCountToday(module: ModuleID) -> Int {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let logs = UserDefaults.standard.array(forKey: key) as? [[String: Any]] ?? []

        return logs.filter { entry in
            guard
                let m = entry["module"] as? String,
                let t = entry["timestamp"] as? Double
            else { return false }

            return m == module.rawValue && Date(timeIntervalSince1970: t) >= startOfDay
        }.count
    }
}
