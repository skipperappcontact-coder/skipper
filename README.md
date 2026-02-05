# Skipper

**Skipper** is a marine-first transportation platform designed for short-distance water travel,
commuting, scheduled rides, leisure trips, and marine delivery.

Unlike road-based rideshare apps, Skipper is built around **predictability, trust, and safety on water**.

This repository contains the **core Skipper mobile application**, built with Flutter.

---

## Project Status

**Current state:**  
🟢 Core trip flow implemented  
🟢 Passenger + Captain flows operational  
🟢 Map-based pickup/dropoff selection  
🟢 Trip types (Ride, Scheduled, Leisure, Delivery)  
🟢 ETA calculation & countdown  
🟢 Captain card flow  
🟢 Scheduling hook for Scheduled & Delivery trips

**Not yet production-ready** (by design):
- Payments
- Live routing (marine-aware polylines)
- Regulatory compliance
- Production Google Places search
- Real-time captain telemetry

This repo is a **functional foundation**, not a finished consumer app.

---

## Core Design Philosophy

Skipper is intentionally **state-driven**.

All user confidence comes from:
- Stable trip flow
- Locked decisions once a trip is requested
- No silent resets
- No UI-driven logic

📖 **Read `DEV_NOTES.md` before contributing.**  
It explains the rules this app must follow.

---

## Trip Lifecycle

Trip state always follows this order:
idle → requested → accepted → arrived → inProgress → completed → reset

Nothing skips steps.  
Nothing mutates state out of order.

If a feature breaks this flow, it is incorrect.

---

## Trip Types

Skipper supports four trip types:

- **Ride** – Immediate, on-demand transport
- **Scheduled** – Future pickup time required
- **Leisure** – Premium / non-commute travel
- **Delivery** – Scheduled cargo or item transport

### Rules
- Trip type may only be changed while `TripStatus == idle`
- Scheduled & Delivery trips require a pickup time
- Trip type is locked once a trip is requested

---

## Map Interaction

The map is the primary interface.

Passenger actions:
1. Tap map to set pickup
2. Tap map to set dropoff
3. Select trip type
4. Select captain
5. Request trip

Pickup & dropoff:
- Persist through the entire trip
- Lock once a trip is requested
- Only reset via explicit reset

---

## ETA Behavior

- ETA is calculated when a captain is selected or accepts
- ETA counts down visually
- ETA stops when captain arrives
- ETA does not reappear during in-progress trips

ETA is **informational**, not a guarantee.

---

## Captain Experience

Captain Home is intentionally minimal.

Captain actions:
- Accept trip
- Arrive at pickup
- Start trip
- Complete trip

No extra controls unless required for safety or compliance.

---

## Tech Stack

- **Flutter** (mobile)
- **Google Maps SDK**
- **ValueNotifier-based state management**
- No backend dependencies yet (mock data only)

---

## Repository Structure
lib/ ├── models/ │ └── captain.dart ├── screens/ │ ├── passenger_home.dart │ └── captain_home.dart ├── state/ │ ├── app_state.dart │ └── mock_captains.dart assets/ android/ ios/

## Running Locally

```bash
flutter pub get
flutter run

Android emulator or physical device required.

Contribution Guidelines

Before submitting changes:
1.Read DEV_NOTES.md
2.Confirm trip flow is not broken
3.Confirm no state resets occur silently
4.Confirm trip type locks correctly
5.Test cancel + reset paths
This project favors clarity over cleverness.

Roadmap (High-Level)

See ROADMAP.md for detailed next steps, including:
Marine-aware routing
Pricing engine
Payment flow
Captain onboarding
Compliance & safety features


License
Private / Proprietary
All rights reserved.
