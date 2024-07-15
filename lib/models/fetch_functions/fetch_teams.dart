import "dart:async";
import "dart:collection";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/enums/match_type_enum.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/models/providers/matches_provider.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/data/team_match_data.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/models/data/aggregate_data/aggregate_technical_data.dart";
import "package:scouting_frontend/models/data/team_data/team_data.dart";
import "package:scouting_frontend/models/data/technical_match_data.dart";
import "package:scouting_frontend/models/data/pit_data/pit_data.dart";
import "package:scouting_frontend/views/mobile/screens/fault_view/fault_entry.dart";

const String query = """
subscription FetchTeams(\$ids: [Int!]) {
  team(where: {id: {_in: \$ids}}) {
    specific_matches {
      schedule_match {
        id
        match_type {
          id
        }
        match_number
        happened
      }
      is_rematch
      defense_rating
      driving_rating
      general_rating
      intake_rating
      speaker_rating
      climb_rating
      amp_rating
      scouter_name
      id
    }
    technical_matches(where: {ignored: {_eq: false}}, order_by: [{schedule_match: {match_type: {order: asc}}}, {schedule_match: {match_number: asc}}, {is_rematch: asc}]) {
      schedule_match {
        id
        match_type {
          id
        }
        match_number
        happened
        id
      }
      is_rematch
      tele_amp
      tele_amp_missed
      tele_speaker
      tele_speaker_missed
      auto_amp
      auto_amp_missed
      auto_speaker
      auto_speaker_missed
      trap_amount
      traps_missed
      delivery
      climb {
        id
        points
        title
      }
      robot_field_status {
        id
      }
      autonomous_options {
        id
      }
      harmony_with
      scouter_name
      id
    }
    name
    number
    id
    colors_index
    first_picklist_index
    second_picklist_index
    third_picklist_index
    faults {
      is_rematch
      message
      fault_status {
        id
      }
      schedule_match_id
      schedule_match {
        id
        match_number
        match_type {
          id
        }
        happened
      }
      id
      team {
        name
        number
        id
        colors_index
      }
    }
    pit {
      drivemotor {
        id
      }
      drivetrain {
        id
      }
      harmony
      notes
      trap
      weight
      length
      width
      url
      can_eject
      climb
      shooting_range_id
      can_pass_under_stage
      team {
        faults {
          message
        }
        name
        number
        id
        colors_index
      }
    }
    specific_summary {
      amp_text
      climb_text
      driving_text
      general_text
      intake_text
      speaker_text
      defense_text
    }
  }
}
""";

Stream<SplayTreeSet<TeamData>> fetchMultipleTeamData(
  final List<int> ids,
  final BuildContext context,
) {
  final GraphQLClient client = getClient();

  final Stream<QueryResult<SplayTreeSet<TeamData>>> result = client.subscribe(
    SubscriptionOptions<SplayTreeSet<TeamData>>(
      cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
      parserFn: (final Map<String, dynamic> teams) =>
          SplayTreeSet<TeamData>.from(
        (teams["team"] as List<dynamic>)
            .map<TeamData>((final dynamic teamTable) {
          final LightTeam team = LightTeam.fromJson(teamTable);
          final List<ScheduleMatch> matches = MatchesProvider.of(context)
              .matches
              .where(
                (final ScheduleMatch element) =>
                    element.blueAlliance.contains(team) ||
                    element.redAlliance.contains(team) ||
                    element.matchIdentifier.type == MatchType.practice ||
                    element.matchIdentifier.type == MatchType.pre,
              )
              .toList();

          final int firstPicklistIndex =
              teamTable["first_picklist_index"] as int;
          final int secondPicklistIndex =
              teamTable["second_picklist_index"] as int;
          final int thirdPicklistIndex =
              teamTable["third_picklist_index"] as int;
          final IdProvider idProvider = IdProvider.of(context);

          final List<TechnicalMatchData> technicalMatches =
              (teamTable["technical_matches"] as List<dynamic>)
                  .map(
                    (final dynamic match) => TechnicalMatchData.parse(
                      match,
                      idProvider,
                    ),
                  )
                  .toList();

          final dynamic pitTable = teamTable["pit"];
          final List<dynamic> faultTable = teamTable["faults"] as List<dynamic>;

          return TeamData(
            aggregateData: AggregateData.fromTechnicalData(
              technicalMatches
                  .map((final TechnicalMatchData e) => e.data)
                  .toList(),
            ),
            pitData: PitData.parse(pitTable, idProvider),
            faultEntrys: faultTable
                .map(
                  (final dynamic faultStatus) => FaultEntry.parse(
                    faultStatus,
                    idProvider,
                  ),
                )
                .toList(),
            lightTeam: team,
            firstPicklistIndex: firstPicklistIndex,
            secondPicklistIndex: secondPicklistIndex,
            thirdPicklistIndex: thirdPicklistIndex,
            matches: matches
                .map(
                  (final ScheduleMatch match) => MatchData(
                    technicalMatchData: technicalMatches.firstWhereOrNull(
                      (final TechnicalMatchData element) =>
                          match.matchIdentifier == element.matchIdentifier,
                    ),
                    scheduleMatch: match,
                    team: team,
                  ),
                )
                .toList(),
          );
        }),
        (final TeamData team1, final TeamData team2) =>
            team1.lightTeam.number.compareTo(team2.lightTeam.number),
      ),
      document: gql(query),
      variables: <String, dynamic>{
        "ids": ids,
      },
    ),
  );
  return result.map(
    (final QueryResult<SplayTreeSet<TeamData>> event) => event.mapQueryResult(),
  );
}
