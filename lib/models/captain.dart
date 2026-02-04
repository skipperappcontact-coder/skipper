import 'package:google_maps_flutter/google_maps_flutter.dart';

class Vessel {
  final String name;
  final String type;
  final int capacity;

  const Vessel({
    required this.name,
    required this.type,
    required this.capacity,
  });
}

class Rating {
  final double value;
  final int totalTrips;

  const Rating({
    required this.value,
    required this.totalTrips,
  });
}

class Captain {
  final String id;
  final String name;
  final LatLng location;
  final Vessel vessel;
  final Rating rating;
  final bool isOnline;

  const Captain({
    required this.id,
    required this.name,
    required this.location,
    required this.vessel,
    required this.rating,
    required this.isOnline,
  });

  Captain copyWith({
    bool? isOnline,
    LatLng? location,
  }) {
    return Captain(
      id: id,
      name: name,
      location: location ?? this.location,
      vessel: vessel,
      rating: rating,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
