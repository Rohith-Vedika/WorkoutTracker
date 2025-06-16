import 'package:hive/hive.dart';
import '../models/workout_set.dart';
import '../models/workout_plan.dart';

class StorageService {
  static late Box<WorkoutSet> _workoutBox;
  static late Box<WorkoutPlan> _plansBox;

  static Future<void> init() async {
    // Use the same box name as in main.dart ('workoutBox')
    _workoutBox = await Hive.openBox<WorkoutSet>('workoutBox');
    _plansBox = await Hive.openBox<WorkoutPlan>('workoutPlans'); // New box
  }

  static void saveSet(WorkoutSet set) {
    _workoutBox.add(set);
  }

  static List<WorkoutSet> getSetsForExercise(String exerciseName) {
    return _workoutBox.values
        .where((set) => set.exerciseName == exerciseName)
        .toList();
  }

  static void deleteSet(int key) {
    _workoutBox.delete(key);
  }

  static void clearAllData() {
    _workoutBox.clear();
  }


  // Plan CRUD operations
  static Box<WorkoutPlan> get plansBox => _plansBox;
  static void savePlan(WorkoutPlan plan) => _plansBox.add(plan);
  static List<WorkoutPlan> getPlans() => _plansBox.values.toList();
  static void deletePlan(int key) => _plansBox.delete(key);

}