import "dart:math";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/models/enums/robot_field_status.dart";

class _BaseLineChart extends StatelessWidget {
  const _BaseLineChart({
    required this.showShadow,
    required this.inputedColors,
    required this.dataSet,
    this.gameNumbers,
    required this.getToolipItems,
    required this.rightTitles,
    required this.maxY,
    required this.minY,
    required this.robotMatchStatuses,
  });

  final double minY;

  final double maxY;
  final List<LineTooltipItem?> Function(List<LineBarSpot>) getToolipItems;
  final bool showShadow;
  final List<Color> inputedColors;
  final List<List<int>> dataSet;
  final List<MatchIdentifier>? gameNumbers;
  final SideTitles rightTitles;
  final List<List<RobotFieldStatus>> robotMatchStatuses;
  @override
  Widget build(final BuildContext context) => LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              fitInsideVertically: true,
              fitInsideHorizontally: true,
              getTooltipItems: getToolipItems,
              tooltipPadding: const EdgeInsets.all(8),
            ),
          ),
          lineBarsData: List<LineChartBarData>.generate(
            dataSet.length,
            (final int index) => LineChartBarData(
              isCurved: false,
              color: inputedColors[index],
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (
                  final FlSpot spot,
                  final double d,
                  final LineChartBarData a,
                  final int v,
                ) =>
                    FlDotCirclePainter(
                  strokeWidth: 4,
                  radius: 6,
                  color: secondaryColor,
                  strokeColor: robotMatchStatuses[index][spot.x.toInt()].color,
                ),
                checkToShowDot:
                    (final FlSpot spot, final LineChartBarData barData) =>
                        robotMatchStatuses[index][spot.x.toInt()] !=
                        RobotFieldStatus.worked,
              ),
              belowBarData: BarAreaData(
                show: true,
                color: inputedColors[index].withOpacity(showShadow ? 0.3 : 0),
              ),
              spots: List<FlSpot>.generate(
                dataSet[index].length,
                (final int inner) => FlSpot(
                  inner.toDouble(),
                  dataSet[index][inner].toDouble(),
                ),
              ),
            ),
          ),
          gridData: FlGridData(
            verticalInterval: 1,
            horizontalInterval: 1,
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (final double value) => const FlLine(
              color: Color(0xff37434d),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (final double value) => const FlLine(
              color: Color(0xff37434d),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: rightTitles),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 20,
                getTitlesWidget:
                    (final double value, final TitleMeta titleMeta) => Text(
                  gameNumbers![value.toInt()].toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isPC(context) ? 12 : 8,
                  ),
                ),
                showTitles: gameNumbers != null,
                interval: 1,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          minX: 0,
          minY: minY,
          maxY: maxY,
        ),
      );
}

class DashboardTitledLineChart extends StatelessWidget {
  const DashboardTitledLineChart({
    required this.dataSet,
    required this.inputedColors,
    this.gameNumbers,
    required this.showShadow,
    required this.robotMatchStatuses,
    required this.heightsToTitles,
    required this.maxY,
    required this.minY,
  });
  final List<Color> inputedColors;
  final List<MatchIdentifier>? gameNumbers;
  final List<List<RobotFieldStatus>> robotMatchStatuses;
  final Map<int, String> heightsToTitles;
  final double maxY;
  final double minY;

  final List<List<int>> dataSet;
  final bool showShadow;
  @override
  Widget build(final BuildContext context) => _BaseLineChart(
        robotMatchStatuses: robotMatchStatuses,
        showShadow: showShadow,
        inputedColors: inputedColors,
        dataSet: dataSet,
        gameNumbers: gameNumbers,
        getToolipItems: (final List<LineBarSpot> touchedSpots) => touchedSpots
            .map(
              (final LineBarSpot lineBarSpot) => LineTooltipItem(
                heightsToTitles[lineBarSpot.y.toInt()] ?? "",
                TextStyle(color: lineBarSpot.bar.color),
              ),
            )
            .toList(),
        rightTitles: SideTitles(
          interval: 1,
          getTitlesWidget: (final double value, final TitleMeta _) => Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              heightsToTitles[value.toInt()] ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          showTitles: true,
          reservedSize: 120,
        ),
        minY: minY,
        maxY: maxY,
      );
}

class DashboardLineChart extends StatelessWidget {
  const DashboardLineChart({
    required this.dataSet,
    this.gameNumbers,
    this.distanceFromHighest = 5,
    required this.inputedColors,
    required this.showShadow,
    required this.robotMatchStatuses,
    this.sideTitlesInterval = 5,
  });
  final bool showShadow;
  final List<Color> inputedColors;
  final int distanceFromHighest;
  final List<List<int>> dataSet;
  final List<MatchIdentifier>? gameNumbers;
  final List<List<RobotFieldStatus>> robotMatchStatuses;
  final double sideTitlesInterval;
  int get highestValue =>
      dataSet.map((final List<int> points) => points.reduce(max)).reduce(max);

  @override
  Widget build(final BuildContext context) => _BaseLineChart(
        robotMatchStatuses: robotMatchStatuses,
        showShadow: showShadow,
        inputedColors: inputedColors,
        dataSet: dataSet,
        gameNumbers: gameNumbers,
        getToolipItems: (final List<LineBarSpot> touchedSpots) {
          touchedSpots.sort(
            (final LineBarSpot a, final LineBarSpot b) =>
                inputedColors.indexOf(b.bar.color ?? Colors.white) >
                        inputedColors.indexOf(b.bar.color ?? Colors.white)
                    ? inputedColors.indexOf(b.bar.color ?? Colors.white)
                    : inputedColors.indexOf(b.bar.color ?? Colors.white),
          );
          return touchedSpots.reversed
              .map(
                (final LineBarSpot e) => LineTooltipItem(
                  e.y.toInt().toString(),
                  TextStyle(
                    color: e.bar.color,
                  ),
                ),
              )
              .toList();
        },
        rightTitles: SideTitles(
          interval: sideTitlesInterval,
          getTitlesWidget: (final double value, final TitleMeta a) => Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              value % a.appliedInterval.toInt() == 0
                  ? value.toInt().toString()
                  : "",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          showTitles: true,
          reservedSize: 28,
        ),
        maxY: highestValue.toDouble() + distanceFromHighest,
        minY: 0,
      );
}
