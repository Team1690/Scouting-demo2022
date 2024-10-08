import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/data/technical_match_data.dart";
import "package:scouting_frontend/models/team_model.dart";

class MatchData {
  const MatchData({
    required this.technicalMatchData,
    required this.scheduleMatch,
    required this.team,
  });

  final TechnicalMatchData? technicalMatchData;
  final ScheduleMatch scheduleMatch;
  final LightTeam team;
  bool get isBlueAlliance => scheduleMatch.blueAlliance.contains(team);
}

extension MatchDataList on List<MatchData> {
  List<MatchData> get technicalMatchExists =>
      where((final MatchData element) => element.technicalMatchData != null)
          .toList();
}
