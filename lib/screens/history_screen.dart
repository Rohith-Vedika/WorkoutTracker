import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/workout_set.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _clearAllWorkouts(context),
          ),
        ],
      ),
      body: _buildHistoryList(),
    );
  }

  Widget _buildHistoryList() {
    return ValueListenableBuilder(
      valueListenable: Hive.box<WorkoutSet>('workoutBox').listenable(),
      builder: (context, box, _) {
        final workouts = box.values.toList().reversed.toList(); // Newest first
        
        if (workouts.isEmpty) {
          return const Center(
            child: Text('No workouts recorded yet!',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: workouts.length,
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(
                  workout.exerciseName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${workout.weight} kg × ${workout.reps} reps'),
                    Text(
                      _formatDate(workout.timestamp),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteWorkout(context, box.keyAt(index)),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _deleteWorkout(BuildContext context, int key) async {
    await Hive.box<WorkoutSet>('workoutBox').delete(key);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout deleted')),
    );
  }

  Future<void> _clearAllWorkouts(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History?'),
        content: const Text('This cannot be undone'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await Hive.box<WorkoutSet>('workoutBox').clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All workouts deleted')),
      );
    }
  }
}