import "package:flutter/material.dart";
import "package:scouting_frontend/views/common/card.dart";
import "package:scouting_frontend/models/data/all_team_data.dart";
import "package:scouting_frontend/views/constants.dart";
import "package:scouting_frontend/views/pc/picklist/auto_picklist_popup.dart";
import "package:scouting_frontend/views/pc/picklist/password.dart";
import "package:scouting_frontend/views/pc/picklist/pick_list_screen.dart";
import "package:scouting_frontend/views/pc/picklist/pick_list_widget.dart";

class PicklistCard extends StatefulWidget {
  PicklistCard({
    required this.initialData,
  });
  final List<AllTeamData> initialData;

  @override
  State<PicklistCard> createState() => _PicklistCardState();
}

class _PicklistCardState extends State<PicklistCard> {
  bool viewMode = true;
  late List<AllTeamData> data = widget.initialData;
  CurrentPickList currentPickList = CurrentPickList.first;
  @override
  void didUpdateWidget(final PicklistCard oldWidget) {
    if (data != widget.initialData) {
      setState(() {
        data = widget.initialData;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    save(data);
  }

  @override
  Widget build(final BuildContext context) => DashboardCard(
        titleWidgets: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  ToggleButtons(
                    children: <Widget>[
                      const Text("First"),
                      const Text("Second"),
                      const Text("Third"),
                    ]
                        .map(
                          (final Widget text) => Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isPC(context) ? 30 : 5,
                            ),
                            child: text,
                          ),
                        )
                        .toList(),
                    isSelected: <bool>[
                      currentPickList == CurrentPickList.first,
                      currentPickList == CurrentPickList.second,
                      currentPickList == CurrentPickList.third,
                    ],
                    onPressed: (final int pressedIndex) {
                      if (pressedIndex == 0) {
                        setState(() {
                          currentPickList = CurrentPickList.first;
                          CurrentPickList.first;
                        });
                      } else if (pressedIndex == 1) {
                        setState(() {
                          currentPickList = CurrentPickList.second;
                          CurrentPickList.second;
                        });
                      } else if (pressedIndex == 2) {
                        setState(() {
                          currentPickList = CurrentPickList.third;
                          CurrentPickList.third;
                        });
                      }
                    },
                  ),
                  IconButton(
                    onPressed: viewMode
                        ? null
                        : () {
                            save(List<AllTeamData>.from(data), context);
                          },
                    icon: const Icon(Icons.save),
                  ),
                  IconButton(
                    tooltip: "Sort taken",
                    onPressed: viewMode
                        ? null
                        : () {
                            setState(() {
                              final List<AllTeamData> teamsUntaken = data
                                  .where(
                                    (final AllTeamData element) =>
                                        !element.taken,
                                  )
                                  .toList();
                              final Iterable<AllTeamData> teamsTaken =
                                  data.where(
                                (final AllTeamData element) => element.taken,
                              );
                              data = (teamsUntaken..addAll(teamsTaken));
                              for (int i = 0; i < data.length; i++) {
                                currentPickList.setIndex(data[i], i);
                              }
                            });
                          },
                    icon: const Icon(Icons.sort),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  TextButton(
                    onPressed: viewMode
                        ? null
                        : () async {
                            final List<AllTeamData>? newAllTeamData =
                                await showDialog<List<AllTeamData>>(
                              context: context,
                              builder: (final BuildContext context) =>
                                  AutoPickListPopUp(
                                currentPickList: currentPickList,
                                teamsToSort: widget.initialData,
                              ),
                            );
                            if (newAllTeamData != null) {
                              setState(() {
                                data = newAllTeamData;
                              });
                            }
                          },
                    child: const Text("Sort By"),
                  ),
                  TextButton(
                    onPressed: () async {
                      final bool? newViewMode = await showDialog<bool>(
                        context: context,
                        builder: (final BuildContext context) => Password(
                          viewMode: viewMode,
                        ),
                      );
                      setState(() {
                        viewMode = newViewMode ?? viewMode;
                      });
                    },
                    child: viewMode
                        ? const Text(
                            "View Mode",
                            style: TextStyle(color: Colors.red),
                          )
                        : const Text(
                            "Edit Mode",
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ],
        title: "",
        body: PickList(
          uiList: data,
          onReorder: (final List<AllTeamData> list) => setState(() {
            data = list;
          }),
          screen: currentPickList,
          viewMode: viewMode,
        ),
      );
}
