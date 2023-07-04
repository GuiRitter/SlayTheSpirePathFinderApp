import 'package:slay_the_spire_path_finder_mobile/constants/floor.enum.dart';
import 'package:slay_the_spire_path_finder_mobile/models/node.model.dart';

class PathModel {
  final List<NodeModel> _nodeList = <NodeModel>[];

  PathModel({
    required NodeModel firstNode,
  }) {
    _nodeList.add(
      firstNode,
    );
  }

  PathModel._extend({
    required PathModel oldPath,
    required NodeModel newNode,
  }) {
    _nodeList.addAll(
      oldPath._nodeList,
    );
    _nodeList.add(
      newNode,
    );
  }

  bool get isClosed =>
      _nodeList.isNotEmpty && _nodeList.last.floor.kind == FloorEnum.boss;

  bool get isOpen => !isClosed;

  NodeModel get last => _nodeList.last;

  double get weight => _nodeList.fold(
        0,
        (
          previousValue,
          element,
        ) =>
            previousValue + (element.floor.weight ?? 0),
      );

  /// Returns false if this node is already in this path.
  bool addNode(
    NodeModel node,
  ) {
    if (_nodeList.contains(
      node,
    )) {
      return false;
    }
    _nodeList.add(
      node,
    );
    return true;
  }

  PathModel? extend({
    required NodeModel node,
  }) {
    if (_nodeList.contains(
      node,
    )) {
      return null;
    }
    return PathModel._extend(
      oldPath: this,
      newNode: node,
    );
  }
}
