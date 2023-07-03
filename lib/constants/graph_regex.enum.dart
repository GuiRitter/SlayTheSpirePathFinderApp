enum GraphRegexEnum {
  exitingNeow(
    tag: "exitingNeow",
  ),
  exitingFloor(
    tag: "exitingFloor",
  ),
  exitingNumber(
    tag: "exitingNumber",
  ),
  enteringBoss(
    tag: "enteringBoss",
  ),
  enteringFloor(
    tag: "enteringFloor",
  ),
  enteringNumber(
    tag: "enteringNumber",
  );

  final String tag;

  const GraphRegexEnum({
    required this.tag,
  });
}
