import 'package:flutter/material.dart';
import '../models/workout_set.dart';
import '../services/storage_service.dart';

class SetTracker extends StatefulWidget {
  final String exerciseName;
  final VoidCallback? onDelete; // Optional delete callback

  const SetTracker({
    super.key,
    required this.exerciseName,
    this.onDelete,
  });

  @override
  State<SetTracker> createState() => _SetTrackerState();
}

class _SetTrackerState extends State<SetTracker> {
  final List<WorkoutSet> _sets = [];
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();

  void _addSet() {
    final weight = double.tryParse(_weightController.text) ?? 0;
    final reps = int.tryParse(_repsController.text) ?? 0;

    if (weight > 0 && reps > 0) {
      setState(() {
        _sets.add(WorkoutSet(
          exerciseName: widget.exerciseName,
          reps: reps,
          weight: weight,
          timestamp: DateTime.now(),
        ));
      });

      _weightController.clear();
      _repsController.clear();
    }
  }

  void _saveSets() {
    for (final set in _sets) {
      StorageService.saveSet(set);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved ${_sets.length} sets for ${widget.exerciseName}')),
    );

    setState(() => _sets.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with exercise name and optional delete button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.exerciseName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (widget.onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: widget.onDelete,
                    tooltip: 'Delete Exercise',
                  ),
              ],
            ),

            const SizedBox(height: 10),

            // Input for weight and reps
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _repsController,
                    decoration: const InputDecoration(
                      labelText: 'Reps',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addSet,
                  tooltip: 'Add Set',
                ),
              ],
            ),

            const SizedBox(height: 10),

            // List of current sets (if any)
            if (_sets.isNotEmpty) ...[
              const Divider(),
              const Text('Current Sets:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ..._sets.map((set) => ListTile(
                    title: Text('${set.weight} kg × ${set.reps} reps'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => setState(() => _sets.remove(set)),
                    ),
                  )),
              ElevatedButton(
                onPressed: _saveSets,
                child: const Text('Save All Sets'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
