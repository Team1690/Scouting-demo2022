class SpecificSummaryData {
  SpecificSummaryData({
    required this.ampText,
    required this.climbText,
    required this.drivingText,
    required this.generalText,
    required this.intakeText,
    required this.speakerText,
    required this.defenseText,
  });

  final String ampText;
  final String climbText;
  final String drivingText;
  final String generalText;
  final String intakeText;
  final String speakerText;
  final String defenseText;

  static SpecificSummaryData? parse(
    final dynamic specificSummaryTable,
  ) =>
      specificSummaryTable != null
          ? SpecificSummaryData(
              ampText: specificSummaryTable["amp_text"] as String,
              climbText: specificSummaryTable["climb_text"] as String,
              drivingText: specificSummaryTable["driving_text"] as String,
              generalText: specificSummaryTable["general_text"] as String,
              intakeText: specificSummaryTable["intake_text"] as String,
              speakerText: specificSummaryTable["speaker_text"] as String,
              defenseText: specificSummaryTable["defense_text"] as String,
            )
          : null;
}
