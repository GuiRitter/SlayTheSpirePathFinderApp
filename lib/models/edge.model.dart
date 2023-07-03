import 'package:slay_the_spire_path_finder_mobile/models/node.model.dart';

class EdgeModel {
  final NodeModel exitingNode;
  final NodeModel enteringNode;

  EdgeModel({
    required this.exitingNode,
    required this.enteringNode,
  });

  @override
  int get hashCode => exitingNode.hashCode ^ enteringNode.hashCode;

  @override
  bool operator ==(
    Object other,
  ) {
    if (other is! EdgeModel) {
      return false;
    }
    return (exitingNode == other.exitingNode) &&
        (enteringNode == other.enteringNode);
  }

  @override
  String toString() {
    return "$exitingNode-$enteringNode";
  }
}
