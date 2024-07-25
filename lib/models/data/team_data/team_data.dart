import "package:collection/collection.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/data/team_match_data.dart";
import "package:scouting_frontend/models/data/technical_match_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/models/data/aggregate_data/aggregate_technical_data.dart";
import "package:scouting_frontend/models/data/pit_data/pit_data.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view/fault_entry.dart";

class TeamData {
  TeamData({
    required this.matches,
    required this.pitData,
    required this.lightTeam,
    required this.faultEntrys,
    required this.aggregateData,
    required this.firstPicklistIndex,
    required this.secondPicklistIndex,
    required this.thirdPicklistIndex,
  });
  final List<FaultEntry> faultEntrys;
  final AggregateData aggregateData;
  final PitData? pitData;
  final LightTeam lightTeam;
  final int firstPicklistIndex;
  final int secondPicklistIndex;
  final int thirdPicklistIndex;
  final List<MatchData> matches;

  List<TechnicalMatchData> get technicalMatches => matches
      .map((final MatchData e) => e.technicalMatchData)
      .whereNotNull()
      .toList();

  int get matchesClimbedFirst =>
      technicalMatches // Counts all matches where robot climbed to X bar
          .where(
            (final TechnicalMatchData element) =>
                (element.climb == Climb.climbOne),
          )
          .length;
  int get matchesClimbedSecond => technicalMatches
      .where(
        (final TechnicalMatchData element) => (element.climb == Climb.climbTwo),
      )
      .length;
  int get matchesClimbedThird => technicalMatches
      .where(
        (final TechnicalMatchData element) =>
            (element.climb == Climb.climbThree),
      )
      .length;

  int get matchesClimbed => technicalMatches
      .where(
        (final TechnicalMatchData element) =>
            element.climb == Climb.climbOne ||
            element.climb == Climb.climbTwo ||
            element.climb == Climb.climbThree,
      )
      .length;

  double get climbPercentage =>
      100 *
      (aggregateData.gamesPlayed == 0
          ? 0
          : matchesClimbed / (aggregateData.gamesPlayed));

  double get aim =>
      100 *
      (aggregateData.avgData.totalGamepieces /
              (aggregateData.avgData.totalGamepieces +
                  aggregateData.avgData.totalMissed))
          .clamp(double.minPositive, double.maxFinite);

  // double get trapSuccessRate =>
  //     100 * aggregateData.sumData.trapAmount / aggregateData.gamesPlayed;
}
