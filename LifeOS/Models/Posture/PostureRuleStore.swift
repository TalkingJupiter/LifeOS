//
//  PostureRuleStore.swift
//  LifeOS
//
//  Created by Batuhan Sencer on 1/3/26.
//

import Foundation
import Combine

final class PostureRuleStore: ObservableObject {
    @Published var rule: ReminderRule {
        didSet { save() }
    }

    private let key = "lifeos_posture_rule"

    init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode(ReminderRule.self, from: data) {
            self.rule = decoded
        } else {
            self.rule = ReminderRule()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(rule) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
