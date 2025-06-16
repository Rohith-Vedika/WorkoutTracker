import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'screens/push_day_screen.dart';
import 'package:hive_flutter/hive_flutter.dart'; 
import 'models/workout_set.dart';               
import 'services/storage_service.dart'; // Add this import
import 'models/workout_plan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(WorkoutSetAdapter()); 
  await Hive.openBox<WorkoutSet>('workoutBox');
  
  // Initialize StorageService after opening the box
  await StorageService.init();
  
  Hive.registerAdapter(WorkoutPlanAdapter()); // This line is essential

  runApp(const WorkoutTrackerApp());
}

class WorkoutTrackerApp extends StatelessWidget {
  const WorkoutTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}