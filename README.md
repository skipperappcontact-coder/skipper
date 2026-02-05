
# Skipper

Skipper is a Flutter-based marine transportation platform designed to enable
on-demand and scheduled boat trips (passenger and delivery), similar in spirit
to Uber — but built specifically for water-based transport.

This repository contains the **full Skipper Flutter application codebase**
(Android + iOS) and supporting assets.

---

## Current Status

This is an **early but complete foundation** of the Skipper app.

### What exists today
- Flutter app scaffold (Android / iOS / desktop targets)
- Core project structure and navigation
- Passenger trip flow (request → active → completion)
- Delivery trip type (basic flow)
- Scheduling logic (implemented for scheduled trips)
- Firebase / Google Services configuration
- Asset pipeline and branding placeholders

### What is NOT finished yet
- Route polylines / map path drawing
- ETA calculation
- Pricing engine
- Captain matching optimization
- Delivery trip scheduling hook (planned)

See **ROADMAP.md** for planned features and next steps.

---

## Tech Stack

- **Flutter / Dart**
- Android (Gradle)
- iOS (Xcode)
- Firebase / Google Services
- Google Maps (planned expansion)

---

## Project Structure

```text
skipper/
├── lib/ # Flutter application code
├── assets/ # Images and static assets
├── android/ # Android native project
├── ios/ # iOS native project
├── test/ # Flutter tests
├── README.md # Project overview (this file)
├── ROADMAP.md # Planned features & next steps
├── DEV_NOTES.md # Architecture notes & intent
├── pubspec.yaml # Flutter dependencies


Getting Started

Prerequisites

Flutter SDK (stable)
Android Studio or VS Code
Android Emulator or physical device
Xcode (for iOS builds)

Install dependencies
flutter pub get

Run the app
flutter run


Key Concepts (High Level)
Trip Types
	Passenger trips (on-demand & scheduled)
	Delivery trips (on-demand; scheduling planned)
Scheduling
	Scheduled trips have a reusable scheduling hook
	Delivery trips will reuse this hook (see ROADMAP)
Maps & Routing
	Marine routing will differ from road routing
	Polylines and ETA logic will be marine-aware

Roadmap
All upcoming work is tracked in ROADMAP.md, including:
	Polyline route drawing
	ETA calculation
	Pricing logic
	Delivery trip scheduling
	Captain matching improvements
Devs should treat ROADMAP.md as the source of truth for next tasks.


Contributing
This repo is actively evolving.
Please:
Follow existing architecture patterns
Update ROADMAP.md when adding major features
Keep commits scoped and descriptive

Ownership
This project is owned by Skipper.
Brand assets, business logic, and roadmap direction are centrally managed.

Questions / Context
If something is unclear in the code, check:
ROADMAP.md
DEV_NOTES.md
Then ask — architectural intent matters here.
