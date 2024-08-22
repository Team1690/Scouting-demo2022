import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:scouting_frontend/views/mobile/counter.dart";
import "package:scouting_frontend/models/enums/match_mode_enum.dart" as m;
import "package:scouting_frontend/views/mobile/screens/input_view/input_view_vars.dart";

class GamePieceCounter extends StatelessWidget {
  const GamePieceCounter({
    //TODO see if merging upper and lower hub change function is possible
    super.key,
    required this.lowerHub,
    required this.lowerHubMissed,
    required this.upperHub,
    required this.upperHubMissed,
    required this.onLowerHubChange,
    required this.onLowerHubMissedChange,
    required this.onUpperHubChange,
    required this.onUpperHubMissedChange,
    required this.flickerScreen,
  });

  final int lowerHub;
  final int lowerHubMissed;
  final int upperHub;
  final int upperHubMissed;

  final void Function(int lowerHub) onLowerHubChange;
  final void Function(int upperHub) onUpperHubChange;
  final void Function(int lowerHubMissed) onLowerHubMissedChange;
  final void Function(int upperHubMissed) onUpperHubMissedChange;
  final void Function(int newValue, int oldValue) flickerScreen;

  @override
  Widget build(final BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Counter(
                  label: "Scored Lower Hub",
                  icon: Icons.hub,
                  onChange: (final int lowerHub) {
                    flickerScreen(lowerHub, this.lowerHub);
                    onLowerHubChange(lowerHub);
                  },
                  count: lowerHub,
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: Counter(
                  label: "Scored Upper Hub",
                  icon: Icons.hub,
                  onChange: (final int upperHub) {
                    flickerScreen(upperHub, this.upperHub);
                    onUpperHubChange(upperHub);
                  },
                  count: upperHub,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Counter(
                  label: "Missed Lower Hub",
                  icon: Icons.cancel,
                  onChange: (final int lowerHubMissed) {
                    flickerScreen(lowerHubMissed, this.lowerHubMissed);
                    onLowerHubMissedChange(lowerHubMissed);
                  },
                  count: lowerHubMissed,
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: Counter(
                  label: "Missed Upper Hub",
                  icon: Icons.cancel,
                  onChange: (final int upperHubMissed) {
                    flickerScreen(upperHubMissed, this.upperHubMissed);
                    onUpperHubMissedChange(upperHubMissed);
                  },
                  count: upperHubMissed,
                ),
              ),
            ],
          ),
        ],
      );
}

class MatchModeGamePieceCounter extends StatelessWidget {
  const MatchModeGamePieceCounter({
    super.key,
    required this.match,
    required this.onNewMatch,
    required this.matchMode,
    required this.flickerScreen,
  });
  final InputViewVars match;
  final m.MatchMode matchMode;
  final void Function(InputViewVars) onNewMatch;
  final void Function(int newValue, int oldValue) flickerScreen;

  int modeValue(final int autoValue, final int teleValue) =>
      switch (matchMode) {
        m.MatchMode.auto => autoValue,
        m.MatchMode.tele => teleValue,
        m.MatchMode.endGame => 0,
      };

  @override
  Widget build(final BuildContext context) => GamePieceCounter(
        flickerScreen: flickerScreen,
        lowerHub: modeValue(match.lowerHubAuto, match.lowerHubTele),
        lowerHubMissed:
            modeValue(match.lowerHubMissedAuto, match.lowerHubMissedTele),
        upperHub: modeValue(match.upperHubAuto, match.upperHubTele),
        upperHubMissed:
            modeValue(match.upperHubMissedAuto, match.upperHubMissedTele),
        onLowerHubChange: (final int lowerHub) {
          onNewMatch(
            matchMode == m.MatchMode.tele
                ? match.copyWith(lowerHubTele: always(lowerHub))
                : match.copyWith(lowerHubAuto: always(lowerHub)),
          );
        },
        onUpperHubChange: (final int upperHub) {
          onNewMatch(
            matchMode == m.MatchMode.tele
                ? match.copyWith(upperHubTele: always(upperHub))
                : match.copyWith(upperHubAuto: always(upperHub)),
          );
        },
        onLowerHubMissedChange: (final int lowerHubMissed) {
          onNewMatch(
            matchMode == m.MatchMode.tele
                ? match.copyWith(lowerHubMissedTele: always(lowerHubMissed))
                : match.copyWith(lowerHubMissedAuto: always(lowerHubMissed)),
          );
        },
        onUpperHubMissedChange: (final int upperHubMissed) {
          onNewMatch(
            matchMode == m.MatchMode.tele
                ? match.copyWith(upperHubMissedTele: always(upperHubMissed))
                : match.copyWith(upperHubMissedAuto: always(upperHubMissed)),
          );
        },
      );
}
