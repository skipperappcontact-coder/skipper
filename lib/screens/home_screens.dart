import 'package:flutter/material.dart';
import 'passenger_home.dart';
import 'captain_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skipper'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ─────────────────────────────
              // LOGO (optional for now)
              // ─────────────────────────────
              // Image.asset(
              // 'assets/images/skipper_logo.png',
              // height: 120,
              // ),

              // const SizedBox(height: 32),

              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PassengerHome(),
                      ),
                    );
                  },
                  child: const Text('Passenger'),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: 220,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CaptainHome(),
                      ),
                    );
                  },
                  child: const Text('Captain'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
