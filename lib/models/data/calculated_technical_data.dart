import "package:scouting_frontend/models/data/technical_data.dart";

class CalculatedTechnicalData<T extends num> implements TechnicalData<T> {
  CalculatedTechnicalData({
    required this.calculateFieldAggregateData,
    required this.technicalDatas,
  });

  final T Function(List<TechnicalData<int>>, int Function(TechnicalData<int>))
      calculateFieldAggregateData;
  final List<TechnicalData<int>> technicalDatas;

  @override
  T get upperHubGamepieces => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.upperHubGamepieces,
      );

  @override
  T get autoGamepieces => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.autoGamepieces,
      );

  @override
  T get autoLowerHubPoints => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.autoLowerHubPoints,
      );

  @override
  T get autoPoints => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.autoPoints,
      );

  @override
  T get autoUpperHubPoints => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.autoUpperHubPoints,
      );

  @override
  T get climbId => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.climbId,
      );

  @override
  T get leftTarmac => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.leftTarmac,
      );

  @override
  T get leftTarmacPoints => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.leftTarmacPoints,
      );

  @override
  T get lowerHubAuto => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.lowerHubAuto,
      );

  @override
  T get lowerHubGamepieces => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.lowerHubGamepieces,
      );

  @override
  T get lowerHubMissedAuto => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.lowerHubMissedAuto,
      );

  @override
  T get lowerHubMissedTele => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.lowerHubMissedTele,
      );

  @override
  T get lowerHubTele => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.lowerHubTele,
      );

  @override
  T get missedAuto => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.missedAuto,
      );

  @override
  T get missedLowerHub => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.missedLowerHub,
      );

  @override
  T get missedTele => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.missedTele,
      );

  @override
  T get missedUpperHub => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.missedUpperHub,
      );

  @override
  T get teleGamepieces => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.teleGamepieces,
      );

  @override
  T get teleLowerHubPoints => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.teleLowerHubPoints,
      );

  @override
  T get telePoints => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.telePoints,
      );

  @override
  T get teleUpperHubPoints => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.teleUpperHubPoints,
      );

  @override
  T get totalGamepieces => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.totalGamepieces,
      );

  @override
  T get totalMissed => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.totalMissed,
      );

  @override
  T get totalPoints => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.totalPoints,
      );

  @override
  T get upperHubAuto => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.upperHubAuto,
      );

  @override
  T get upperHubMissedAuto => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.upperHubMissedAuto,
      );

  @override
  T get upperHubMissedTele => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.upperHubMissedTele,
      );

  @override
  T get upperHubTele => calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> techdata) => techdata.upperHubTele,
      );

  T caclulateOnListOfField(
    final int Function(int, int) combine,
    final List<int> Function(TechnicalData<int>) getFields,
  ) =>
      calculateFieldAggregateData(
        technicalDatas,
        (final TechnicalData<int> technicalData) =>
            getFields(technicalData).reduce(combine),
      );
}
