import 'package:flutter/material.dart';

import 'screens/passenger_home.dart';
import 'screens/captain_home.dart';

void main() {
  runApp(const SkipperApp());
}

class SkipperApp extends StatelessWidget {
  const SkipperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skipper',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const RootShell(),
    );
  }
}

/// ─────────────────────────────
/// ROOT SHELL (LOCKED)
/// PassengerHome is NEVER destroyed
/// Uber / Lyft architecture
/// ─────────────────────────────
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  final List<Widget> _pages = const [
    PassengerHome(),
    CaptainHome(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) {
          setState(() {
            _index = i;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Passenger',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_boat),
            label: 'Captain',
          ),
        ],
      ),
    );
  }
}
