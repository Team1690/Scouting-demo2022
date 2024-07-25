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
    technical_matches(where: {ignored: {_eq: false}, is_rematch: {}, left_tarmac: {}, lower_hub_auto: {}, lower_hub_missed_auto: {}, lower_hub_missed_tele: {}, lower_hub_tele: {}, robot_field_status_id: {}, upper_hub_auto: {}, upper_hub_missed_auto: {}, upper_hub_missed_tele: {}, upper_hub_tele: {}}, order_by: [{schedule_match: {match_type: {order: asc}}}, {schedule_match: {match_number: asc}}, {is_rematch: asc}]) {
      schedule_match {
        id
        match_type {
          id
        }
        match_number
        id
      }
      is_rematch
      climb {
        id
        points
        title
      }
      robot_field_status_id
      scouter_name
      id
      lower_hub_tele
      lower_hub_missed_tele
      lower_hub_missed_auto
      lower_hub_auto
      left_tarmac
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
      drivemotor_id
      drivetrain_id
      weight
      length
      width
      url
      can_climb_to_id
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
