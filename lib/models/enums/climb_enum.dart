import "package:scouting_frontend/models/providers/id_providers.dart";

enum Climb implements IdEnum {
  noAttempt("No attempt", 0, 0),
  failed("Failed", 1, 0),
  climbOne("First bar", 2, 4),
  climbTwo("Second bar", 3, 6),
  climbThree("Third bar", 4, 10);

  const Climb(this.title, this.chartHeight, this.points);

  @override
  final String title;
  final double chartHeight;
  final int points;
}

Climb climbTitleToEnum(final String title) =>
    Climb.values
        .where((final Climb climbOption) => climbOption.title == title)
        .singleOrNull ??
    (throw Exception("Invalid title: $title"));
