import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/team_model.dart";

class ScoutingShift {
  ScoutingShift({
    required this.name,
    required this.matchIdentifier,
    required this.team,
    required this.scheduleId,
  });

  final String name;
  final MatchIdentifier matchIdentifier;
  final LightTeam team;
  final int scheduleId;

  static ScoutingShift fromJson(
    final dynamic shift,
    final IdTable<MatchType> matchType,
  ) =>
      ScoutingShift(
        name: shift["scouter_name"] as String,
        matchIdentifier: MatchIdentifier.fromJson(
          shift,
          matchType,
          false,
        ),
        team: LightTeam.fromJson(shift["team"]),
        scheduleId: shift["schedule_match"]["id"] as int,
      );
  Map<String, dynamic> toJson() => <String, dynamic>{
        "scouter_name": name,
        "team_id": team.id,
        "schedule_id": scheduleId,
      };
}
