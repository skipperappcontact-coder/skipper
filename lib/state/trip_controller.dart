import 'package:flutter/foundation.dart';

/// Canonical trip lifecycle (single source of truth)
enum TripStatus {
  idle,
  requested,
  accepted,
  arrived,
  inProgress,
  completed,
  cancelled,
}

/// Central trip controller (Uber-style)
class TripController {
  /// Current trip state
  static final ValueNotifier<TripStatus> status =
  ValueNotifier<TripStatus>(TripStatus.idle);

  /// Whether a captain is online
  static final ValueNotifier<bool> captainOnline =
  ValueNotifier<bool>(false);

  /// Reset everything safely
  static void reset() {
    status.value = TripStatus.idle;
  }

  // ─────────────────────────────
  // PASSENGER ACTIONS
  // ─────────────────────────────

  static bool canRequest() => status.value == TripStatus.idle;

  static void requestTrip() {
    if (!canRequest()) return;
    status.value = TripStatus.requested;
  }

  static bool canCancel() =>
      status.value == TripStatus.requested ||
          status.value == TripStatus.accepted;

  static void cancelTrip() {
    if (!canCancel()) return;
    status.value = TripStatus.cancelled;
    reset();
  }

  // ─────────────────────────────
  // CAPTAIN ACTIONS
  // ─────────────────────────────

  static void goOnline() {
    captainOnline.value = true;
  }

  static void goOffline() {
    captainOnline.value = false;
    reset();
  }

  static bool canAccept() =>
      captainOnline.value &&
          status.value == TripStatus.requested;

  static void acceptTrip() {
    if (!canAccept()) return;
    status.value = TripStatus.accepted;
  }

  static bool canArrive() =>
      status.value == TripStatus.accepted;

  static void arriveAtPickup() {
    if (!canArrive()) return;
    status.value = TripStatus.arrived;
  }

  static bool canStart() =>
      status.value == TripStatus.arrived;

  static void startTrip() {
    if (!canStart()) return;
    status.value = TripStatus.inProgress;
  }

  static bool canComplete() =>
      status.value == TripStatus.inProgress;

  static void completeTrip() {
    if (!canComplete()) return;
    status.value = TripStatus.completed;
    reset();
  }
}
