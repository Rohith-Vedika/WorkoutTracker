import 'package:flutter/material.dart';
import 'push_day_screen.dart';
import 'your_workouts_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Tracker')),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildCategoryCard(context, 'Push', Colors.blue, () => Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => const PushDayScreen()),
          )),
          _buildCategoryCard(context, 'Pull', Colors.red, () {}),
          _buildCategoryCard(context, 'Legs', Colors.green, () {}),
          _buildCategoryCard(context, 'Your Workouts', Colors.purple, () => Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => const YourWorkoutsScreen()),
          )),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, Color color, VoidCallback onTap) {
    return Card(
      color: color,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}