import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:scouting_frontend/models/data/pit_data/pit_data.dart";
import "package:scouting_frontend/models/data/technical_match_data.dart";
import "package:scouting_frontend/models/providers/id_providers.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/models/data/aggregate_data/aggregate_technical_data.dart";
import "package:scouting_frontend/models/data/all_team_data.dart";

const String subscription = """
subscription FetchAllTeams {
  team {
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

Stream<List<AllTeamData>> fetchAllTeams(final BuildContext context) =>
    getClient()
        .subscribe(
          SubscriptionOptions<List<AllTeamData>>(
            document: gql(subscription),
            parserFn: (final Map<String, dynamic> data) {
              final List<dynamic> teams = data["team"] as List<dynamic>;
              final IdProvider idProvider = IdProvider.of(context);
              return teams.map<AllTeamData>((final dynamic team) {
                final List<TechnicalMatchData> technicalMatches =
                    (team["technical_matches"] as List<dynamic>)
                        .map(
                          (final dynamic match) => TechnicalMatchData.parse(
                            match,
                            idProvider,
                          ),
                        )
                        .toList();
                final List<dynamic> faultTable =
                    (team["faults"] as List<dynamic>);
                final dynamic pitTable = team["pit"];

                return AllTeamData(
                  team: LightTeam.fromJson(team),
                  firstPicklistIndex: (team["first_picklist_index"] as int),
                  secondPicklistIndex: (team["second_picklist_index"] as int),
                  thirdPickListIndex: (team["third_picklist_index"] as int),
                  taken: team["taken"] as bool,
                  faultMessages: faultTable
                      .map((final dynamic fault) => fault["message"] as String)
                      .toList(),
                  aggregateData: AggregateData.fromTechnicalData(
                    technicalMatches
                        .map((final TechnicalMatchData e) => e.data)
                        .toList(),
                  ),
                  technicalMatches: technicalMatches,
                  pitData: PitData.parse(pitTable, idProvider),
                );
              }).toList();
            },
          ),
        )
        .map(
          (final QueryResult<List<AllTeamData>> event) =>
              event.mapQueryResult(),
        );
