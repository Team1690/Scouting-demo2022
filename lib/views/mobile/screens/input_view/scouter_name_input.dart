import "package:flutter/material.dart";
import "package:scouting_frontend/views/mobile/screens/input_view/scouter_selection.dart";

class ScouterNameInput extends StatelessWidget {
  const ScouterNameInput({
    required this.scouterNameController,
    required this.onScouterNameChange,
  });

  final void Function(String scouterName) onScouterNameChange;
  final TextEditingController scouterNameController;

  @override
  Widget build(final BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                child: TextField(
              controller: scouterNameController,
              decoration: const InputDecoration(
                hintText: "Enter Scouter Name",
              ),
              onChanged: onScouterNameChange,
            ))
          ],
        ),
      ]);
}
