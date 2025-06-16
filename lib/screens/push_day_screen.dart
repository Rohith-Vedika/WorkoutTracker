import 'package:flutter/material.dart';
import '../widgets/set_tracker.dart';
import '../screens/history_screen.dart';
import '../services/storage_service.dart';

class PushDayScreen extends StatefulWidget {
  const PushDayScreen({super.key});

  @override
  State<PushDayScreen> createState() => _PushDayScreenState();
}

class _PushDayScreenState extends State<PushDayScreen> {
  List<String> exercises = [];

  final defaultExercises = [
    'Bench Press',
    'Overhead Press',
    'Incline Dumbbell Press',
    'Cable Flys',
    'Triceps Pushdown',
  ];

  @override
  void initState() {
    super.initState();
    exercises = List.from(defaultExercises); // show default initially
  }

  void _showExerciseSelector(BuildContext context) {
    final plans = StorageService.getPlans();

    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Select a Plan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return ListTile(
                  title: Text(plan.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(plan.exercises.join(', ')),
                  onTap: () {
                    setState(() {
                      exercises = List.from(plan.exercises); // replace
                    });
                    Navigator.pop(ctx);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExerciseDialog(BuildContext context) {
    String newExercise = '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Custom Exercise'),
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
                setState(() {
                  exercises = [newExercise.trim()]; // reset to new one
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
      appBar: AppBar(
        title: const Text('Push Day'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Add Plan') _showExerciseSelector(context);
              if (value == 'Add Custom') _showAddExerciseDialog(context);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 'Add Plan', child: Text('Add from Plans')),
              const PopupMenuItem(
                  value: 'Add Custom', child: Text('Add Custom')),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (ctx, index) => SetTracker(
          exerciseName: exercises[index],
          onDelete: () => setState(() => exercises.removeAt(index)),
        ),
      ),
    );
  }
}
