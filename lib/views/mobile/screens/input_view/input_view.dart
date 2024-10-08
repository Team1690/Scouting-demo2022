import "dart:async";
import "package:flutter/material.dart";
import "package:scouting_frontend/models/enums/match_mode_enum.dart";
import "package:scouting_frontend/models/enums/robot_field_status.dart";
import "package:scouting_frontend/models/providers/shifts_provider.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/input_view_vars.dart";
import "package:scouting_frontend/models/schedule_match.dart";
import "package:scouting_frontend/models/team_model.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/widgets/autonomous_selector.dart";
import "package:scouting_frontend/views/mobile/submit_buttons/shared_preferences/local_save_button.dart";
import "package:scouting_frontend/views/mobile/submit_buttons/shared_preferences/manage_preferences.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/widgets/climbing.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/widgets/game_piece_counter.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/widgets/trap_amount.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/widgets/traps_missed.dart";
import "package:scouting_frontend/views/mobile/screens/robot_image.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/scouter_name_input.dart";
import "package:scouting_frontend/views/mobile/side_nav_bar.dart";
import "package:scouting_frontend/views/mobile/counter.dart";
import "package:scouting_frontend/views/mobile/section_divider.dart";
import "package:scouting_frontend/views/mobile/submit_buttons/submit/submit_button.dart";
import "package:scouting_frontend/views/mobile/team_and_match_selection.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";

class UserInput extends StatefulWidget {
  const UserInput([this.initialVars]);
  final InputViewVars? initialVars;
  @override
  State<UserInput> createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  void flickerScreen(final int newValue, final int oldValue) {
    if (!toggleLightsState) return;
    screenColor = oldValue > newValue
        ? Colors.red
        : oldValue < newValue
            ? Colors.green
            : null;

    Timer(const Duration(milliseconds: 10), () {
      setState(() {
        screenColor = null;
      });
    });
  }

  Color? screenColor;

  final TextEditingController matchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<FormState> jsonFormKey = GlobalKey();
  final TextEditingController teamNumberController = TextEditingController();
  final TextEditingController scouterNameController = TextEditingController();
  final TextEditingController faultMessageController = TextEditingController();
  bool toggleLightsState = false;
  late InputViewVars match = InputViewVars();
  // -1 means nothing
  late final Map<int, RobotFieldStatus> robotFieldStatusIndexToEnum =
      <int, RobotFieldStatus>{
    -1: RobotFieldStatus.worked,
    0: RobotFieldStatus.didntComeToField,
    1: RobotFieldStatus.didntWorkOnField,
    2: RobotFieldStatus.didDefense,
  };

  final bool initialFlag = false;
  bool isRedAlliance = true;

  void updateTextFields() {
    matchController.text =
        "${match.scheduleMatch!.matchIdentifier.type.title} ${match.scheduleMatch!.matchIdentifier.number}";
    teamNumberController.text = <String>[
      "Practice",
      "Pre scouting",
    ].contains(match.scheduleMatch!.matchIdentifier.type.title)
        ? "${match.scoutedTeam!.number} ${match.scoutedTeam!.name}"
        : match.scheduleMatch!.getTeamStation(
            match.scoutedTeam!,
            ShiftProvider.of(context).shifts,
          );
    scouterNameController.text = match.scouterName!;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.initialVars != null) {
        match = widget.initialVars!;
        updateTextFields();
      }
    });
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: isPC(context) ? null : SideNavBar(),
        appBar: AppBar(
          actions: <Widget>[
            RobotImageButton(teamId: () => match.scoutedTeam?.id),
            ToggleButtons(
              children: const <Icon>[Icon(Icons.lightbulb)],
              isSelected: <bool>[toggleLightsState],
              onPressed: (final int i) {
                setState(() {
                  toggleLightsState = !toggleLightsState;
                });
              },
              renderBorder: false,
            ),
            IconButton(
              onPressed: () async {
                (await showDialog(
                  context: context,
                  builder: (final BuildContext dialogContext) =>
                      ManagePreferences(
                    mutation: widget.initialVars == null
                        ? insertMutation(match.faultMessage != null)
                        : updateMutation,
                  ),
                ));
              },
              icon: const Icon(Icons.storage_rounded),
            ),
          ],
          centerTitle: true,
          elevation: 5,
          title: const Text(
            "Orbit Scouting",
          ),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    children: <Widget>[
                      ScouterNameInput(
                        onScouterNameChange: (final String scouterName) {
                          setState(() {
                            match = match.copyWith(
                              scouterName: always(scouterName),
                            );
                          });
                        },
                        scouterNameController: scouterNameController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TeamAndMatchSelection(
                        scouter: match.scouterName,
                        matchController: matchController,
                        teamNumberController: teamNumberController,
                        onChange: (
                          final ScheduleMatch selectedMatch,
                          final LightTeam? team,
                        ) {
                          setState(() {
                            match = match.copyWith(
                              scheduleMatch: always(selectedMatch),
                              scoutedTeam: always(team),
                            );
                          });
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ToggleButtons(
                        fillColor: const Color.fromARGB(10, 244, 67, 54),
                        selectedColor: Colors.red,
                        selectedBorderColor: Colors.red,
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Rematch"),
                          ),
                        ],
                        isSelected: <bool>[match.isRematch],
                        onPressed: (final int i) {
                          setState(() {
                            match = match.copyWith(
                              isRematch: always(!match.isRematch),
                            );
                          });
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SectionDivider(label: "Autonomous"),
                      MatchModeGamePieceCounter(
                        flickerScreen: flickerScreen,
                        match: match,
                        onNewMatch: (final InputViewVars match) {
                          setState(() {
                            this.match = match;
                          });
                        },
                        matchMode: MatchMode.auto,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SectionDivider(label: "Teleoperated"),
                      MatchModeGamePieceCounter(
                        flickerScreen: flickerScreen,
                        match: match,
                        onNewMatch: (final InputViewVars match) {
                          setState(() {
                            this.match = match;
                          });
                        },
                        matchMode: MatchMode.tele,
                      ),
                      Climbing(
                        match: match,
                        onNewMatch: (final InputViewVars newMatch) {
                          setState(() {
                            match = newMatch;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SectionDivider(label: "Robot Status"),
                      Switcher(
                        borderRadiusGeometry: defaultBorderRadius,
                        labels: const <String>[
                          "Not on field",
                          "Didn't work on field",
                          "Did Defense",
                        ],
                        colors: <Color>[
                          RobotFieldStatus.didntComeToField.color,
                          RobotFieldStatus.didntWorkOnField.color,
                          RobotFieldStatus.didDefense.color,
                        ],
                        onChange: (final int i) {
                          setState(() {
                            match = match.copyWith(
                              robotFieldStatus: always(
                                robotFieldStatusIndexToEnum[i]!,
                              ),
                            );
                            if (match.robotFieldStatus ==
                                RobotFieldStatus.didntWorkOnField) {
                              match = match.copyWith(
                                faultMessage: always("Didn't work on field"),
                              );
                              faultMessageController.text = match.faultMessage!;
                            }
                          });
                        },
                        selected: <RobotFieldStatus, int>{
                          for (final MapEntry<int, RobotFieldStatus> i
                              in robotFieldStatusIndexToEnum.entries)
                            i.value: i.key,
                        }[match.robotFieldStatus]!,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ToggleButtons(
                        fillColor: const Color.fromARGB(10, 244, 67, 54),
                        focusColor: const Color.fromARGB(170, 244, 67, 54),
                        highlightColor: const Color.fromARGB(170, 244, 67, 54),
                        selectedBorderColor:
                            const Color.fromARGB(170, 244, 67, 54),
                        selectedColor: Colors.red,
                        children: const <Widget>[
                          Icon(
                            Icons.cancel,
                          ),
                        ],
                        isSelected: <bool>[
                          match.faultMessage != null,
                        ],
                        onPressed: (final int index) {
                          assert(index == 0);
                          setState(() {
                            match = match.copyWith(
                              faultMessage: always(
                                match.faultMessage.onNull(
                                  "\"יש לרובוט בעיה (technical scouting)\"",
                                ),
                              ),
                            );

                            faultMessageController.text =
                                match.faultMessage ?? "";
                          });
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        crossFadeState: match.faultMessage != null
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: Container(),
                        secondChild: TextField(
                          controller: faultMessageController,
                          textDirection: TextDirection.rtl,
                          onTap: faultMessageController.clear,
                          onChanged: (final String value) {
                            setState(() {
                              match = match.copyWith(
                                faultMessage: always(value),
                              );
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: "Robot fault",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SubmitButton(
                        resetForm: () {
                          setState(() {
                            match = match.cleared();
                            teamNumberController.clear();
                            matchController.clear();
                            faultMessageController.clear();
                            isRedAlliance = false;
                          });
                        },
                        validate: () => formKey.currentState!.validate(),
                        getJson: match.toJson,
                        mutation: widget.initialVars == null
                            ? insertMutation(match.faultMessage != null)
                            : updateMutation,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      LocalSaveButton(
                        vars: match,
                        mutation: widget.initialVars == null
                            ? insertMutation(match.faultMessage != null)
                            : updateMutation,
                        resetForm: () {
                          setState(() {
                            match = match.cleared();
                            teamNumberController.clear();
                            matchController.clear();
                            faultMessageController.clear();
                            isRedAlliance = false;
                          });
                        },
                        validate: () => formKey.currentState!.validate(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (screenColor != null)
              Container(
                color: screenColor,
              ),
          ],
        ),
      );

  String insertMutation(final bool hasFault) => """
mutation MyMutation(\$climb_id: Int!, \$is_rematch: Boolean!, \$robot_field_status_id: Int, \$schedule_id: Int!, \$team_id: Int!, \$scouter_name: String!, \$left_tarmac: Boolean = false, \$lower_hub_auto: Int = "", \$lower_hub_missed_auto: Int = 10, \$lower_hub_missed_tele: Int = 10, \$lower_hub_tele: Int = 10, \$upper_hub_auto: Int = 10, \$upper_hub_missed_auto: Int = 10, \$upper_hub_missed_tele: Int = 10, \$upper_hub_tele: Int = 10) {
  insert_technical_match(objects: {climb_id: \$climb_id, is_rematch: \$is_rematch, robot_field_status_id: \$robot_field_status_id, schedule_id: \$schedule_id, team_id: \$team_id, scouter_name: \$scouter_name, left_tarmac: \$left_tarmac, lower_hub_auto: \$lower_hub_auto, lower_hub_missed_auto: \$lower_hub_missed_auto, lower_hub_missed_tele: \$lower_hub_missed_tele, lower_hub_tele: \$lower_hub_tele, upper_hub_auto: \$upper_hub_auto, upper_hub_missed_auto: \$upper_hub_missed_auto, upper_hub_missed_tele: \$upper_hub_missed_tele, upper_hub_tele: \$upper_hub_tele}) {
    affected_rows
  }
  ${!hasFault ? "" : """
insert_faults(objects: {team_id: \$team_id, schedule_match_id: \$schedule_id, fault_status_id: 1, is_rematch: \$is_rematch, message: \$fault_message}) {
    affected_rows
  }
  """}
}

""";

  String updateMutation = """
mutation MyMutation(\$climb_id: Int!, \$is_rematch: Boolean!, \$robot_field_status_id: Int!, \$schedule_id: Int!, \$team_id: Int!, \$scouter_name: String!, \$left_tarmac: Boolean!, \$lower_hub_auto: Int!, \$lower_hub_missed_auto: Int!, \$lower_hub_missed_tele: Int!, \$lower_hub_tele: Int!, \$upper_hub_tele: Int!, \$upper_hub_missed_tele: Int!, \$upper_hub_missed_auto: Int!, \$upper_hub_auto: Int!) {
  update_technical_match(where: {team_id: {_eq: \$team_id}, schedule_id: {_eq: \$schedule_id}, is_rematch: {_eq: \$is_rematch}}, _set: {climb_id: \$climb_id, is_rematch: \$is_rematch, robot_field_status_id: \$robot_field_status_id, schedule_id: \$schedule_id, team_id: \$team_id, scouter_name: \$scouter_name, left_tarmac: \$left_tarmac, lower_hub_auto: \$lower_hub_auto, lower_hub_missed_auto: \$lower_hub_missed_auto, lower_hub_missed_tele: \$lower_hub_missed_tele, lower_hub_tele: \$lower_hub_tele, upper_hub_auto: \$upper_hub_auto, upper_hub_missed_tele: \$upper_hub_missed_tele, upper_hub_tele: \$upper_hub_tele, upper_hub_missed_auto: \$upper_hub_missed_auto}) {
    affected_rows
  }
}

""";
}
