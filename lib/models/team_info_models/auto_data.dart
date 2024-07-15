import "package:scouting_frontend/models/data/technical_data.dart";

class AutoData {
  AutoData({
    required this.avgData,
    required this.minData,
    required this.maxData,
  });

  final TechnicalData<double> avgData;
  final TechnicalData<int> minData;
  final TechnicalData<int> maxData;
}
