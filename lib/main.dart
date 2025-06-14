import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WorkoutHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WorkoutHomePage extends StatelessWidget {
  final List<String> workoutDays = ['Push Day', 'Pull Day', 'Leg Day'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workout Tracker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: workoutDays.map((day) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseListPage(dayType: day),
                    ),
                  );
                },
                child: Text(day, style: TextStyle(fontSize: 18)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ExerciseListPage extends StatefulWidget {
  final String dayType;

  ExerciseListPage({required this.dayType});

  @override
  _ExerciseListPageState createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  late List<String> exercises;

  final Map<String, List<String>> workoutPlan = {
    'Push Day': ['Bench Press', 'Shoulder Press', 'Triceps Dips', 'Incline Dumbbell Press', 'Lateral Raises'],
    'Pull Day': ['Pull-ups', 'Barbell Rows', 'Lat Pulldown', 'Face Pulls', 'Bicep Curls'],
    'Leg Day': ['Squats', 'Leg Press', 'Lunges', 'Leg Curls', 'Calf Raises'],
  };

  @override
  void initState() {
    super.initState();
    exercises = List.from(workoutPlan[widget.dayType] ?? []);
  }

  void _addExercise(String newExercise) {
    setState(() {
      exercises.add(newExercise);
    });
  }

  void _showAddExerciseDialog() {
    String newExercise = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Exercise'),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: 'Exercise name'),
          onChanged: (value) => newExercise = value,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (newExercise.trim().isNotEmpty) {
                _addExercise(newExercise.trim());
              }
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.dayType)),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.fitness_center),
            title: Text(exercises[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExerciseDetailPage(exerciseName: exercises[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExerciseDialog,
        child: Icon(Icons.add),
        tooltip: 'Add Exercise',
      ),
    );
  }
}

class ExerciseDetailPage extends StatefulWidget {
  final String exerciseName;

  ExerciseDetailPage({required this.exerciseName});

  @override
  _ExerciseDetailPageState createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  int numberOfSets = 1;
  List<TextEditingController> weightControllers = [];
  List<TextEditingController> repsControllers = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers(1);
  }

  void _initializeControllers(int sets) {
    weightControllers = List.generate(sets, (_) => TextEditingController());
    repsControllers = List.generate(sets, (_) => TextEditingController());
  }

  void _updateSetCount(int newCount) {
    setState(() {
      numberOfSets = newCount;
      _initializeControllers(newCount);
    });
  }

  void _saveData() {
    for (int i = 0; i < numberOfSets; i++) {
      print('Set ${i + 1}: Weight = ${weightControllers[i].text}, Reps = ${repsControllers[i].text}');
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved Successfully')));
  }

  @override
  void dispose() {
    weightControllers.forEach((controller) => controller.dispose());
    repsControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.exerciseName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('Number of Sets: ', style: TextStyle(fontSize: 16)),
                SizedBox(width: 10),
                DropdownButton<int>(
                  value: numberOfSets,
                  items: [1, 2, 3, 4, 5]
                      .map((val) => DropdownMenuItem(value: val, child: Text(val.toString())))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) _updateSetCount(value);
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: numberOfSets,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text('Set ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextField(
                            controller: weightControllers[index],
                            decoration: InputDecoration(labelText: 'Weight (kg)'),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            controller: repsControllers[index],
                            decoration: InputDecoration(labelText: 'Reps'),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text('Save Workout'),
              onPressed: _saveData,
            )
          ],
        ),
      ),
    );
  }
}
