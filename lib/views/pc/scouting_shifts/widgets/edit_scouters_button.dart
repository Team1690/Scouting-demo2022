import "package:flutter/material.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/queries/fetch_scouters.dart";
import "package:scouting_frontend/views/pc/scouting_shifts/queries/update_scouter_name.dart";

class EditScoutersButton extends StatefulWidget {
  const EditScoutersButton({super.key});

  @override
  State<EditScoutersButton> createState() => _EditScoutersButtonState();
}

class _EditScoutersButtonState extends State<EditScoutersButton> {
  @override
  Widget build(final BuildContext context) => IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (final BuildContext context) => AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    StreamBuilder<List<String>>(
                      stream: fetchScouters(),
                      builder: (
                        final BuildContext context,
                        final AsyncSnapshot<List<String>> snapshot,
                      ) =>
                          snapshot.mapSnapshot(
                        onSuccess: (final List<String> data) =>
                            SingleChildScrollView(
                          child: Column(
                            children: data
                                .map(
                                  ((final String scouterName) => Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: TextField(
                                              controller: TextEditingController(
                                                text: scouterName,
                                              ),
                                              onSubmitted:
                                                  (final String value) {
                                                updateScouter(
                                                  scouterName,
                                                  value,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      )),
                                )
                                .toList(),
                          ),
                        ),
                        onWaiting: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        onNoData: () => const Text("No Data"),
                        onError: (final Object error) => Center(
                          child: Text(error.toString()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        icon: const Icon(Icons.manage_accounts),
      );
}
