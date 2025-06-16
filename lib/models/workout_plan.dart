import 'package:hive/hive.dart';

part 'workout_plan.g.dart';

@HiveType(typeId: 1) // Different TypeId than WorkoutSet
class WorkoutPlan {
  @HiveField(0)
  final String name;
  
  @HiveField(1)
  final List<String> exercises;

  WorkoutPlan({required this.name, required this.exercises});
}