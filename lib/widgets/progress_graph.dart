import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/workout_entry.dart';

class ProgressGraph extends StatefulWidget {
  final String exerciseName;
  final int setNumber;

  const ProgressGraph({
    super.key,
    required this.exerciseName,
    required this.setNumber,
  });

  @override
  State<ProgressGraph> createState() => _ProgressGraphState();
}

class _ProgressGraphState extends State<ProgressGraph> {
  List<WorkoutEntry> filteredEntries = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    final box = Hive.box<WorkoutEntry>('workoutBox');
    final allEntries = box.values.toList();

    setState(() {
      filteredEntries = allEntries
          .where((entry) =>
              entry.exerciseName == widget.exerciseName &&
              entry.setNumber == widget.setNumber)
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date)); // sort by date
    });
  }

  @override
  Widget build(BuildContext context) {
    if (filteredEntries.isEmpty) {
      return const Center(child: Text("No data available yet."));
    }

    final List<FlSpot> spots = List.generate(
      filteredEntries.length,
      (index) => FlSpot(
        (index + 1).toDouble(), // x = 1-based session number
        filteredEntries[index].weight,
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            "Progress (Set-wise Weight)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text("S${value.toInt()}",
                            style: const TextStyle(fontSize: 10));
                      },
                      reservedSize: 32,
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(
                        "${value.toInt()}kg",
                        style: const TextStyle(fontSize: 10),
                      ),
                      reservedSize: 40,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.blueAccent,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.2),
                    ),
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
