import "package:scouting_frontend/models/providers/id_providers.dart";

enum Climb implements IdEnum {
  noAttempt("No attempt", 0),
  failed("Failed", 1),
  climbOne("First bar", 2),
  climbTwo("Second bar", 3),
  climbThree("Third bar", 4);

  const Climb(this.title, this.chartHeight);

  @override
  final String title;
  final double chartHeight;
}

Climb climbTitleToEnum(final String title) =>
    Climb.values
        .where((final Climb climbOption) => climbOption.title == title)
        .singleOrNull ??
    (throw Exception("Invalid title: $title"));
