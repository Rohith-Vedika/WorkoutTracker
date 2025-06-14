import 'package:flutter/material.dart';
import '../screens/progress_screen.dart';
import 'package:hive/hive.dart';
import '../models/workout_entry.dart';

class ExerciseCard extends StatefulWidget {
  final String exerciseName;

  const ExerciseCard({super.key, required this.exerciseName});

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  int sets = 1;
  List<int> reps = [10];
  List<double> weights = [40];

  void _openEditDialog() {
    final tempReps = [...reps];
    final tempWeights = [...weights];
    int tempSets = sets;

    showDialog(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: MediaQuery.of(ctx).viewInsets, // Prevents bottom overflow
          child: AlertDialog(
            title: Text('Edit ${widget.exerciseName}'),
            content: StatefulBuilder(
              builder: (ctx, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(tempSets, (index) {
                        return Row(
                          children: [
                            Text('Set ${index + 1}:'),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                initialValue: tempReps.length > index
                                    ? tempReps[index].toString()
                                    : '0',
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: 'Reps'),
                                onChanged: (val) {
                                  if (index >= tempReps.length) {
                                    tempReps.add(0);
                                  }
                                  tempReps[index] = int.tryParse(val) ?? 0;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                initialValue: tempWeights.length > index
                                    ? tempWeights[index].toString()
                                    : '0.0',
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: 'Weight'),
                                onChanged: (val) {
                                  if (index >= tempWeights.length) {
                                    tempWeights.add(0.0);
                                  }
                                  tempWeights[index] = double.tryParse(val) ?? 0.0;
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                tempSets++;
                                tempReps.add(10);
                                tempWeights.add(40);
                              });
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Add Set"),
                          ),
                          const SizedBox(width: 10),
                          if (tempSets > 1)
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  tempSets--;
                                  tempReps.removeLast();
                                  tempWeights.removeLast();
                                });
                              },
                              icon: const Icon(Icons.remove),
                              label: const Text("Remove"),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                            ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    sets = tempSets;
                    reps = List<int>.from(tempReps.take(tempSets));
                    weights = List<double>.from(tempWeights.take(tempSets));
                  });

                  final box = Hive.box<WorkoutEntry>('workoutBox');
                  final now = DateTime.now();

                  for (int i = 0; i < sets; i++) {
                    final entry = WorkoutEntry(
                      exerciseName: widget.exerciseName,
                      setNumber: i + 1,
                      reps: reps[i],
                      weight: weights[i],
                      date: now,
                    );
                    await box.add(entry);
                  }

                  Navigator.pop(ctx);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(widget.exerciseName, style: const TextStyle(fontSize: 18)),
        subtitle: Text(
          List.generate(sets, (i) => "Set ${i + 1}: ${reps[i]} reps \u2022 ${weights[i]} kg").join('\n'),
          style: const TextStyle(fontSize: 14),
        ),
        trailing: Column(
          children: [
            ElevatedButton(
              onPressed: _openEditDialog,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
              child: const Text('Edit', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProgressScreen(exerciseName: widget.exerciseName),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4)),
              child: const Text('Progress', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
