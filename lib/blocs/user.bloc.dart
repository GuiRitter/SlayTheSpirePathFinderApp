import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/floor.enum.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/graph_regex.enum.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/operation.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/result_status.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/settings.dart';
import 'package:slay_the_spire_path_finder_mobile/models/edge.model.dart';
import 'package:slay_the_spire_path_finder_mobile/models/floor.model.dart';
import 'package:slay_the_spire_path_finder_mobile/models/floor_widget.model.dart';
import 'package:slay_the_spire_path_finder_mobile/models/node.model.dart';
import 'package:slay_the_spire_path_finder_mobile/models/path.model.dart';
import 'package:slay_the_spire_path_finder_mobile/models/result.model.dart';
import 'package:slay_the_spire_path_finder_mobile/models/transition_widget.model.dart';

class UserBloc extends ChangeNotifier {
  String? _output;

  Image? _image;

  var _operation = Operation.placeFloor;

  var _floor = FloorEnum.neow;

  final _floorWidgetModelList = <FloorWidgetModel>[];

  final _transitionWidgetModelList = <TransitionWidgetModel>[];

  FloorWidgetModel? _floorWidgetModelSelected;

  FloorEnum get floor => _floor;

  FloorWidgetModel? get floorWidgetModelSelected => _floorWidgetModelSelected;

  List<FloorWidgetModel> get floorWidgetModelList => _floorWidgetModelList;
  Image? get image => _image;

  Operation get operation => _operation;

  String? get output => _output;

  List<TransitionWidgetModel> get transitionWidgetModelList =>
      _transitionWidgetModelList;

  clearImage() {
    _image = null;
    _floorWidgetModelList.clear();
    _transitionWidgetModelList.clear();
    notifyListeners();
  }

  clearPaths() {
    _output = null;
    notifyListeners();
  }

  ResultModel<void> findPaths({
    required String graph,
    required Map<FloorEnum, double> weightMap,
    required AppLocalizations l10n,
  }) {
    final floorMap = weightMap.map(
      (
        key,
        value,
      ) =>
          MapEntry(
        key.name,
        FloorModel(
          kind: key,
          weight: value,
        ),
      ),
    );

    final nodeMap = weightMap.map(
      (
        key,
        value,
      ) =>
          MapEntry(
        key.name,
        <String, NodeModel>{},
      ),
    );

    final neowNode = NodeModel(
      floor: FloorModel(
        kind: FloorEnum.neow,
        weight: null,
      ),
      number: null,
    );

    final bossNode = NodeModel(
      floor: FloorModel(
        kind: FloorEnum.boss,
        weight: null,
      ),
      number: null,
    );

    bool hasNeow = false;
    bool hasBoss = false;

    final edgeList = Settings.floorRegex
        .allMatches(
      graph,
    )
        .map(
      (
        transition,
      ) {
        final isNeow = transition.namedGroup(
              GraphRegexEnum.exitingNeow.tag,
            ) !=
            null;
        final isBoss = transition.namedGroup(
              GraphRegexEnum.enteringBoss.tag,
            ) !=
            null;

        hasNeow = hasNeow || isNeow;
        hasBoss = hasBoss || isBoss;

        final exitingFloorModel = isNeow
            ? neowNode.floor
            : floorMap[transition.namedGroup(
                GraphRegexEnum.exitingFloor.tag,
              )]!;

        final enteringFloorModel = isBoss
            ? bossNode.floor
            : floorMap[transition.namedGroup(
                GraphRegexEnum.enteringFloor.tag,
              )]!;

        final exitingFloorNumber = transition.namedGroup(
          GraphRegexEnum.exitingNumber.tag,
        );

        final enteringFloorNumber = transition.namedGroup(
          GraphRegexEnum.enteringNumber.tag,
        );

        var exitingNode = isNeow
            ? neowNode
            : nodeMap[exitingFloorModel.kind.name]![exitingFloorNumber];

        if (exitingNode == null) {
          exitingNode = NodeModel(
            floor: exitingFloorModel,
            number: exitingFloorNumber,
          );

          nodeMap[exitingFloorModel.kind.name]![exitingFloorNumber!] =
              exitingNode;
        }

        var enteringNode = isBoss
            ? bossNode
            : nodeMap[enteringFloorModel.kind.name]![enteringFloorNumber];

        if (enteringNode == null) {
          enteringNode = NodeModel(
            floor: enteringFloorModel,
            number: enteringFloorNumber,
          );

          nodeMap[enteringFloorModel.kind.name]![enteringFloorNumber!] =
              enteringNode;
        }

        return EdgeModel(
          exitingNode: exitingNode,
          enteringNode: enteringNode,
        );
      },
    ).toList();

    if (!hasNeow) {
      return ResultModel(
        status: ResultStatus.warning,
        message: l10n.noNeow,
      );
    }

    if (!hasBoss) {
      return ResultModel(
        status: ResultStatus.warning,
        message: l10n.noBoss,
      );
    }

    for (int i = 0; i < (edgeList.length - 1); i++) {
      for (int j = i + 1; j < edgeList.length; j++) {
        if ((i != j) && (edgeList[i] == edgeList[j])) {
          return ResultModel(
            status: ResultStatus.warning,
            message: l10n.duplicate,
          );
        }
      }
    }

    final processingPathList = <PathModel>[
      PathModel(
        firstNode: neowNode,
      ),
    ];

    final closedPathList = <PathModel>[];

    bool hasDoneSomething = true;

    ResultModel? result;

    while (hasDoneSomething && processingPathList.isNotEmpty) {
      hasDoneSomething = false;

      final openPath = processingPathList.removeAt(
        0,
      );

      edgeList
          .where(
        (
          wEdge,
        ) =>
            openPath.last == wEdge.exitingNode,
      )
          .forEach(
        (
          feEdge,
        ) {
          final newPath = openPath.extend(
            node: feEdge.enteringNode,
          );

          if (newPath == null) {
            result = ResultModel(
              status: ResultStatus.warning,
              message: l10n.pathHasCycle,
            );
          } else {
            hasDoneSomething = true;

            if (newPath.isClosed) {
              closedPathList.add(
                newPath,
              );
            } else {
              processingPathList.add(
                newPath,
              );
            }
          }
        },
      );

      if (result != null) {
        return result!;
      }
    }

    if ((!hasDoneSomething) || processingPathList.isNotEmpty) {
      return ResultModel(
        status: ResultStatus.warning,
        message: l10n.pathStillOpen,
      );
    }

    closedPathList.sort();

    _output = closedPathList.map(
      (
        mPath,
      ) {
        final count = mPath
            .getFloorCountByKind()
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
        return "${mPath.toString()} ($count)";
      },
    ).join(
      "\n",
    );
    notifyListeners();

    return ResultModel(
      status: ResultStatus.success,
    );
  }

  isFocused({
    required FloorWidgetModel floorWidgetModel,
  }) =>
      (floorWidgetModel == _floorWidgetModelSelected);

  setFloor({
    required FloorEnum floor,
  }) {
    _floor = floor;
    notifyListeners();
  }

  setImage({
    required Image image,
  }) {
    _image = image;
    notifyListeners();
  }

  setOperation({
    required Operation operation,
  }) {
    _operation = operation;

    if (operation != Operation.toggleTransition) {
      _floorWidgetModelSelected = null;
    }

    notifyListeners();
  }

  treatFloorWidgetAtLocation({
    required double x,
    required double y,
  }) {
    var floorWidgetModelTapped = FloorWidgetModel(
      kind: _floor,
      x: x,
      y: y,
    );

    switch (_operation) {
      case Operation.placeFloor:
        if (_floorWidgetModelList.contains(
          floorWidgetModelTapped,
        )) {
          _floorWidgetModelList.remove(
            floorWidgetModelTapped,
          );

          _transitionWidgetModelList.removeWhere(
            (
              transitionWidgetModel,
            ) =>
                (floorWidgetModelTapped ==
                    transitionWidgetModel.floorWidgetModel0) ||
                (floorWidgetModelTapped ==
                    transitionWidgetModel.floorWidgetModel1),
          );
        } else {
          _floorWidgetModelList.add(
            FloorWidgetModel(
              kind: _floor,
              x: x,
              y: y,
            ),
          );
        }

        break;
      case Operation.toggleTransition:
        if (_floorWidgetModelList.contains(
          floorWidgetModelTapped,
        )) {
          floorWidgetModelTapped = _floorWidgetModelList.singleWhere(
            (
              floorWidgetModel,
            ) =>
                floorWidgetModelTapped == floorWidgetModel,
          );
        } else {
          return;
        }

        if (_floorWidgetModelSelected == null) {
          _floorWidgetModelSelected = floorWidgetModelTapped;
        } else {
          if (_floorWidgetModelSelected == floorWidgetModelTapped) {
            _floorWidgetModelSelected = null;
          } else {
            final transitionWidgetModel = TransitionWidgetModel(
              floorWidgetModel0: _floorWidgetModelSelected!,
              floorWidgetModel1: floorWidgetModelTapped,
            );

            if (_transitionWidgetModelList.contains(
              transitionWidgetModel,
            )) {
              _transitionWidgetModelList.remove(
                transitionWidgetModel,
              );
            } else {
              _transitionWidgetModelList.add(
                transitionWidgetModel,
              );
            }

            _floorWidgetModelSelected = floorWidgetModelTapped;
          }
        }

        break;
    }

    notifyListeners();
  }
}
