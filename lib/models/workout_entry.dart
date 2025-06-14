import 'package:hive/hive.dart';

part 'workout_entry.g.dart'; // Needed for codegen

@HiveType(typeId: 0)
class WorkoutEntry extends HiveObject {
  @HiveField(0)
  String exerciseName;

  @HiveField(1)
  int setNumber;

  @HiveField(2)
  int reps;

  @HiveField(3)
  double weight;

  @HiveField(4)
  DateTime date;

  WorkoutEntry({
    required this.exerciseName,
    required this.setNumber,
    required this.reps,
    required this.weight,
    required this.date,
  });
}
