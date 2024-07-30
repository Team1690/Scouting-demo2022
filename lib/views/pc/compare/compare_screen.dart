// import "dart:collection";
// import "package:carousel_slider/carousel_slider.dart";
// import "package:flutter/material.dart";
// import "package:orbit_standard_library/orbit_standard_library.dart";
// import "package:scouting_frontend/models/team_model.dart";
// import "package:scouting_frontend/models/fetch_functions/fetch_teams.dart";
// import "package:scouting_frontend/models/data/team_data/team_data.dart";
// import "package:scouting_frontend/views/common/team_selection_future.dart";
// import "package:scouting_frontend/views/constants.dart";
// import "package:scouting_frontend/views/common/card.dart";
// import "package:scouting_frontend/views/mobile/side_nav_bar.dart";
// import "package:scouting_frontend/views/pc/compare/widgets/lineChart/compare_gamechart_card.dart";
// import "package:scouting_frontend/views/pc/compare/widgets/spiderChart/spider_chart_card.dart";
// import "package:scouting_frontend/views/common/dashboard_scaffold.dart";
// import "package:scouting_frontend/models/providers/team_provider.dart";

// class CompareScreen extends StatefulWidget {
//   CompareScreen([this.initialTeams = const <LightTeam>[]]);
//   final List<LightTeam> initialTeams;
//   @override
//   State<CompareScreen> createState() => _CompareScreenState();
// }

// class _CompareScreenState extends State<CompareScreen> {
//   late final SplayTreeSet<LightTeam> teams = SplayTreeSet<LightTeam>(
//     (final LightTeam team1, final LightTeam team2) =>
//         team1.number.compareTo(team2.number),
//   )..addAll(widget.initialTeams);
//   final TextEditingController controller = TextEditingController();
//   void removeTeam(final MapEntry<int, LightTeam> index) {
//     teams.removeWhere(
//       (final LightTeam entry) => entry.number == index.value.number,
//     );
//     controller.value = TextEditingValue.empty;
//   }

//   @override
//   Widget build(final BuildContext context) => isPC(context)
//       ? DashboardScaffold(
//           body: compareScreen(context),
//         )
//       : Scaffold(
//           resizeToAvoidBottomInset: false,
//           appBar: AppBar(
//             title: const Text("Compare"),
//             centerTitle: true,
//           ),
//           drawer: SideNavBar(),
//           body: compareScreen(context),
//         );

//   Padding compareScreen(final BuildContext context) => Padding(
//         padding: const EdgeInsets.all(defaultPadding),
//         child: Column(
//           children: <Widget>[
//             Container(
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                     flex: isPC(context) ? 1 : 2,
//                     child: TeamSelectionFuture(
//                       teams: TeamProvider.of(context).teams
//                         ..removeWhere(teams.contains),
//                       onChange: (final LightTeam team) {
//                         if (teams.contains(team)) return;
//                         setState(() {
//                           teams.add(
//                             team,
//                           );
//                         });
//                       },
//                       controller: controller,
//                     ),
//                   ),
//                   const SizedBox(width: defaultPadding),
//                   Expanded(
//                     flex: 2,
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       primary: false,
//                       child: Row(
//                         children: List<Padding>.generate(
//                           teams.length,
//                           (final int index) => Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: defaultPadding / 2,
//                             ),
//                             child: Chip(
//                               label: Text(
//                                 teams.elementAt(index).number.toString(),
//                               ),
//                               backgroundColor: teams.elementAt(index).color,
//                               onDeleted: () => setState(
//                                 () => teams.remove(
//                                   teams.elementAt(index),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: defaultPadding),
//             Expanded(
//               flex: 5,
//               child: StreamBuilder<SplayTreeSet<TeamData>>(
//                 stream: teams.isEmpty
//                     ? Stream<SplayTreeSet<TeamData>>.fromFuture(
//                         Future<SplayTreeSet<TeamData>>(
//                           SplayTreeSet.new,
//                         ),
//                       )
//                     : fetchMultipleTeamData(
//                         teams.map((final LightTeam e) => e.id).toList(),
//                         context,
//                       ),
//                 builder: (
//                   final BuildContext context,
//                   final AsyncSnapshot<SplayTreeSet<TeamData>?> snapshot,
//                 ) {
//                   if (snapshot.hasError) {
//                     return Text(snapshot.error!.toString());
//                   }
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     if (isPC(context)) {
//                       return Center(
//                         child: Row(
//                           children: <Widget>[
//                             const Expanded(
//                               flex: 4,
//                               child: DashboardCard(
//                                 title: "Gamechart",
//                                 body: Center(
//                                   child: CircularProgressIndicator(),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               width: defaultPadding,
//                             ),
//                             Expanded(
//                               flex: 3,
//                               child: DashboardCard(
//                                 title: "Spiderchart",
//                                 body: Container(),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     } else {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                   }

//                   return snapshot.data
//                           .mapNullable((final SplayTreeSet<TeamData> data) {
//                         if (isPC(context)) {
//                           // return Row(
//                           // children: <Widget>[
//                           //   Expanded(
//                           //     flex: 4,
//                           //     child: CompareGamechartCard(data, teams),
//                           //   ),
//                           //   const SizedBox(width: defaultPadding),
//                           //   Expanded(
//                           //     flex: 3,
//                           //     child: SpiderChartCard(teams, data),
//                           //   ),
//                           // ],
//                           // );
//                         } else {
//                           return CarouselSlider(
//                             items: <Widget>[
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 8),
//                                 child: CompareGamechartCard(data, teams),
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 8),
//                                 child: SpiderChartCard(teams, data),
//                               ),
//                             ],
//                             options: CarouselOptions(
//                               height: 3500,
//                               aspectRatio: 2.0,
//                               viewportFraction: 1,
//                             ),
//                           );
//                         }
//                       }) ??
//                       (throw Exception("No data"));
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
// }
