enum PointGiver {
  lowerHubAuto(points: 2),
  upperHubAuto(points: 4),
  lowerHubTele(points: 1),
  upperHubTele(points: 2),
  leftTarmac(points: 2);

  const PointGiver({
    required this.points,
  });

  final int points;

  num calcPoints(final num amount) => points * amount;
}
