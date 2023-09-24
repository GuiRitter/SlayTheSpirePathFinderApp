import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/floor.enum.dart';
import 'package:slay_the_spire_path_finder_mobile/models/node.model.dart';

class PathModel implements Comparable<PathModel> {
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

  @override
  int get hashCode => _nodeList.hashCode;

  bool get isClosed =>
      _nodeList.isNotEmpty && _nodeList.last.floor.kind == FloorEnum.boss;

  bool get isOpen => !isClosed;

  NodeModel get last => _nodeList.last;

  int get length => _nodeList.length;

  List<NodeModel> get nodeList => List.unmodifiable(
        _nodeList,
      );

  double get weight => _nodeList.fold(
        0,
        (
          previousValue,
          element,
        ) =>
            previousValue + (element.floor.weight ?? 0),
      );

  @override
  bool operator ==(
    Object other,
  ) {
    if (other is! PathModel) {
      return false;
    }
    if (other.length != length) {
      return false;
    }
    if (_nodeList.isEmpty) {
      return true;
    }
    for (int i = 0; i < length; i++) {
      if (other._nodeList[i] != _nodeList[i]) {
        return false;
      }
    }
    return true;
  }

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

  @override
  int compareTo(
    PathModel other,
  ) {
    if (weight > other.weight) {
      return -1;
    }
    if (weight < other.weight) {
      return 1;
    }
    return _nodeList.toString().compareTo(
          other._nodeList.toString(),
        );
  }

  /// Returns null if this node is already in this path.
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

  Map<FloorEnum, int> getFloorCountByKind() {
    final count = FloorEnum.valuesMid.fold(
      <FloorEnum, int>{},
      (
        previousValue,
        element,
      ) =>
          {
        ...previousValue,
        element: 0,
      },
    );

    _nodeList
        .where(
      (
        wNode,
      ) =>
          (wNode.floor.kind != FloorEnum.neow) &&
          (wNode.floor.kind != FloorEnum.boss),
    )
        .forEach(
      (
        feNode,
      ) {
        count[feNode.floor.kind] = count[feNode.floor.kind]! + 1;
      },
    );
    return count;
  }

  String getFloorCountByKindString({
    required AppLocalizations l10n,
  }) =>
      getFloorCountByKind()
          .entries
          .map(
            (
              entry,
            ) =>
                "${l10n.floorEnum(
                      entry.key.name,
                    ).toLowerCase()}: ${entry.value}",
          )
          .join(
            ", ",
          );

  @override
  String toString({
    AppLocalizations? l10n,
  }) {
    final string = "$_nodeList (weight: $weight)";
    return (l10n != null)
        ? "$string (${getFloorCountByKindString(
            l10n: l10n,
          )})"
        : string;
  }
}
