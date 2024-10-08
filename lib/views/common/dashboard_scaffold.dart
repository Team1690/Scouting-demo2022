import "package:flutter/material.dart";
import "package:flutter/services.dart";
// import "package:scouting_frontend/views/pc/compare/compare_screen.dart";
import "package:scouting_frontend/views/pc/picklist/pick_list_screen.dart";
// import "package:scouting_frontend/views/pc/scatter/scatters_screen.dart";
import "package:scouting_frontend/views/pc/team_info/team_info_screen.dart";

import "package:scouting_frontend/views/pc/navigation_tab.dart";

class DashboardScaffold extends StatelessWidget {
  DashboardScaffold({
    required this.body,
  });

  final Widget body;

  @override
  Widget build(final BuildContext context) => KeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKeyEvent: (final KeyEvent event) {
          keyboardShortcut<TeamInfoScreen>(
            context,
            event,
            TeamInfoScreen(),
            (final KeyEvent event) =>
                event.logicalKey == LogicalKeyboardKey.controlLeft &&
                event.physicalKey == PhysicalKeyboardKey.keyM &&
                event.runtimeType == KeyDownEvent,
          );

          keyboardShortcut<PickListScreen>(
            context,
            event,
            PickListScreen(),
            (final KeyEvent event) =>
                event.logicalKey == LogicalKeyboardKey.controlLeft &&
                event.physicalKey == PhysicalKeyboardKey.comma &&
                event.runtimeType == KeyDownEvent,
          );

          // keyboardShortcut<CompareScreen>(
          //   context,
          //   event,
          //   CompareScreen(),
          //   (final KeyEvent event) =>
          //       event.logicalKey == LogicalKeyboardKey.controlLeft &&
          //       event.physicalKey == PhysicalKeyboardKey.period &&
          //       event.runtimeType == KeyDownEvent,
          // );

          // keyboardShortcut<ScatterScreen>(
          //   context,
          //   event,
          //   ScatterScreen(),
          //   (final KeyEvent event) =>
          //       event.logicalKey == LogicalKeyboardKey.controlLeft &&
          //       event.physicalKey == PhysicalKeyboardKey.slash &&
          //       event.runtimeType == KeyDownEvent,
          // );
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // appBar: AppBar(title: Text('Orbit Scouting')),
          body: SafeArea(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: NavigationTab(),
                ),
                Expanded(flex: 5, child: body),
              ],
            ),
          ),
        ),
      );
}

void keyboardShortcut<E extends Widget>(
  final BuildContext context,
  final KeyEvent event,
  final E widget,
  final bool Function(KeyEvent) predicate,
) {
  if (predicate(event)) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<E>(
        builder: (final BuildContext context) => widget,
      ),
    );
  }
}
