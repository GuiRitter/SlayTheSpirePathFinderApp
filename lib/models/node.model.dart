import 'package:slay_the_spire_path_finder_mobile/models/floor.model.dart';

class NodeModel {
  final FloorModel floor;
  final String? number;

  NodeModel({
    required this.floor,
    required this.number,
  });

  @override
  int get hashCode => floor.hashCode ^ number.hashCode;

  @override
  bool operator ==(
    Object other,
  ) {
    if (other is! NodeModel) {
      return false;
    }
    return (floor == other.floor) && (number == other.number);
  }

  @override
  String toString() {
    return "${floor.kind.name}${number ?? ""}";
  }
}
