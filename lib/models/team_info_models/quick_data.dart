import "package:scouting_frontend/models/data/technical_data.dart";

class QuickData {
  const QuickData({
    required this.avgData,
    required this.maxData,
    required this.minData,
    required this.amoutOfMatches,
    required this.firstPicklistIndex,
    required this.secondPicklistIndex,
    required this.thirdPicklistIndex,
    required this.matchesClimbedFirst,
    required this.matchesClimbedSecond,
    required this.matchesClimbedThird,
    required this.climbPercentage,
  });
  final int amoutOfMatches;
  final int firstPicklistIndex;
  final int secondPicklistIndex;
  final int thirdPicklistIndex;
  final TechnicalData<double> avgData;
  final TechnicalData<int> maxData;
  final TechnicalData<int> minData;
  final int matchesClimbedFirst;
  final int matchesClimbedSecond;
  final int matchesClimbedThird;
  final double climbPercentage;
}
