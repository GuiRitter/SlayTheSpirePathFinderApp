import 'package:slay_the_spire_path_finder_mobile/constants/floor.enum.dart';

class FloorWidgetModel {
  final FloorEnum kind;
  final double x;
  final double y;

  String? number;

  FloorWidgetModel({
    required this.kind,
    required this.x,
    required this.y,
  });

  @override
  int get hashCode => kind.hashCode ^ x.hashCode ^ y.hashCode;

  @override
  bool operator ==(
    Object other,
  ) {
    if (other is! FloorWidgetModel) {
      return false;
    }
    return ((x - other.x).abs() < 16) && ((y - other.y).abs() < 16);
  }

  toJson() => {
        "kind": kind.toString(),
        "x,y": "($x; $y)",
        "number": number,
      };
}
