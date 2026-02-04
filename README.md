\# Skipper ⚓

Skipper is a Flutter-based on-water transportation platform
designed to evolve into an Uber-like service for boats.

---

## Current State (What Exists)

- Flutter app scaffold (Android / iOS)
- Passenger flow foundations
- Trip types:
  - On-demand
  - Scheduled
  - Delivery (⚠️ schedule hook still needed)
- Firebase configuration present
- Maps integration in progress

This repository represents the **initial full Skipper Flutter codebase**.

---

## Near-Term Development Priorities (IMPORTANT)

These items are intentionally listed to guide contributors.

### 1. Routing & Polylines
- Draw live polylines for active trips
- Support captain → passenger → destination routing
- Optimize for marine routes (not road assumptions)

### 2. ETA Calculation
- Compute ETA from polyline distance
- Update ETA in real time as captain moves
- Display ETA ring / progress indicator in UI

### 3. Pricing Engine
- Distance-based pricing (nautical miles)
- Time-based modifiers
- Surge / demand multipliers (future)
- Delivery vs passenger pricing separation

### 4. Scheduling Logic
- Scheduled trips already support time hooks
- ❗ Delivery trip type must add **same scheduling hook**
- Background job to activate scheduled trips

### 5. Captain Assignment Logic
- Radius-based captain matching
- Availability + vessel type filtering
- Distance badge display

---

## Tech Stack

- Flutter (Dart)
- Firebase
- Google Maps / Mapbox (TBD)
- GitHub for version control

---

## How to Run

```bash
flutter pub get
flutter run



Skipper is an on-demand and scheduled marine transportation platform designed for

water-based commuting, leisure travel, and delivery services.



The app connects passengers with licensed captains operating vessels in coastal,

harbor, and island environments — enabling a water-native alternative to road-based

rideshare.



> ⚓ This README is the canonical, living documentation for Skipper.

> All product, architecture, and workflow changes must be reflected here.



Last updated: 2026-02-XX



---



\## 🌊 Core Concepts



Skipper is built around \*\*real marine constraints\*\*, not repurposed car logic.



Key principles:

\- Water-based routing and timing

\- Captain-first operational controls

\- Scheduled trips as a first-class feature

\- Passenger clarity via ETA, pricing, and trip status



---



\## 🚤 Trip Types



Skipper currently supports four trip types:



\### 1. Ride (Immediate)

\- On-demand pickup

\- Live ETA once captain is assigned

\- Standard pricing model



\### 2. Scheduled

\- Passenger selects pickup date \& time

\- No live ETA until captain dispatch window

\- Used for commuting, airport runs, events



\### 3. Delivery

\- \*\*Scheduled-only\*\*

\- Same scheduling flow as Scheduled Ride

\- Pricing adjusted for cargo handling



\### 4. Leisure

\- Flexible timing

\- Premium pricing multiplier

\- Used for tours and charters



⚠️ \*\*Trip type is locked once a request is made.\*\*



---



\## 🗺️ Map \& Location Flow



Passenger flow:

1\. Tap map to set \*\*pickup\*\*

2\. Tap map to set \*\*dropoff\*\*

3\. Select trip type

4\. (If Scheduled/Delivery) select pickup time

5\. Select captain

6\. Request trip



Marker rules:

\- Pickup \& dropoff markers persist through trip

\- All online captains visible before request

\- Only selected captain visible after request



---



\## ⏱ ETA System



\- ETA calculated using haversine distance

\- Countdown updates every minute

\- ETA hidden once captain arrives

\- “Captain arriving now” state when ≤1 min



---



\## 💰 Pricing (Current Logic)



Pricing is distance-based with modifiers:

\- Base fare + per-km rate

\- Scheduled surcharge

\- Leisure \& delivery multipliers



Pricing recalculates on:

\- Pickup/dropoff selection

\- Trip type change (before request)



---



\## 🧑‍✈️ Captain App Flow



Captain Home is intentionally minimal:

\- No passenger controls

\- No pricing controls

\- No profile editing



Captain lifecycle:

1\. Waiting

2\. Accept trip

3\. Arrived at pickup

4\. Start trip

5\. Complete trip



Captain availability (online/offline) is handled separately.



---



\## 🏗️ Architecture Overview



\- Flutter (single codebase)

\- Google Maps SDK

\- Centralized AppState using ValueNotifiers

\- No backend dependency yet (mock captains)



Key files:

lib/ ├── state/ │ └── app\_state.dart ├── screens/ │ ├── passenger\_home.dart │ └── captain\_home.dart

Copy code



---



\## 🔒 Documentation Rules



\- This README is the source of truth

\- Feature changes require README updates

\- Deprecated behavior must be documented

\- Experimental features must be labeled



---



\## 🚧 Roadmap (High Level)



Near-term:

\- Backend dispatch service

\- Real AIS / water routing

\- Payments \& payouts

\- Captain onboarding



Long-term:

\- Multi-city expansion

\- Franchise operations

\- Enterprise marina partnerships



---



\## 📄 License



Private / Pre-launch

