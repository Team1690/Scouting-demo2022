import "package:scouting_frontend/models/enums/drive_motor_enum.dart";
import "package:scouting_frontend/models/enums/drive_train_enum.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
class PitData {
  const PitData({
    required this.length,
    required this.width,
    required this.driveTrainType,
    required this.driveMotorType,
    required this.notes,
    required this.weight,
    required this.url,
    required this.canReachUpper,
    required this.canReachLower,
    required this.faultMessages,
    required this.team,
    required this.canStore,
    required this.farShooting,
    required this.climbType,
  });

  final DriveTrain driveTrainType;
  final DriveMotor driveMotorType;
  final String notes;
  final double weight;
  final double length;
  final double width;
  final String url;
  final bool canReachUpper; 
  final bool canReachLower; 
  final List<String>? faultMessages;
  final LightTeam team;
  final int canStore;
  final bool farShooting;
  final Climb climbType;

  static PitData? parse(final dynamic pit, final IdProvider idProvider) =>
      pit != null
          ? PitData(
              driveTrainType: idProvider
                  .driveTrain.idToEnum[pit["drivetrain"]["id"] as int]!,
              driveMotorType: idProvider
                  .drivemotor.idToEnum[pit["drivemotor"]["id"] as int]!,
              notes: pit["notes"] as String,
              url: pit["url"] as String,
              faultMessages: (pit["team"]["faults"] as List<dynamic>)
                  .map((final dynamic fault) => fault["message"] as String)
                  .toList(),
              weight: (pit["weight"] as num).toDouble(),
              length: (pit["length"] as num).toDouble(),
              width: (pit["width"] as num).toDouble(),
              team: LightTeam.fromJson(pit["team"]), 
              canReachUpper: pit["can_reach_upper"] as bool, 
              canReachLower: pit["can_reach_lower"] as bool, 
              canStore: pit["can_store"] as int, 
              farShooting: pit["far_shooting"] as bool, 
              climbType: idProvider
                  .climb.idToEnum[pit["climb"]["id"] as int]!,
            )
          : null;
}
