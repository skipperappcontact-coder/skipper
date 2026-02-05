# Skipper Roadmap

This document outlines the planned technical evolution of the Skipper platform.
Items are ordered roughly by dependency and impact.

This roadmap is **authoritative** — new major features should be added here
before implementation.

---

## Phase 1 — Core Trip Intelligence (FOUNDATION)

### 1. Marine Route Polylines
**Status:** Not started

**Goal:**  
Render accurate marine routes on the map for active and scheduled trips.

**Tasks:**
- Implement polyline drawing between origin and destination
- Support curved / multi-point marine paths (not road-based routing)
- Allow manual waypoint insertion for captains (future)
- Cache polylines per trip session

**Notes:**
- Google Maps polylines will be the initial implementation
- Must not assume road constraints
- Routing service abstraction recommended

---

### 2. ETA Calculation Engine
**Status:** Not started

**Goal:**  
Provide real-time ETA estimates that update during trips.

**Tasks:**
- Compute ETA from polyline length + vessel speed assumptions
- Adjust ETA dynamically as trip progresses
- Support scheduled-trip pre-calculation
- Prepare hooks for weather / tide modifiers (future)

**Notes:**
- Keep ETA logic decoupled from UI
- Vessel class may affect ETA in later phases

---

### 3. Pricing Engine (v1)
**Status:** Not started

**Goal:**  
Introduce a predictable, extensible pricing model.

**Tasks:**
- Base fare + distance-based pricing
- Time-based modifiers (duration, idle time)
- Scheduled trip pricing rules
- Delivery vs passenger pricing differentiation
- Pricing breakdown object for UI display

**Notes:**
- No surge pricing in v1
- Pricing logic must be testable in isolation

---

## Phase 2 — Scheduling & Trip Types

### 4. Delivery Trip Scheduling Hook
**Status:** Planned

**Goal:**  
Extend existing scheduling infrastructure to delivery trips.

**Tasks:**
- Reuse scheduling logic from passenger scheduled trips
- Add delivery-specific constraints (pickup window, drop window)
- Ensure backward compatibility with on-demand delivery

**Notes:**
- Avoid duplicating scheduling logic
- Treat scheduling as a reusable service

---

### 5. Unified Trip State Machine
**Status:** Partial

**Goal:**  
Normalize how trip states are handled across all trip types.

**Tasks:**
- Define canonical trip states (requested, accepted, en route, completed, etc.)
- Ensure passenger and delivery trips share state logic
- Remove hardcoded state transitions where possible

---

## Phase 3 — Captain & Fleet Intelligence

### 6. Captain Matching (v1)
**Status:** Not started

**Goal:**  
Assign trips to captains efficiently.

**Tasks:**
- Proximity-based matching
- Availability windows
- Vessel capability filtering
- Manual override hooks (ops)

**Notes:**
- Optimization can come later
- Prioritize correctness over efficiency initially

---

### 7. Vessel Profiles
**Status:** Planned

**Goal:**  
Introduce vessel-aware routing and pricing.

**Tasks:**
- Vessel speed profiles
- Capacity constraints
- Vessel class pricing modifiers

---

## Phase 4 — UX & Reliability

### 8. Trip Recovery & Edge Cases
**Status:** Planned

**Tasks:**
- App restart during active trip
- Network interruption handling
- Resume trip state from backend

---

### 9. Analytics & Telemetry
**Status:** Planned

**Tasks:**
- Trip duration tracking
- Pricing breakdown analytics
- Drop-off / cancellation insights

---

## Phase 5 — Scale Readiness

### 10. Architecture Hardening
**Status:** Future

**Tasks:**
- Service abstraction cleanup
- Dependency injection review
- Performance profiling

---

### 11. Ops & Admin Hooks
**Status:** Future

**Tasks:**
- Manual trip intervention
- Pricing overrides
- Captain support tools

---

## Guiding Principles

- Marine-first logic (not road-first)
- Shared abstractions over copy-paste
- All business logic testable without UI
- Roadmap changes require documentation updates

---

## Ownership

This roadmap reflects the intended long-term direction of Skipper.
Major deviations should be discussed before implementation.
