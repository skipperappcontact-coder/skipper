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
  // ─────────────────────────────
  // CORE STATE
  // ─────────────────────────────
  static final ValueNotifier<Captain?> selectedCaptain =
  ValueNotifier<Captain?>(null);

  static final ValueNotifier<TripStatus> tripStatus =
  ValueNotifier<TripStatus>(TripStatus.idle);

  static final ValueNotifier<TripType> tripType =
  ValueNotifier<TripType>(TripType.ride);

  static final ValueNotifier<LatLng?> pickup =
  ValueNotifier<LatLng?>(null);

  static final ValueNotifier<LatLng?> dropoff =
  ValueNotifier<LatLng?>(null);

  static final ValueNotifier<int?> etaMinutes =
  ValueNotifier<int?>(null);

  static final ValueNotifier<double?> estimatedPrice =
  ValueNotifier<double?>(null);

  static final ValueNotifier<DateTime?> scheduledTime =
  ValueNotifier<DateTime?>(null);

  // ─────────────────────────────
  // PASSENGER ACTIONS
  // ─────────────────────────────
  static void setTripType(TripType type) {
    if (tripStatus.value != TripStatus.idle) return;
    tripType.value = type;
    _recalculatePrice();
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
    _recalculatePrice(); // ✅ pricing only
  }

  static void requestTrip(Captain captain) {
    if (tripType.value == TripType.scheduled &&
        scheduledTime.value == null) {
      return;
    }

    selectedCaptain.value = captain;

    if (tripType.value != TripType.scheduled) {
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
    estimatedPrice.value = null;
    tripType.value = TripType.ride;
    scheduledTime.value = null;
  }

  // ─────────────────────────────
  // CAPTAIN ACTIONS
  // ─────────────────────────────
  static void acceptTrip() {
    if (tripStatus.value == TripStatus.requested) {
      if (tripType.value != TripType.scheduled) {
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
  // ETA + PRICING
  // ─────────────────────────────
  static void _recalculateEta() {
    final captain = selectedCaptain.value;
    final p = pickup.value;

    if (captain == null || p == null) {
      etaMinutes.value = null;
      return;
    }

    final km = _haversineKm(
      captain.location.latitude,
      captain.location.longitude,
      p.latitude,
      p.longitude,
    );

    const speedKmh = 25.0;
    etaMinutes.value = max(2, (km / speedKmh * 60).round());
  }

  static void _recalculatePrice() {
    final p = pickup.value;
    final d = dropoff.value;

    if (p == null || d == null) {
      estimatedPrice.value = null;
      return;
    }

    final km = _haversineKm(
      p.latitude,
      p.longitude,
      d.latitude,
      d.longitude,
    );

    double price = 8.0 + (km * 3.5);

    if (tripType.value == TripType.leisure) price *= 1.2;
    if (tripType.value == TripType.delivery) price *= 1.15;
    if (tripType.value == TripType.scheduled) price += 5.0;

    estimatedPrice.value =
        double.parse(price.toStringAsFixed(2));
  }

  static double _haversineKm(
      double lat1,
      double lon1,
      double lat2,
      double lon2,
      ) {
    const r = 6371;
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  static double _degToRad(double deg) => deg * pi / 180;
}