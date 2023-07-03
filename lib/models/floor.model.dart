import 'package:slay_the_spire_path_finder_mobile/constants/floor.enum.dart';

class FloorModel {
  final FloorEnum kind;
  final double? weight;

  FloorModel({
    required this.kind,
    required this.weight,
  });

  @override
  int get hashCode => kind.hashCode ^ weight.hashCode;

  @override
  bool operator ==(
    Object other,
  ) {
    if (other is! FloorModel) {
      return false;
    }
    return (kind == other.kind) && (weight == other.weight);
  }
}
