import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../state/mock_captains.dart';

class CaptainHome extends StatefulWidget {
  const CaptainHome({super.key});

  @override
  State<CaptainHome> createState() => _CaptainHomeState();
}

class _CaptainHomeState extends State<CaptainHome> {
  // 🔒 This captain represents the logged-in captain
  static const String captainId = 'c1';

  bool _online = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          // ✅ Proper offset from phone system UI
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─────────────────────────────
              // ONLINE / OFFLINE TOGGLE (LOCKED)
              // ─────────────────────────────
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SwitchListTile(
                  title: Text(
                    _online ? 'Online' : 'Offline',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  value: _online,
                  onChanged: (value) {
                    setState(() => _online = value);
                    setCaptainOnline(captainId, value);
                  },
                ),
              ),

              const SizedBox(height: 32),

              // ─────────────────────────────
              // TRIP FLOW CONTROLS (ONLY THESE)
              // ─────────────────────────────
              ValueListenableBuilder<TripStatus>(
                valueListenable: AppState.tripStatus,
                builder: (_, status, __) {
                  return _buildTripControls(status);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────
  // TRIP FLOW BUTTONS (LOCKED)
  // ─────────────────────────────
  Widget _buildTripControls(TripStatus status) {
    switch (status) {
      case TripStatus.requested:
        return ElevatedButton(
          onPressed: AppState.acceptTrip,
          child: const Text('Accept Passenger'),
        );

      case TripStatus.accepted:
        return ElevatedButton(
          onPressed: AppState.arriveAtPickup,
          child: const Text('Arrived at Pickup'),
        );

      case TripStatus.arrived:
        return ElevatedButton(
          onPressed: AppState.startTrip,
          child: const Text('Start Trip'),
        );

      case TripStatus.inProgress:
        return ElevatedButton(
          onPressed: AppState.completeTrip,
          child: const Text('Complete Trip'),
        );

      case TripStatus.completed:
        return const Center(
          child: Text(
            'Trip Completed',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

      default:
        return const Center(
          child: Text(
            'Waiting for passenger',
            style: TextStyle(fontSize: 16),
          ),
        );
    }
  }
}