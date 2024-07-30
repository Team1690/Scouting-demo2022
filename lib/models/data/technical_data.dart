import "package:scouting_frontend/models/enums/point_giver_enum.dart";
import "package:scouting_frontend/utils/math_utils.dart";

class TechnicalData<T extends num> {
  TechnicalData({
    required this.upperHubAuto,
    required this.upperHubMissedAuto,
    required this.lowerHubAuto,
    required this.lowerHubMissedAuto,
    required this.upperHubTele,
    required this.upperHubMissedTele,
    required this.lowerHubTele,
    required this.lowerHubMissedTele,
    required this.leftTarmac,
    required this.climbId,
  });

  final T upperHubAuto;
  final T upperHubMissedAuto;
  final T lowerHubAuto;
  final T lowerHubMissedAuto;
  final T upperHubTele;
  final T upperHubMissedTele;
  final T lowerHubTele;
  final T lowerHubMissedTele;
  final T leftTarmac;
  final T climbId;

  T get upperHubGamepieces => upperHubAuto + upperHubTele as T;
  T get lowerHubGamepieces => lowerHubAuto + lowerHubTele as T;
  T get autoGamepieces => upperHubAuto + lowerHubAuto as T;
  T get teleGamepieces => upperHubTele + lowerHubTele as T;
  T get totalGamepieces => upperHubGamepieces + lowerHubGamepieces as T;
  T get missedAuto => upperHubMissedAuto + lowerHubMissedAuto as T;
  T get missedTele => upperHubMissedTele + lowerHubMissedTele as T;
  T get missedUpperHub => upperHubMissedAuto + upperHubMissedTele as T;
  T get missedLowerHub => lowerHubMissedAuto + lowerHubMissedTele as T;
  T get totalMissed => missedAuto + missedTele as T;

  //Points:
  T get autoUpperHubPoints =>
      PointGiver.upperHubAuto.points * upperHubAuto as T;
  T get autoLowerHubPoints =>
      PointGiver.lowerHubAuto.points * lowerHubAuto as T;
  T get autoPoints => autoUpperHubPoints + autoLowerHubPoints as T;
  T get teleUpperHubPoints =>
      PointGiver.upperHubTele.points * upperHubTele as T;
  T get teleLowerHubPoints =>
      PointGiver.lowerHubTele.points * lowerHubTele as T;
  T get telePoints => teleUpperHubPoints + teleLowerHubPoints as T;
  T get leftTarmacPoints => PointGiver.leftTarmac.points * leftTarmac as T;
  // T get climbPoints => PointGiver.climbId.points * climbId as T;
  T get totalPoints => autoPoints + telePoints + leftTarmacPoints
      as T; //No climb :P (later we'll climbId -> points)

  static TechnicalData<T> parse<T extends num>(
    final dynamic table,
  ) =>
      TechnicalData<T>(
        upperHubAuto: (table["upper_hub_auto"] as num? ?? 0).numericCast(),
        upperHubMissedAuto:
            (table["upper_hub_missed_auto"] as num? ?? 0).numericCast(),
        lowerHubAuto: (table["lower_hub_auto"] as num? ?? 0).numericCast(),
        lowerHubMissedAuto:
            (table["lower_hub_missed_auto"] as num? ?? 0).numericCast(),
        upperHubTele: (table["upper_hub_tele"] as num? ?? 0).numericCast(),
        upperHubMissedTele:
            (table["upper_hub_missed_tele"] as num? ?? 0).numericCast(),
        lowerHubTele: (table["lower_hub_tele"] as num? ?? 0).numericCast(),
        lowerHubMissedTele:
            (table["lower_hub_missed_tele"] as num? ?? 0).numericCast(),
        leftTarmac: (table["left_tarmac"] as num? ?? 0).numericCast(),
        climbId: (table["climb_id"] as num? ?? 0).numericCast(),
      );
}
