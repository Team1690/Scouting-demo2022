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
        delivery = 0,
        teleAmp = 0,
        teleAmpMissed = 0,
        teleSpeaker = 0,
        teleSpeakerMissed = 0,
        autoAmp = 0,
        autoAmpMissed = 0,
        autoSpeaker = 0,
        autoSpeakerMissed = 0,
        climb = null,
        harmonyWith = 0,
        trapAmount = 0,
        trapsMissed = 0,
        scoutedTeam = null,
        faultMessage = null,
        autonomousOptions = null;
  InputViewVars.all({
    required this.faultMessage,
    required this.delivery,
    required this.trapsMissed,
    required this.isRematch,
    required this.scheduleMatch,
    required this.scouterName,
    required this.robotFieldStatus,
    required this.teleAmp,
    required this.teleAmpMissed,
    required this.teleSpeaker,
    required this.teleSpeakerMissed,
    required this.autoAmp,
    required this.autoAmpMissed,
    required this.autoSpeaker,
    required this.autoSpeakerMissed,
    required this.climb,
    required this.harmonyWith,
    required this.trapAmount,
    required this.scoutedTeam,
    required this.autonomousOptions,
  });

  InputViewVars cleared() =>
      InputViewVars().copyWith(scouterName: always(scouterName));

  InputViewVars copyWith({
    final bool Function()? isRematch,
    final ScheduleMatch? Function()? scheduleMatch,
    final String? Function()? scouterName,
    final RobotFieldStatus Function()? robotFieldStatus,
    final int Function()? teleAmp,
    final int Function()? teleAmpMissed,
    final int Function()? teleSpeaker,
    final int Function()? teleSpeakerMissed,
    final int Function()? autoAmp,
    final int Function()? autoAmpMissed,
    final int Function()? autoSpeaker,
    final int Function()? autoSpeakerMissed,
    final Climb Function()? climb,
    final int Function()? harmonyWith,
    final int Function()? trapAmount,
    final int Function()? trapsMissed,
    final LightTeam? Function()? scoutedTeam,
    final int Function()? delivery,
    final String? Function()? faultMessage,
    final AutonomousOptions Function()? autonomousOptions,
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
        teleAmp: teleAmp != null ? teleAmp() : this.teleAmp,
        teleAmpMissed:
            teleAmpMissed != null ? teleAmpMissed() : this.teleAmpMissed,
        teleSpeaker: teleSpeaker != null ? teleSpeaker() : this.teleSpeaker,
        teleSpeakerMissed: teleSpeakerMissed != null
            ? teleSpeakerMissed()
            : this.teleSpeakerMissed,
        autoAmp: autoAmp != null ? autoAmp() : this.autoAmp,
        autoAmpMissed:
            autoAmpMissed != null ? autoAmpMissed() : this.autoAmpMissed,
        autoSpeaker: autoSpeaker != null ? autoSpeaker() : this.autoSpeaker,
        autoSpeakerMissed: autoSpeakerMissed != null
            ? autoSpeakerMissed()
            : this.autoSpeakerMissed,
        climb: climb != null ? climb() : this.climb,
        harmonyWith: harmonyWith != null ? harmonyWith() : this.harmonyWith,
        trapAmount: trapAmount != null ? trapAmount() : this.trapAmount,
        trapsMissed: trapsMissed != null ? trapsMissed() : this.trapsMissed,
        scoutedTeam: scoutedTeam != null ? scoutedTeam() : this.scoutedTeam,
        delivery: delivery != null ? delivery() : this.delivery,
        autonomousOptions: autonomousOptions != null
            ? autonomousOptions()
            : this.autonomousOptions,
      );

  final int delivery;
  final bool isRematch;
  final ScheduleMatch? scheduleMatch;
  final String? scouterName;
  final RobotFieldStatus robotFieldStatus;
  final int teleAmp;
  final int teleAmpMissed;
  final int teleSpeaker;
  final int teleSpeakerMissed;
  final int autoAmp;
  final int autoAmpMissed;
  final int autoSpeaker;
  final int autoSpeakerMissed;
  final Climb? climb;
  final int harmonyWith;
  final int trapAmount;
  final int trapsMissed;
  final LightTeam? scoutedTeam;
  final String? faultMessage;
  final AutonomousOptions? autonomousOptions;

  @override
  Map<String, dynamic> toJson(final BuildContext context) => <String, dynamic>{
        if (faultMessage != null) "fault_message": faultMessage,
        "team_id": scoutedTeam?.id,
        "scouter_name": scouterName,
        "schedule_id": scheduleMatch?.id,
        "robot_field_status_id":
            IdProvider.of(context).robotFieldStatus.enumToId[robotFieldStatus]!,
        "is_rematch": isRematch,
        "tele_amp": teleAmp,
        "tele_amp_missed": teleAmpMissed,
        "tele_speaker": teleSpeaker,
        "tele_speaker_missed": teleSpeakerMissed,
        "auto_amp": autoAmp,
        "auto_amp_missed": autoAmpMissed,
        "auto_speaker": autoSpeaker,
        "auto_speaker_missed": autoSpeakerMissed,
        "climb_id": IdProvider.of(context).climb.enumToId[climb]!,
        "harmony_with": harmonyWith,
        "trap_amount": trapAmount,
        "traps_missed": trapsMissed,
        "delivery": delivery,
        "autonomous_options_id":
            IdProvider.of(context).autoOptions.enumToId[autonomousOptions]!,
      };
}
