import SwiftUI

struct HomeView: View {
    @StateObject private var store = PostureRuleStore()
    @State private var rescheduleTask: Task<Void, Never>? = nil
    

    var body: some View {
        NavigationView {
            Form {
                Section("Posture Module (MVP)") {
                    Toggle("Enable posture reminders", isOn: $store.rule.isEnabled)

                    Stepper("Start hour: \(store.rule.startHour):00",
                            value: $store.rule.startHour,
                            in: 0...23)

                    Stepper("End hour: \(store.rule.endHour):00",
                            value: $store.rule.endHour,
                            in: 0...23)

                    Stepper("Interval: \(store.rule.intervalMinutes) min",
                            value: $store.rule.intervalMinutes,
                            in: 15...180,
                            step: 5)

                    Toggle("Weekdays only", isOn: $store.rule.weekdaysOnly)
                    
                    Text("Posture resets today: \(LogStore.shared.doneCountToday(module: .posture))")
                        .font(.footnote)
                        .foregroundColor(.secondary)


                    Button("Request Notification Permission") {
                        Task {
                            let ok = await ReminderEngine.requestAuthorization()
                            print("[LifeOS] Permission: \(ok)")
                        }
                    }

                    Button("Test notification (5s)") {
                        Task { await ReminderEngine.scheduleTestPosture(inSeconds: 5) }
                    }

                    Button("Apply / Reschedule next 24h") {
                        Task { await ReminderEngine.reschedulePostureNext24h(rule: store.rule) }
                    }
                }

                Section("LifeOS") {
                    Text("Later: hydration, eye breaks, breathing, mobility…")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("LifeOS")
            .onChange(of: store.rule) {
                // Cancel any in-flight reschedule
                rescheduleTask?.cancel()

                // If disabled, don't schedule anything
                guard store.rule.isEnabled else { return }

                rescheduleTask = Task {
                    // Debounce: wait 500ms
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    if Task.isCancelled { return }
                    await ReminderEngine.reschedulePostureNext24h(rule: store.rule)
                }
            }

        }
    }
}
