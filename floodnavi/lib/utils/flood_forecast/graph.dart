import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WaterLevelChart extends StatelessWidget {
  const WaterLevelChart({
    super.key,
    required this.levels,
    required this.labels,
    this.floodThreshold,
  });

  final List<double> levels;
  final List<String> labels;
  final double? floodThreshold;

  @override
  Widget build(BuildContext context) {
    if (levels.isEmpty) {
      return const Center(
        child: Text('No data', style: TextStyle(color: Colors.white70)),
      );
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < levels.length; i++) {
      spots.add(FlSpot(i.toDouble(), levels[i]));
    }

    final minY = (levels.reduce((a, b) => a < b ? a : b) - 0.1).clamp(
      0.0,
      double.infinity,
    );
    final maxY = (levels.reduce((a, b) => a > b ? a : b) + 0.1);

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (levels.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,

        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: (maxY - minY) / 4,
          verticalInterval: 1,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: Colors.white24, strokeWidth: 1),
          getDrawingVerticalLine: (_) =>
              FlLine(color: Colors.white12, strokeWidth: 1),
        ),

        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            axisNameWidget: const Text(
              "Water Level (m ASL)",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, _) => Text(
                value.toStringAsFixed(1),
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: const Text(
              "Date",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= labels.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    labels[i],
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),

        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: Colors.white24),
            bottom: BorderSide(color: Colors.white24),
          ),
        ),

        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipColor: (touchedSpot) =>
                Colors.black87, // ✅ updated syntax
            getTooltipItems: (touchedSpots) => touchedSpots.map((barSpot) {
              final idx = barSpot.x.toInt();
              final label = (idx >= 0 && idx < labels.length)
                  ? labels[idx]
                  : '';
              return LineTooltipItem(
                '$label\n${barSpot.y.toStringAsFixed(2)} m',
                const TextStyle(color: Colors.white),
              );
            }).toList(),
          ),
        ),

        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 397.59,
              color: Colors.red,
              dashArray: [5, 5],
              label: HorizontalLineLabel(
                show: true,
                labelResolver: (_) => 'Riverbank (397.59 m)',
              ),
            ),
            HorizontalLine(
              y: 392.72,
              color: Colors.blue,
              dashArray: [5, 5],
              label: HorizontalLineLabel(
                show: true,
                labelResolver: (_) => 'Average (392.72 m)',
              ),
            ),
          ],
        ),

        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: Colors.cyanAccent,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.cyanAccent.withOpacity(0.15),
            ),
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
