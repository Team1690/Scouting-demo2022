import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/models/enums/climb_enum.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/input_view_vars.dart";

class ClimbingSelector extends StatelessWidget {
  const ClimbingSelector({required this.match, required this.onNewMatch});
  final InputViewVars match;
  final void Function(InputViewVars) onNewMatch;
  @override
  Widget build(final BuildContext context) => Selector<Climb>(
        options: Climb.values,
        placeholder: "Select climbing status",
        value: match.climb,
        makeItem: (final Climb climb) => climb.title,
        onChange: (final Climb id) {
          onNewMatch(
            match.copyWith(
              climb: always(id),
            ),
          );
        },
        validate: always2(null),
      );
}

class Climbing extends StatelessWidget {
  const Climbing({required this.match, required this.onNewMatch});
  final InputViewVars match;
  final void Function(InputViewVars) onNewMatch;
  @override
  Widget build(final BuildContext context) => Column(
        children: <Widget>[
          ClimbingSelector(match: match, onNewMatch: onNewMatch),
        ],
      );
}
