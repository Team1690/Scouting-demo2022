import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/models/enums/drive_motor_enum.dart";
import "package:scouting_frontend/models/enums/drive_train_enum.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/views/mobile/hasura_vars.dart";

class PitVars implements HasuraVars{
  PitVars(final BuildContext context):
        driveTrainType = null, 
        driveMotorType = null,
        notes = "",
        teamId = null,
        weight = null,
        url = null,
        canReachUpper = false,
        canReachLower = false,
        length = null,
        width = null,
        canStore = null,
        farShooting = false,
        climbType = null;

  PitVars.all({
        required this.length,
        required this.width,
        required this.driveTrainType,
        required this.driveMotorType,
        required this.notes,
        required this.weight,
        required this.url,
        required this.canReachUpper,
        required this.canReachLower,
        required this.teamId,
        required this.canStore,
        required this.farShooting,
        required this.climbType,
  });

  PitVars copyWith({
    final DriveTrain? Function()? driveTrainType,
    final DriveMotor? Function()? driveMotorType,
    final String Function()? notes,
    final int? Function()? teamId,
    final double? Function()? weight,
    final double? Function()? length,
    final double? Function()? width,
    final String? Function()? url,
    final bool? Function()? canReachUpper,
    final bool? Function()? canReachLower,
    final int? Function()? canStore,
    final bool? Function()? farShooting,
    final Climb? Function()? climbType,

  }) =>
      PitVars.all(
        driveTrainType:
            driveTrainType != null ? driveTrainType() : this.driveTrainType,
        driveMotorType:
            driveMotorType != null ? driveMotorType() : this.driveMotorType,
        notes: notes != null ? notes() : this.notes,
        teamId: teamId != null ? teamId() : this.teamId,
        weight: weight != null ? weight() : this.weight,
        length: length != null ? length() : this.length,
        width: width != null ? width() : this.width,
        url: url != null ? url() : this.url,
        canReachUpper: canReachUpper != null ? canReachUpper() : this.canReachUpper,
        canReachLower: canReachLower != null ? canReachLower() : this.canReachLower,
        canStore: canStore != null ? canStore() : this.canStore,
        farShooting: farShooting != null ? farShooting() : this.farShooting,
        climbType: climbType != null ? climbType() : this.climbType,

      );
  final DriveTrain? driveTrainType;
  final DriveMotor? driveMotorType;
  final String notes;
  final int? teamId;
  final double? weight;
  final double? length;
  final double? width;
  final bool? canReachUpper;
  final bool? canReachLower;
  final String? url;
  final int? canStore;
  final bool? farShooting;
  final Climb? climbType;

  @override
  Map<String, dynamic> toJson(final BuildContext context) => <String, dynamic>{
        "drivetrain_id":
            IdProvider.of(context).driveTrain.enumToId[driveTrainType]!,
        "drivemotor_id":
            IdProvider.of(context).drivemotor.enumToId[driveMotorType],
        "notes": notes,
        "team_id": teamId,
        "weight": weight,
        "length": length,
        "width": width,
        "url": url,
        "can_reach_upper": canReachUpper,
        "can_reach_lower": canReachLower,
        "can_climb_to_id": climbType,
        "can_store": canStore,
        "far_shooting": farShooting,
      };

  PitVars reset() => copyWith(
        driveTrainType: always(null),
        driveMotorType: always(null),
        notes: always(""),
        teamId: always(null),
        weight: always(null),
        length: always(null),
        width: always(null),
        url: always(null),
        canReachUpper: always(false),
        canReachLower: always(false),
        canStore: always(null),
        farShooting: always(false),
        climbType: always(null),
      );
}
