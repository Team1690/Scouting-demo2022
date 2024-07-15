import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/team_info_models/quick_data.dart";

extension CardGetters on TeamData {
  QuickData get quickData => QuickData(
        avgData: aggregateData.avgData,
        maxData: aggregateData.maxData,
        minData: aggregateData.minData,
        amoutOfMatches: aggregateData.gamesPlayed,
        firstPicklistIndex: firstPicklistIndex,
        secondPicklistIndex: secondPicklistIndex,
        thirdPicklistIndex: thirdPicklistIndex,
        matchesClimbedFirst: matchesClimbedFirst,
        matchesClimbedSecond: matchesClimbedSecond,
        matchesClimbedThird: matchesClimbedThird,
        climbPercentage: climbPercentage,
      );
}
