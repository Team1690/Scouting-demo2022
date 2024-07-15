import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/models/match_identifier.dart";
import "package:scouting_frontend/models/data/technical_data.dart";
import "package:scouting_frontend/models/enums/robot_field_status.dart";

class TechnicalMatchData {
  TechnicalMatchData({
    required this.id,
    required this.scouterName,
    required this.scheduleMatchId,
    required this.robotFieldStatus,
    required this.data,
    required this.climb,
    required this.matchIdentifier,
  });
  final int id;
  final RobotFieldStatus robotFieldStatus;
  final MatchIdentifier matchIdentifier;
  final TechnicalData<int> data;
  final Climb climb;
  final int scheduleMatchId;
  final String scouterName;

  static TechnicalMatchData parse(
    final dynamic match,
    final IdProvider idProvider,
  ) =>
      TechnicalMatchData(
        id: match["id"] as int,
        matchIdentifier: MatchIdentifier.fromJson(match, idProvider.matchType),
        robotFieldStatus: idProvider.robotFieldStatus
            .idToEnum[match["robot_field_status"]["id"] as int]!,
        //TODO: idprovider climb
        climb: climbTitleToEnum(match["climb"]["title"] as String),
        scheduleMatchId: match["schedule_match"]["id"] as int,
        data: TechnicalData.parse(match),
        scouterName: match["scouter_name"] as String,
      );
}
