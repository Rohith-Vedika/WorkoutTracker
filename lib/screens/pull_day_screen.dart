import 'package:flutter/material.dart';
import '../widgets/exercise_card.dart';

class PullDayScreen extends StatefulWidget {
  const PullDayScreen({super.key});

  @override
  State<PullDayScreen> createState() => _PullDayScreenState();
}

class _PullDayScreenState extends State<PullDayScreen> {
  List<String> exercises = [
    'Deadlift',
    'Lat Pulldown',
    'Barbell Row',
    'Face Pulls',
    'Bicep Curls',
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
      appBar: AppBar(title: const Text('Pull Day')),
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
