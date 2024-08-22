import "package:flutter/cupertino.dart";
import "package:scouting_frontend/models/enums/autonomous_options_enum.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/enums/robot_field_status.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/mobile/hasura_vars.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";

class InputViewVars implements HasuraVars {
  InputViewVars()
      : isRematch = false,
        scheduleMatch = null,
        scouterName = "",
        robotFieldStatus = RobotFieldStatus.worked,
        upperHubTele = 0,
        lowerHubTele = 0,
        upperHubAuto = 0,
        lowerHubAuto = 0,
        upperHubMissedTele = 0,
        lowerHubMissedTele = 0,
        upperHubMissedAuto = 0,
        lowerHubMissedAuto = 0,
        leftTarmac = false,
        climb = null,
        scoutedTeam = null,
        faultMessage = null;

  InputViewVars.all({
    required this.faultMessage,
    required this.isRematch,
    required this.scheduleMatch,
    required this.scouterName,
    required this.robotFieldStatus,
    required this.climb,
    required this.scoutedTeam,
    required this.upperHubTele,
    required this.lowerHubTele,
    required this.upperHubAuto,
    required this.lowerHubAuto,
    required this.upperHubMissedTele,
    required this.lowerHubMissedTele,
    required this.upperHubMissedAuto,
    required this.lowerHubMissedAuto,
    required this.leftTarmac,
  });

  InputViewVars cleared() =>
      InputViewVars().copyWith(scouterName: always(scouterName));

  InputViewVars copyWith({
    final bool Function()? isRematch,
    final ScheduleMatch? Function()? scheduleMatch,
    final String? Function()? scouterName,
    final RobotFieldStatus Function()? robotFieldStatus,
    final Climb Function()? climb,
    final int Function()? upperHubAuto,
    final int Function()? lowerHubAuto,
    final int Function()? upperHubTele,
    final int Function()? lowerHubTele,
    final int Function()? upperHubMissedAuto,
    final int Function()? lowerHubMissedAuto,
    final int Function()? upperHubMissedTele,
    final int Function()? lowerHubMissedTele,
    final bool Function()? leftTarmac,
    final LightTeam? Function()? scoutedTeam,
    final String? Function()? faultMessage,
  }) =>
      InputViewVars.all(
        faultMessage: faultMessage != null ? faultMessage() : this.faultMessage,
        isRematch: isRematch != null ? isRematch() : this.isRematch,
        scheduleMatch:
            scheduleMatch != null ? scheduleMatch() : this.scheduleMatch,
        scouterName: scouterName != null ? scouterName() : this.scouterName,
        robotFieldStatus: robotFieldStatus != null
            ? robotFieldStatus()
            : this.robotFieldStatus,
        climb: climb != null ? climb() : this.climb,
        upperHubAuto: upperHubAuto != null ? upperHubAuto() : this.upperHubAuto,
        lowerHubAuto: lowerHubAuto != null ? lowerHubAuto() : this.lowerHubAuto,
        upperHubTele: upperHubTele != null ? upperHubTele() : this.upperHubTele,
        lowerHubTele: lowerHubTele != null ? lowerHubTele() : this.lowerHubTele,
        upperHubMissedAuto: upperHubMissedAuto != null
            ? upperHubMissedAuto()
            : this.upperHubMissedAuto,
        lowerHubMissedAuto: lowerHubMissedAuto != null
            ? lowerHubMissedAuto()
            : this.lowerHubMissedAuto,
        upperHubMissedTele: upperHubMissedTele != null
            ? upperHubMissedTele()
            : this.upperHubMissedTele,
        lowerHubMissedTele: lowerHubMissedTele != null
            ? lowerHubMissedTele()
            : this.lowerHubMissedTele,
        leftTarmac: leftTarmac != null ? leftTarmac() : this.leftTarmac,
        scoutedTeam: scoutedTeam != null ? scoutedTeam() : this.scoutedTeam,
      );

  final bool isRematch;
  final ScheduleMatch? scheduleMatch;
  final String? scouterName;
  final RobotFieldStatus robotFieldStatus;
  final Climb? climb;
  final int upperHubTele;
  final int lowerHubTele;
  final int upperHubAuto;
  final int lowerHubAuto;
  final int upperHubMissedTele;
  final int lowerHubMissedTele;
  final int upperHubMissedAuto;
  final int lowerHubMissedAuto;
  final bool leftTarmac;
  final LightTeam? scoutedTeam;
  final String? faultMessage;

  @override
  Map<String, dynamic> toJson(final BuildContext context) => <String, dynamic>{
        if (faultMessage != null) "fault_message": faultMessage,
        "team_id": scoutedTeam?.id,
        "scouter_name": scouterName,
        "schedule_id": scheduleMatch?.id,
        "robot_field_status_id":
            IdProvider.of(context).robotFieldStatus.enumToId[robotFieldStatus]!,
        "is_rematch": isRematch,
        "climb_id": IdProvider.of(context).climb.enumToId[climb]!,
        "upper_hub_auto": upperHubAuto,
        "lower_hub_auto": lowerHubAuto,
        "upper_hub_tele": upperHubTele,
        "lower_hub_tele": lowerHubTele,
        "upper_hub_missed_auto": upperHubMissedAuto,
        "lower_hub_missed_auto": lowerHubMissedAuto,
        "upper_hub_missed_tele": upperHubMissedTele,
        "lower_hub_missed_tele": lowerHubMissedTele,
        "left_tarmac": leftTarmac,
      };
}
