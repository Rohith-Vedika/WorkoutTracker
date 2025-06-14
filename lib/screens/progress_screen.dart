import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressScreen extends StatefulWidget {
  final String exerciseName;

  const ProgressScreen({super.key, required this.exerciseName});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int selectedSet = 1;

  // Dummy data: Replace with Hive storage later
  final Map<int, List<double>> setWeights = {
    1: [40, 42.5, 45, 47.5, 50],
    2: [35, 37.5, 40, 42.5, 45],
    3: [30, 32.5, 35, 37.5, 40],
  };

  @override
  Widget build(BuildContext context) {
    List<double> weights = setWeights[selectedSet] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('${widget.exerciseName} Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            DropdownButton<int>(
              value: selectedSet,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedSet = value;
                  });
                }
              },
              items: [1, 2, 3].map((int set) {
                return DropdownMenuItem<int>(
                  value: set,
                  child: Text('Set $set'),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: weights.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value);
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
