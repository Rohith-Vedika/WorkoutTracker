import 'package:flutter/material.dart';
import '../widgets/exercise_card.dart';

class LegDayScreen extends StatefulWidget {
  const LegDayScreen({super.key});

  @override
  State<LegDayScreen> createState() => _LegDayScreenState();
}

class _LegDayScreenState extends State<LegDayScreen> {
  List<String> exercises = [
    'Squats',
    'Leg Press',
    'Lunges',
    'Leg Curl',
    'Calf Raise',
  ];

  void _showAddExerciseDialog(BuildContext context) {
    String newExercise = '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Exercise'),
        content: TextField(
          decoration: const InputDecoration(hintText: 'Exercise Name'),
          onChanged: (val) => newExercise = val,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newExercise.trim().isNotEmpty) {
                setState(() {
                  exercises.add(newExercise.trim());
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leg Day')),
      body: ListView(
        children: exercises.map((name) => ExerciseCard(exerciseName: name)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExerciseDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}



