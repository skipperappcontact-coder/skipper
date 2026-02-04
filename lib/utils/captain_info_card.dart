import 'package:flutter/material.dart';
import '../models/captain.dart';
import '../state/app_state.dart';

class CaptainCard extends StatelessWidget {
  final Captain captain;

  const CaptainCard({super.key, required this.captain});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NAME + ETA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  captain.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ValueListenableBuilder<int?>(
                  valueListenable: AppState.etaMinutes,
                  builder: (_, eta, __) {
                    if (eta == null) return const SizedBox();
                    return _EtaBadge(minutes: eta);
                  },
                ),
              ],
            ),

            const SizedBox(height: 6),
            Text('Vessel: ${captain.vessel.name}'),
            Text('Capacity: ${captain.vessel.capacity}'),

            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, size: 18, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '${captain.rating.value} '
                      '(${captain.rating.totalTrips} trips)',
                ),
              ],
            ),

            const SizedBox(height: 8),

            // STATUS LINE
            ValueListenableBuilder<TripStatus>(
              valueListenable: AppState.tripStatus,
              builder: (_, status, __) {
                switch (status) {
                  case TripStatus.accepted:
                    return const Text('Captain en route');
                  case TripStatus.arrived:
                    return const Text('Captain has arrived');
                  case TripStatus.inProgress:
                    return const Text('Trip in progress');
                  case TripStatus.completed:
                    return const Text('Trip completed');
                  default:
                    return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// ETA PILL
class _EtaBadge extends StatelessWidget {
  final int minutes;

  const _EtaBadge({required this.minutes});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$minutes min',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
