import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/captain.dart';

enum TripStatus {
  idle,
  requested,
  accepted,
  arrived,
  inProgress,
  completed,
  cancelled,
}

enum TripType {
  ride,
  scheduled,
  leisure,
  delivery,
}

class AppState {
  // CORE
  static final selectedCaptain = ValueNotifier<Captain?>(null);
  static final tripStatus = ValueNotifier<TripStatus>(TripStatus.idle);
  static final tripType = ValueNotifier<TripType>(TripType.ride);
  static final pickup = ValueNotifier<LatLng?>(null);
  static final dropoff = ValueNotifier<LatLng?>(null);
  static final etaMinutes = ValueNotifier<int?>(null);
  static final scheduledTime = ValueNotifier<DateTime?>(null);

  // ─────────────────────────────
  // PASSENGER
  // ─────────────────────────────

  static void setTripType(TripType type) {
    if (tripStatus.value != TripStatus.idle) return;
    tripType.value = type;
  }

  static void setScheduledTime(DateTime time) {
    scheduledTime.value = time;
  }

  static void handleMapTap(LatLng point) {
    if (pickup.value == null) {
      pickup.value = point;
    } else if (dropoff.value == null) {
      dropoff.value = point;
    }
  }

  static void requestTrip(Captain captain) {
    // 🔒 Scheduling REQUIRED for scheduled + delivery
    if ((tripType.value == TripType.scheduled ||
        tripType.value == TripType.delivery) &&
        scheduledTime.value == null) {
      return;
    }

    selectedCaptain.value = captain;

    // ETA only for non-scheduled
    if (tripType.value == TripType.ride ||
        tripType.value == TripType.leisure) {
      _recalculateEta();
    } else {
      etaMinutes.value = null;
    }

    tripStatus.value = TripStatus.requested;
  }

  static void cancelTrip() {
    tripStatus.value = TripStatus.cancelled;
    etaMinutes.value = null;
  }

  static void resetTrip() {
    tripStatus.value = TripStatus.idle;
    selectedCaptain.value = null;
    pickup.value = null;
    dropoff.value = null;
    etaMinutes.value = null;
    scheduledTime.value = null;
    tripType.value = TripType.ride;
  }

  // ─────────────────────────────
  // CAPTAIN
  // ─────────────────────────────

  static void acceptTrip() {
    if (tripStatus.value == TripStatus.requested) {
      if (tripType.value == TripType.ride ||
          tripType.value == TripType.leisure) {
        _recalculateEta();
      }
      tripStatus.value = TripStatus.accepted;
    }
  }

  static void arriveAtPickup() {
    if (tripStatus.value == TripStatus.accepted) {
      etaMinutes.value = null;
      tripStatus.value = TripStatus.arrived;
    }
  }

  static void startTrip() {
    if (tripStatus.value == TripStatus.arrived) {
      tripStatus.value = TripStatus.inProgress;
    }
  }

  static void completeTrip() {
    if (tripStatus.value == TripStatus.inProgress) {
      tripStatus.value = TripStatus.completed;
    }
  }

  // ─────────────────────────────
  // ETA
  // ─────────────────────────────

  static void _recalculateEta() {
    final c = selectedCaptain.value;
    final p = pickup.value;
    if (c == null || p == null) return;

    final km = _haversineKm(
      c.location.latitude,
      c.location.longitude,
      p.latitude,
      p.longitude,
    );

    etaMinutes.value = max(2, (km / 25 * 60).round());
  }

  static double _haversineKm(
      double lat1,
      double lon1,
      double lat2,
      double lon2,
      ) {
    const r = 6371;
    final dLat = _deg(lat2 - lat1);
    final dLon = _deg(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg(lat1)) *
            cos(_deg(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  static double _deg(double d) => d * pi / 180;
}