import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/captain.dart';
import '../state/app_state.dart';
import '../state/mock_captains.dart';

class PassengerHome extends StatefulWidget {
  const PassengerHome({super.key});

  @override
  State<PassengerHome> createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  Timer? _etaTimer;
  int? _displayEta;

  @override
  void initState() {
    super.initState();
    AppState.etaMinutes.addListener(_syncEta);

    _etaTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (_displayEta != null && _displayEta! > 0) {
        setState(() => _displayEta = _displayEta! - 1);
      }
    });
  }

  void _syncEta() {
    setState(() {
      _displayEta = AppState.etaMinutes.value;
    });
  }

  @override
  void dispose() {
    _etaTimer?.cancel();
    AppState.etaMinutes.removeListener(_syncEta);
    super.dispose();
  }

  // ─────────────────────────────
  // MARKERS
  // ─────────────────────────────
  Set<Marker> _buildMarkers(
      List<Captain> captains,
      Captain? selected,
      TripStatus status,
      LatLng? pickup,
      LatLng? dropoff,
      ) {
    final markers = <Marker>{};

    if (pickup != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickup,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );
    }

    if (dropoff != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('dropoff'),
          position: dropoff,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
        ),
      );
    }

    if (status != TripStatus.idle && selected != null) {
      markers.add(
        Marker(
          markerId: MarkerId(selected.id),
          position: selected.location,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
      return markers;
    }

    markers.addAll(
      captains
          .where((c) => c.isOnline)
          .map(
            (c) => Marker(
          markerId: MarkerId(c.id),
          position: c.location,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          onTap: () {
            if (AppState.tripStatus.value == TripStatus.idle) {
              AppState.selectedCaptain.value = c;
            }
          },
        ),
      ),
    );

    return markers;
  }

  // ─────────────────────────────
  // ACTION PANEL
  // ─────────────────────────────
  Widget _buildActionPanel(TripStatus status, Captain? selected) {
    switch (status) {
      case TripStatus.idle:
        if (selected == null) return const Text('Select a skipper');
        return ElevatedButton(
          onPressed: () => AppState.requestTrip(selected),
          child: const Text('Request Skipper'),
        );

      case TripStatus.requested:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Waiting for captain…'),
            const SizedBox(height: 8),
            TextButton(
              onPressed: AppState.cancelTrip,
              child: const Text('Cancel'),
            ),
          ],
        );

      case TripStatus.accepted:
        return const Text('Captain accepted');

      case TripStatus.arrived:
        return const Text('Captain arrived');

      case TripStatus.inProgress:
        return const Text('Trip in progress');

      case TripStatus.completed:
        return ElevatedButton(
          onPressed: AppState.resetTrip,
          child: const Text('Done'),
        );

      case TripStatus.cancelled:
        return ElevatedButton(
          onPressed: AppState.resetTrip,
          child: const Text('Reset'),
        );
    }
  }

  // ─────────────────────────────
  // ETA BANNER
  // ─────────────────────────────
  Widget _buildEtaBanner(TripStatus status) {
    if (_displayEta == null) return const SizedBox();
    if (status != TripStatus.requested &&
        status != TripStatus.accepted) {
      return const SizedBox();
    }

    final text = _displayEta! <= 1
        ? 'Captain arriving now'
        : 'Captain arriving in $_displayEta min';

    return Positioned(
      left: 16,
      right: 16,
      bottom: 96,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────
  // BUILD
  // ─────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<List<Captain>>(
        valueListenable: mockCaptains,
        builder: (_, captains, __) {
          return ValueListenableBuilder<TripStatus>(
            valueListenable: AppState.tripStatus,
            builder: (_, status, __) {
              return ValueListenableBuilder<Captain?>(
                valueListenable: AppState.selectedCaptain,
                builder: (_, selected, __) {
                  return ValueListenableBuilder<LatLng?>(
                    valueListenable: AppState.pickup,
                    builder: (_, pickup, __) {
                      return ValueListenableBuilder<LatLng?>(
                        valueListenable: AppState.dropoff,
                        builder: (_, dropoff, __) {
                          final showCard =
                              selected != null &&
                                  status != TripStatus.inProgress;

                          return Stack(
                            children: [
                              GoogleMap(
                                initialCameraPosition:
                                const CameraPosition(
                                  target:
                                  LatLng(37.7749, -122.4194),
                                  zoom: 12,
                                ),
                                markers: _buildMarkers(
                                  captains,
                                  selected,
                                  status,
                                  pickup,
                                  dropoff,
                                ),
                                onTap: AppState.handleMapTap,
                                zoomControlsEnabled: false,
                                myLocationButtonEnabled: true,
                              ),

                              const Positioned(
                                top: 56,
                                left: 16,
                                right: 16,
                                child: Column(
                                  children: [
                                    _SearchBar(),
                                    SizedBox(height: 8),
                                    _TripTypePills(),
                                    SizedBox(height: 8),
                                    _ScheduledButton(),
                                  ],
                                ),
                              ),

                              _buildEtaBanner(status),

                              if (showCard)
                                Positioned(
                                  left: 16,
                                  right: 16,
                                  bottom: 140,
                                  child: _CaptainCard(
                                    captain: selected!,
                                  ),
                                ),

                              Positioned(
                                left: 16,
                                right: 16,
                                bottom: 24,
                                child: Container(
                                  padding:
                                  const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 10,
                                        color: Colors.black26,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: _buildActionPanel(
                                        status, selected),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// ─────────────────────────────
// TRIP TYPE PILLS
// ─────────────────────────────
class _TripTypePills extends StatelessWidget {
  const _TripTypePills();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TripType>(
      valueListenable: AppState.tripType,
      builder: (_, type, __) {
        final locked =
            AppState.tripStatus.value != TripStatus.idle;

        return Wrap(
          spacing: 8,
          children: TripType.values.map((t) {
            return ChoiceChip(
              label: Text(t.name),
              selected: t == type,
              onSelected:
              locked ? null : (_) => AppState.setTripType(t),
            );
          }).toList(),
        );
      },
    );
  }
}

// ─────────────────────────────
// SCHEDULE PICKER (FIXED)
// ─────────────────────────────
class _ScheduledButton extends StatelessWidget {
  const _ScheduledButton();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TripType>(
      valueListenable: AppState.tripType,
      builder: (_, type, __) {
        // ✅ FIX: delivery ALSO requires scheduling
        if (type != TripType.scheduled &&
            type != TripType.delivery) {
          return const SizedBox();
        }

        return ElevatedButton(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate:
              DateTime.now().add(const Duration(days: 30)),
            );
            if (date == null) return;

            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (time == null) return;

            AppState.setScheduledTime(DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            ));
          },
          child: const Text('Select pickup time'),
        );
      },
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: const TextField(
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Pickup → Dropoff',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding:
          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class _CaptainCard extends StatelessWidget {
  final Captain captain;
  const _CaptainCard({required this.captain});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              captain.name,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Vessel: ${captain.vessel.name}'),
            Text('Capacity: ${captain.vessel.capacity}'),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.star,
                    size: 18, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                    '${captain.rating.value} (${captain.rating.totalTrips})'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}