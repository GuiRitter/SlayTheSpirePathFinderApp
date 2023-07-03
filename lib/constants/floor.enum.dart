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

  final String name;

  const FloorEnum({
    required this.name,
  });
}
