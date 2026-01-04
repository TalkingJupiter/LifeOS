//
//  RemainderRule.swift
//  LifeOS
//
//  Created by Batuhan Sencer on 1/3/26.
//

struct ReminderRule: Codable, Equatable {
    var isEnabled: Bool = false
    var startHour: Int = 9
    var endHour: Int = 18
    var intervalMinutes: Int = 45
    var weekdaysOnly: Bool = true
    var pausedUntilEpoch: Double? = nil
}

