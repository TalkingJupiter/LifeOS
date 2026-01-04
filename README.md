# LifeOS

**LifeOS** is an open-source iOS app that acts like a lightweight personal operating system for health micro-habits.

Instead of focusing on a single feature, LifeOS provides a modular foundation for small, high-impact reminders — starting with posture resets — and is designed to grow into a calm, extensible wellness toolkit.

The goal is not gamification or constant engagement, but quiet, system-level support for better daily habits.

---

## Philosophy

LifeOS is built around a few core ideas:

- **Micro-habits over motivation**  
  Small, frequent nudges outperform willpower.
- **System behavior, not noise**  
  LifeOS runs mostly in the background via local notifications.
- **Modular by design**  
  Each habit is a self-contained module that plugs into a shared engine.
- **Offline and private**  
  No accounts, no servers, no data leaving your device.
- **Optional intelligence**  
  Apple Watch support can enhance accuracy, but the app works without it.

---

## Current Features (MVP)

### Posture Module
- Configurable posture reminders
- Active time window (start/end hours)
- Adjustable reminder interval
- Weekday-only option
- Notification actions:
  - **Done**
  - **Snooze (15 min)**
  - **Pause (1 hour)**
- Daily posture reset count
- Fully local notifications (no backend)

---

## Planned Modules

LifeOS is designed as a “Swiss-army knife” for health habits. Planned modules include:

- Hydration reminders
- Eye-strain breaks (20-20-20 rule)
- Breathing resets
- Mobility and stretch prompts
- Short walk / movement nudges

Each module shares the same core engine while remaining logically independent.

---

## Architecture Overview

LifeOS is intentionally structured like a platform:
```
LifeOS/
|
|-> App/ -> App lifecycle & notification delegate
|-> Core/ -> Shared models and services
|-> Modules/ -> Individual habit modules (Posture, Hydration, etc.)
|-> UI/ -> SwiftUI screens and components
|->Utils/ -> Small helpers and extensions
```
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

---

## Contributing

LifeOS is open to contributions, especially:

- New habit modules
- Apple Watch integration
- UI/UX refinements
- Scheduling intelligence improvements

The architecture is designed so modules can be added without touching core logic.

Contribution guidelines will be added soon.

---

## License

MIT License
© 2026 Batuhan Sencer
