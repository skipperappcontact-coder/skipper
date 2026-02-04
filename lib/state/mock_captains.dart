import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/captain.dart';

final ValueNotifier<List<Captain>> mockCaptains =
ValueNotifier<List<Captain>>([
  Captain(
    id: 'c1',
    name: 'Captain Jack',
    location: const LatLng(37.7749, -122.4194),
    vessel: const Vessel(
      name: 'Sea Breeze',
      type: 'Motorboat',
      capacity: 6,
    ),
    rating: const Rating(value: 4.8, totalTrips: 124),
    isOnline: true,
  ),
  Captain(
    id: 'c2',
    name: 'Captain Anna',
    location: const LatLng(37.7849, -122.4094),
    vessel: const Vessel(
      name: 'Wave Rider',
      type: 'Catamaran',
      capacity: 8,
    ),
    rating: const Rating(value: 4.9, totalTrips: 98),
    isOnline: true,
  ),
]);

/// 🔒 SINGLE SOURCE OF TRUTH
void setCaptainOnline(String captainId, bool online) {
  mockCaptains.value = mockCaptains.value
      .map((c) =>
  c.id == captainId ? c.copyWith(isOnline: online) : c)
      .toList();
}