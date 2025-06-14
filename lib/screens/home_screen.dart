import 'package:flutter/material.dart';
import 'push_day_screen.dart';
import 'pull_day_screen.dart';
import 'leg_day_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Tracker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PushDayScreen()),
                );
              },
              child: const Text('Push Day'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PullDayScreen()),
                );
              },
              child: const Text('Pull Day'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LegDayScreen()),
                );
              },
              child: const Text('Leg Day'),
            ),
          ],
        ),
      ),
    );
  }
}
