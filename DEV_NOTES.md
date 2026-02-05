# Skipper – Developer Notes & Design Philosophy

This document explains the *why* behind Skipper’s architecture, UI behavior, and state management.
If you are contributing code, **read this first**.

Skipper is not a generic rideshare clone. It is a **marine-first transportation platform** with
different constraints, safety considerations, and user expectations.

---

## Core Principles

### 1. State Is the Product
Skipper is state-driven by design.

Passenger confidence depends on:
- Predictable trip flow
- No UI resets
- No disappearing data
- No surprise state changes

**Rule:**  
If something changes visually, it must be backed by `AppState`.

No local widget state should override global trip truth.

---

### 2. Trip Flow Is Sacred
Trip flow must always follow this sequence:idle → requested → accepted → arrived → inProgress → completed → reset

Nothing skips steps.  
Nothing resets early.  
Nothing mutates state out of order.

If a feature interferes with this flow, the feature is wrong — not the flow.

---

### 3. Passenger Confidence > Feature Density
Skipper optimizes for **trust**, not novelty.

Design goals:
- Calm UI
- Minimal animation
- Clear status messaging
- No sudden layout changes

If a feature adds uncertainty or flicker, it should be removed or deferred.

---

### 4. Map Is the Primary Interface
The map is not decorative — it is the main control surface.

Map responsibilities:
- Pickup & dropoff selection
- Captain visibility
- Route awareness
- ETA understanding

**Rule:**  
The map should never become “busy” or misleading.

---

### 5. Pickup & Dropoff Are Immutable Once Requested
Once a trip is requested:
- Pickup location is locked
- Dropoff location is locked
- Trip type is locked

Only a **full reset** can change them.

This mirrors real-world maritime operations.

---

### 6. Trip Type Is a Contract
Trip type (Ride / Scheduled / Leisure / Delivery) affects:
- Pricing
- ETA logic
- Scheduling rules
- Captain expectations

**Rule:**  
Trip type may only be changed in `TripStatus.idle`.

Any attempt to change it later must be ignored.

---

### 7. Scheduled Trips Are First-Class Citizens
Scheduled trips are not “rides with a time attached”.

They:
- May not have live ETA until near execution
- Require time selection before request
- Should feel intentional and reliable

Delivery trips share this requirement.

---

### 8. ETA Is Informational, Not Promissory
ETA is:
- A confidence indicator
- A relative measure
- Not a guarantee

Design intent:
- Show ETA countdown visually
- Stop ETA updates once captain arrives
- Avoid reappearing ETA during in-progress trips

---

### 9. Captain UX Is Purposefully Minimal
Captain Home is intentionally simple.

Captain responsibilities:
- Accept
- Arrive
- Start
- Complete

No extra controls unless required for safety or compliance.

**Rule:**  
If a captain needs to “think”, the UI failed.

---

### 10. No Silent Resets — Ever
Silent resets destroy trust.

Any reset must be:
- Explicit
- User-triggered
- Visually acknowledged

Examples:
- “Done” button
- “Reset” button
- Cancel confirmation

---

## Architecture Expectations

### AppState
- Single source of truth
- No duplicated state
- No widget-owned trip logic
- All transitions must be explicit

### Widgets
- Purely reactive
- Stateless where possible
- Must respect locks from AppState

### Animations
- Purpose-driven only
- No cosmetic motion
- No infinite loops
- No UI jitter

---

## What Not to Do

❌ Do not auto-reset state on navigation  
❌ Do not infer state from UI visibility  
❌ Do not add hidden timers  
❌ Do not add “temporary” fixes  
❌ Do not override AppState locally

---

## How to Add Features Safely

1. Write the state transition first
2. Confirm it does not break trip flow
3. Lock behavior after request
4. Test cancel + reset paths
5. Only then add UI

If a feature cannot meet these rules, it does not ship.

---
### Future: Visual & Maritime Signaling (Non-Blocking)

Skipper may eventually support visual identification protocols common to marine operations,
including flag or pennant signaling for vessel identification at pickup zones.

This is an operational consideration only and is **not part of the current application scope**.
No UI, logic, or enforcement should be implemented without explicit roadmap approval.

------
## Final Note

Skipper is building **trust on water**.

Users are more vulnerable than in road rideshare.
Every design decision must reduce anxiety, not add cleverness.

When in doubt:
- Choose clarity
- Choose predictability
- Choose boring

That is how Skipper wins.
