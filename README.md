
Key architectural ideas:
- **ReminderEngine** handles scheduling and notification lifecycle
- **NotificationRouter** routes actions back to the correct module
- **Modules** define content and behavior, not scheduling logic
- **Views** remain reactive and lightweight

---

## Apple Watch Support (Planned)

Apple Watch integration is optional and additive:
- Mirror reminders to the watch
- Mark reminders as “Done” from the watch
- Use motion/activity context to suppress reminders when moving

LifeOS always functions without a watch; the watch simply improves context.

---

## Tech Stack

- Swift
- SwiftUI
- UserNotifications
- Combine / async-await
- Local storage (UserDefaults for MVP)

No backend. No analytics. No tracking.

---

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/LifeOS.git
   ```
2. Open LifeOS.xcodeproj in Xcode
3. Select an iPhone device (notifications work best on real hardware)
4. Build and run
5. Grant notification permission when prompted

--

## Contributing

LifeOS is open to contributions, especially:

- New habit modules
- Apple Watch integration
- UI/UX refinements
- Scheduling intelligence improvements

The architecture is designed so modules can be added without touching core logic.

Contribution guidelines will be added soon.

--

## License

MIT License
© 2026 Batuhan Sencer
