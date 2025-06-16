import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/workout_plan.dart';
import '../services/storage_service.dart';

class YourWorkoutsScreen extends StatefulWidget {
  const YourWorkoutsScreen({super.key});

  @override
  State<YourWorkoutsScreen> createState() => _YourWorkoutsScreenState();
}

class _YourWorkoutsScreenState extends State<YourWorkoutsScreen> {
  void _showAddPlanDialog() {
    String name = '';
    final List<String> exercises = [];

    void showPlanDialog() {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Create New Plan'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Plan Name'),
                  onChanged: (val) => name = val,
                ),
                const SizedBox(height: 20),
                const Text('Exercises:'),
                ...exercises.map((e) => Text(e)).toList(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showAddExerciseDialog(exercises, showPlanDialog);
                  },
                  child: const Text('+ Add Exercise'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty && exercises.isNotEmpty) {
                  StorageService.savePlan(WorkoutPlan(name: name, exercises: exercises));
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      );
    }

    showPlanDialog();
  }

  void _showAddExerciseDialog(
      List<String> exercises, VoidCallback reopenPlanDialog) {
    String newExercise = '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Exercise'),
        content: TextField(
          autofocus: true,
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
                exercises.add(newExercise.trim());
                Navigator.pop(ctx);
                reopenPlanDialog();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plansBox = StorageService.plansBox;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Workouts')),
      body: ValueListenableBuilder(
        valueListenable: plansBox.listenable(),
        builder: (context, box, _) {
          final plans = box.values.toList();
          return ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return ListTile(
                title: Text(plan.name),
                subtitle: Text(plan.exercises.join(', ')),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => StorageService.deletePlan(box.keyAt(index)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPlanDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
