import 'package:hive/hive.dart';

part 'workout_set.g.dart';

@HiveType(typeId: 0)
class WorkoutSet {
  @HiveField(0)
  final String exerciseName;
  
  @HiveField(1)
  final int reps;
  
  @HiveField(2)
  final double weight;
  
  @HiveField(3)
  final DateTime timestamp;

  WorkoutSet({
    required this.exerciseName,
    required this.reps,
    required this.weight,
    required this.timestamp,
  });
}