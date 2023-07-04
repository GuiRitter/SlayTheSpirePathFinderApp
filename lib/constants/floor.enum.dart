enum FloorEnum {
  neow(
    name: "N",
  ),
  unknown(
    name: "U",
  ),
  merchant(
    name: "M",
  ),
  treasure(
    name: "T",
  ),
  rest(
    name: "R",
  ),
  enemy(
    name: "E",
  ),
  elite(
    name: "L",
  ),
  boss(
    name: "B",
  );

  // TODO remove all static references to specific values; that is, use the list for everything
  static List<FloorEnum> get valuesMid => values
      .where(
        (
          wEnum,
        ) =>
            (wEnum != neow) && (wEnum != boss),
      )
      .toList();

  final String name;

  const FloorEnum({
    required this.name,
  });
}
