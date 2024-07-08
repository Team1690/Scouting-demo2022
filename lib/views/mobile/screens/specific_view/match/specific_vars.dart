import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/mobile/hasura_vars.dart";

class SpecificVars implements HasuraVars {
  SpecificVars()
      : team = null,
        driveRating = null,
        intakeRating = null,
        speakerRating = null,
        ampRating = null,
        defenseRating = null,
        climbRating = null,
        generalRating = null,
        scheduleMatch = null,
        name = "",
        isRematch = false;

  SpecificVars.all({
    required this.team,
    required this.driveRating,
    required this.intakeRating,
    required this.speakerRating,
    required this.ampRating,
    required this.defenseRating,
    required this.climbRating,
    required this.generalRating,
    required this.scheduleMatch,
    required this.name,
    required this.isRematch,
  });

  SpecificVars copyWith({
    final LightTeam? Function()? team,
    final int? Function()? driveRating,
    final int? Function()? intakeRating,
    final int? Function()? speakerRating,
    final int? Function()? ampRating,
    final int? Function()? defenseRating,
    final int? Function()? climbRating,
    final int? Function()? generalRating,
    final ScheduleMatch? Function()? scheduleMatch,
    final String Function()? name,
    final bool Function()? isRematch,
  }) =>
      SpecificVars.all(
        team: team != null ? team() : this.team,
        driveRating: driveRating != null ? driveRating() : this.driveRating,
        intakeRating: intakeRating != null ? intakeRating() : this.intakeRating,
        speakerRating:
            speakerRating != null ? speakerRating() : this.speakerRating,
        ampRating: ampRating != null ? ampRating() : this.ampRating,
        defenseRating:
            defenseRating != null ? defenseRating() : this.defenseRating,
        climbRating: climbRating != null ? climbRating() : this.climbRating,
        generalRating:
            generalRating != null ? generalRating() : this.generalRating,
        scheduleMatch:
            scheduleMatch != null ? scheduleMatch() : this.scheduleMatch,
        name: name != null ? name() : this.name,
        isRematch: isRematch != null ? isRematch() : this.isRematch,
      );

  final LightTeam? team;
  final int? driveRating;
  final int? intakeRating;
  final int? speakerRating;
  final int? ampRating;
  final int? defenseRating;
  final int? climbRating;
  final int? generalRating;
  final ScheduleMatch? scheduleMatch;
  final String name;
  final bool isRematch;
  @override
  Map<String, dynamic> toJson(final BuildContext context) => <String, dynamic>{
        "team_id": team?.id,
        "driving_rating": driveRating,
        "intake_rating": intakeRating,
        "climb_rating": climbRating,
        "amp_rating": ampRating,
        "speaker_rating": speakerRating,
        "defense_rating": defenseRating,
        "general_rating": generalRating,
        "is_rematch": isRematch,
        "schedule_match_id": scheduleMatch?.id,
        "scouter_name": name,
      };

  SpecificVars reset(final BuildContext context) => copyWith(
        isRematch: always(false),
        scheduleMatch: always(null),
        team: always(null),
        driveRating: always(null),
        climbRating: always(null),
        intakeRating: always(null),
        ampRating: always(null),
        speakerRating: always(null),
        defenseRating: always(null),
        generalRating: always(null),
      );
}
