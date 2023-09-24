import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/floor.enum.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/operation.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/result_status.dart';
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

  List<FloorWidgetModel> get floorWidgetModelList => _floorWidgetModelList;

  FloorWidgetModel? get floorWidgetModelSelected => _floorWidgetModelSelected;
  Image? get image => _image;

  Operation get operation => _operation;

  String? get output => _output;

  List<TransitionWidgetModel> get transitionWidgetModelList =>
      _transitionWidgetModelList;

  int byY(FloorWidgetModel a, FloorWidgetModel b) {
    if (a.y > b.y) {
      return -1;
    }
    if (a.y < b.y) {
      return 1;
    }
    return 0;
  }

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

    // Rewritten from a forEach because of avoid_function_literals_in_foreach_calls
    for (final feFloorEnum in FloorEnum.valuesMid) {
      final floorWidgetModelSameKindList = _floorWidgetModelList
          .where(
            (
              wFloorWidget,
            ) =>
                wFloorWidget.kind == feFloorEnum,
          )
          .toList();

      floorWidgetModelSameKindList.sort(byY);

      // Rewritten from a forEach because of avoid_function_literals_in_foreach_calls
      for (var feIndexedFloorWidget in floorWidgetModelSameKindList.indexed) {
        feIndexedFloorWidget.$2.number = feIndexedFloorWidget.$1.toString();
      }
    }

    bool hasNeow = false;
    bool hasBoss = false;

    final floorWidgetModelPendingList = <FloorWidgetModel>[];

    // Rewritten from a forEach because of avoid_function_literals_in_foreach_calls
    for (final feTransitionWidget in _transitionWidgetModelList) {
      if (feTransitionWidget.floorWidgetModel0.kind == FloorEnum.neow) {
        feTransitionWidget.exitingFloorWidgetModel =
            feTransitionWidget.floorWidgetModel0;
        feTransitionWidget.enteringFloorWidgetModel =
            feTransitionWidget.floorWidgetModel1;
      } else if (feTransitionWidget.floorWidgetModel1.kind == FloorEnum.neow) {
        feTransitionWidget.exitingFloorWidgetModel =
            feTransitionWidget.floorWidgetModel1;
        feTransitionWidget.enteringFloorWidgetModel =
            feTransitionWidget.floorWidgetModel0;
      } else if (feTransitionWidget.floorWidgetModel0.kind == FloorEnum.boss) {
        feTransitionWidget.exitingFloorWidgetModel =
            feTransitionWidget.floorWidgetModel1;
        feTransitionWidget.enteringFloorWidgetModel =
            feTransitionWidget.floorWidgetModel0;
      } else if (feTransitionWidget.floorWidgetModel1.kind == FloorEnum.boss) {
        feTransitionWidget.exitingFloorWidgetModel =
            feTransitionWidget.floorWidgetModel0;
        feTransitionWidget.enteringFloorWidgetModel =
            feTransitionWidget.floorWidgetModel1;
      }

      if (feTransitionWidget.exitingFloorWidgetModel?.kind == FloorEnum.neow) {
        floorWidgetModelPendingList
            .add(feTransitionWidget.enteringFloorWidgetModel!);
      }
    }

    bool hasDoneSomething = true;

    while (hasDoneSomething &&
        _transitionWidgetModelList.any(
          (
            aTransitionWidget,
          ) =>
              !aTransitionWidget.hasEnteringAndExiting(),
        )) {
      hasDoneSomething = false;

      final transitionWidgetModelPendingList = _transitionWidgetModelList
          .where(
            (
              wTransitionWidget,
            ) =>
                (!wTransitionWidget.hasEnteringAndExiting()) &&
                (floorWidgetModelPendingList
                        .contains(wTransitionWidget.floorWidgetModel0) ||
                    floorWidgetModelPendingList
                        .contains(wTransitionWidget.floorWidgetModel1)),
          )
          .toList();

      // Rewritten from a forEach because of avoid_function_literals_in_foreach_calls
      for (var feTransition in transitionWidgetModelPendingList) {
        if (floorWidgetModelPendingList.contains(
          feTransition.floorWidgetModel0,
        )) {
          feTransition.exitingFloorWidgetModel = feTransition.floorWidgetModel0;
          feTransition.enteringFloorWidgetModel =
              feTransition.floorWidgetModel1;

          hasDoneSomething = true;
        } else {
          feTransition.exitingFloorWidgetModel = feTransition.floorWidgetModel1;
          feTransition.enteringFloorWidgetModel =
              feTransition.floorWidgetModel0;

          hasDoneSomething = true;
        }
      }

      floorWidgetModelPendingList.clear();

      floorWidgetModelPendingList.addAll(
        transitionWidgetModelPendingList.map(
          (
            mTransition,
          ) =>
              mTransition.enteringFloorWidgetModel!,
        ),
      );
    }

    if ((!hasDoneSomething) ||
        _transitionWidgetModelList.any(
          (
            aTransitionWidget,
          ) =>
              !aTransitionWidget.hasEnteringAndExiting(),
        )) {
      return ResultModel(
        status: ResultStatus.warning,
        message: l10n.pathStillOpen,
      );
    }

    final edgeList = _transitionWidgetModelList.map(
      (
        mTransitionWidget,
      ) {
        final isNeow = mTransitionWidget.hasKind(
          FloorEnum.neow,
        );

        final isBoss = mTransitionWidget.hasKind(
          FloorEnum.boss,
        );

        hasNeow = hasNeow || isNeow;
        hasBoss = hasBoss || isBoss;

        final exitingFloorModel = isNeow
            ? neowNode.floor
            : floorMap[mTransitionWidget.exitingFloorWidgetModel!.kind.name]!;

        final enteringFloorModel = isBoss
            ? bossNode.floor
            : floorMap[mTransitionWidget.enteringFloorWidgetModel!.kind.name]!;

        final exitingFloorNumber =
            mTransitionWidget.exitingFloorWidgetModel!.number;

        final enteringFloorNumber =
            mTransitionWidget.enteringFloorWidgetModel!.number;

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

    hasDoneSomething = true;

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

  // TODO debug
  buildScenario() {
    final floorMap = <String, FloorWidgetModel>{};
    floorMap["353.5; 1804.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 353.5,
      y: 1804.5,
    );
    floorMap["537.5; 1755.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 537.5,
      y: 1755.5,
    );
    floorMap["614.5; 1773.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 614.5,
      y: 1773.5,
    );
    floorMap["765.5; 1791.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 765.5,
      y: 1791.5,
    );
    floorMap["881.5; 1758.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 881.5,
      y: 1758.5,
    );
    floorMap["727.5; 1853.5"] = FloorWidgetModel(
      kind: FloorEnum.neow,
      x: 727.5,
      y: 1853.5,
    );
    floorMap["608; 1676.5"] = FloorWidgetModel(
      kind: FloorEnum.unknown,
      x: 608,
      y: 1676.5,
    );
    floorMap["701; 1658.5"] = FloorWidgetModel(
      kind: FloorEnum.unknown,
      x: 701,
      y: 1658.5,
    );
    floorMap["768; 1583.5"] = FloorWidgetModel(
      kind: FloorEnum.unknown,
      x: 768,
      y: 1583.5,
    );
    floorMap["367; 1569.5"] = FloorWidgetModel(
      kind: FloorEnum.unknown,
      x: 367,
      y: 1569.5,
    );
    floorMap["536; 1463.5"] = FloorWidgetModel(
      kind: FloorEnum.unknown,
      x: 536,
      y: 1463.5,
    );
    floorMap["543; 1371.5"] = FloorWidgetModel(
      kind: FloorEnum.unknown,
      x: 543,
      y: 1371.5,
    );
    floorMap["798; 1374.5"] = FloorWidgetModel(
      kind: FloorEnum.unknown,
      x: 798,
      y: 1374.5,
    );
    floorMap["366; 1152.5"] = FloorWidgetModel(
      kind: FloorEnum.unknown,
      x: 366,
      y: 1152.5,
    );
    floorMap["525; 753.5"] = FloorWidgetModel(
      kind: FloorEnum.unknown,
      x: 525,
      y: 753.5,
    );
    floorMap["793; 690.5"] = FloorWidgetModel(
      kind: FloorEnum.unknown,
      x: 793,
      y: 690.5,
    );
    floorMap["778.5; 1653.5"] = FloorWidgetModel(
      kind: FloorEnum.merchant,
      x: 778.5,
      y: 1653.5,
    );
    floorMap["445.5; 1481.5"] = FloorWidgetModel(
      kind: FloorEnum.merchant,
      x: 445.5,
      y: 1481.5,
    );
    floorMap["349.5; 1094.5"] = FloorWidgetModel(
      kind: FloorEnum.merchant,
      x: 349.5,
      y: 1094.5,
    );
    floorMap["445.5; 594.5"] = FloorWidgetModel(
      kind: FloorEnum.merchant,
      x: 445.5,
      y: 594.5,
    );
    floorMap["847.5; 595.5"] = FloorWidgetModel(
      kind: FloorEnum.merchant,
      x: 847.5,
      y: 595.5,
    );
    floorMap["432.5; 1255.5"] = FloorWidgetModel(
      kind: FloorEnum.rest,
      x: 432.5,
      y: 1255.5,
    );
    floorMap["623.5; 1267.5"] = FloorWidgetModel(
      kind: FloorEnum.rest,
      x: 623.5,
      y: 1267.5,
    );
    floorMap["870.5; 1278.5"] = FloorWidgetModel(
      kind: FloorEnum.rest,
      x: 870.5,
      y: 1278.5,
    );
    floorMap["540.5; 868.5"] = FloorWidgetModel(
      kind: FloorEnum.rest,
      x: 540.5,
      y: 868.5,
    );
    floorMap["521.5; 483.5"] = FloorWidgetModel(
      kind: FloorEnum.rest,
      x: 521.5,
      y: 483.5,
    );
    floorMap["541; 1276.5"] = FloorWidgetModel(
      kind: FloorEnum.elite,
      x: 541,
      y: 1276.5,
    );
    floorMap["463; 1094.5"] = FloorWidgetModel(
      kind: FloorEnum.elite,
      x: 463,
      y: 1094.5,
    );
    floorMap["603; 1176.5"] = FloorWidgetModel(
      kind: FloorEnum.elite,
      x: 603,
      y: 1176.5,
    );
    floorMap["691; 776.5"] = FloorWidgetModel(
      kind: FloorEnum.elite,
      x: 691,
      y: 776.5,
    );
    floorMap["353; 490.5"] = FloorWidgetModel(
      kind: FloorEnum.elite,
      x: 353,
      y: 490.5,
    );
    floorMap["365; 961.5"] = FloorWidgetModel(
      kind: FloorEnum.treasure,
      x: 365,
      y: 961.5,
    );
    floorMap["467; 971.5"] = FloorWidgetModel(
      kind: FloorEnum.treasure,
      x: 467,
      y: 971.5,
    );
    floorMap["539; 977.5"] = FloorWidgetModel(
      kind: FloorEnum.treasure,
      x: 539,
      y: 977.5,
    );
    floorMap["703; 988.5"] = FloorWidgetModel(
      kind: FloorEnum.treasure,
      x: 703,
      y: 988.5,
    );
    floorMap["778; 988.5"] = FloorWidgetModel(
      kind: FloorEnum.treasure,
      x: 778,
      y: 988.5,
    );
    floorMap["358.5; 1667.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 358.5,
      y: 1667.5,
    );
    floorMap["443.5; 1662.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 443.5,
      y: 1662.5,
    );
    floorMap["431.5; 1575.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 431.5,
      y: 1575.5,
    );
    floorMap["519.5; 1593.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 519.5,
      y: 1593.5,
    );
    floorMap["694.5; 1485.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 694.5,
      y: 1485.5,
    );
    floorMap["624.5; 1385.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 624.5,
      y: 1385.5,
    );
    floorMap["450.5; 1180.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 450.5,
      y: 1180.5,
    );
    floorMap["531.5; 1153.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 531.5,
      y: 1153.5,
    );
    floorMap["884.5; 1200.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 884.5,
      y: 1200.5,
    );
    floorMap["694.5; 1161.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 694.5,
      y: 1161.5,
    );
    floorMap["527.5; 1093.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 527.5,
      y: 1093.5,
    );
    floorMap["707.5; 1054.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 707.5,
      y: 1054.5,
    );
    floorMap["864.5; 1052.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 864.5,
      y: 1052.5,
    );
    floorMap["462.5; 871.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 462.5,
      y: 871.5,
    );
    floorMap["705.5; 872.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 705.5,
      y: 872.5,
    );
    floorMap["444.5; 790.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 444.5,
      y: 790.5,
    );
    floorMap["782.5; 792.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 782.5,
      y: 792.5,
    );
    floorMap["873.5; 654.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 873.5,
      y: 654.5,
    );
    floorMap["605.5; 671.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 605.5,
      y: 671.5,
    );
    floorMap["370.5; 691.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 370.5,
      y: 691.5,
    );
    floorMap["361.5; 566.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 361.5,
      y: 566.5,
    );
    floorMap["704.5; 581.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 704.5,
      y: 581.5,
    );
    floorMap["518.5; 676.5"] = FloorWidgetModel(
      kind: FloorEnum.rest,
      x: 518.5,
      y: 676.5,
    );
    floorMap["432.5; 482.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 432.5,
      y: 482.5,
    );
    floorMap["611.5; 456.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 611.5,
      y: 456.5,
    );
    floorMap["789.5; 469.5"] = FloorWidgetModel(
      kind: FloorEnum.enemy,
      x: 789.5,
      y: 469.5,
    );
    floorMap["451.5; 350.5"] = FloorWidgetModel(
      kind: FloorEnum.rest,
      x: 451.5,
      y: 350.5,
    );
    floorMap["682.5; 352.5"] = FloorWidgetModel(
      kind: FloorEnum.rest,
      x: 682.5,
      y: 352.5,
    );
    floorMap["862.5; 392.5"] = FloorWidgetModel(
      kind: FloorEnum.rest,
      x: 862.5,
      y: 392.5,
    );
    floorMap["629.5; 183.5"] = FloorWidgetModel(
      kind: FloorEnum.boss,
      x: 629.5,
      y: 183.5,
    );
    floorMap["377.5; 354.5"] = FloorWidgetModel(
      kind: FloorEnum.rest,
      x: 377.5,
      y: 354.5,
    );

    _floorWidgetModelList.addAll(
      floorMap.values,
    );

    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["353.5; 1804.5"]!,
        floorWidgetModel1: floorMap["727.5; 1853.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["727.5; 1853.5"]!,
        floorWidgetModel1: floorMap["537.5; 1755.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["614.5; 1773.5"]!,
        floorWidgetModel1: floorMap["727.5; 1853.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["727.5; 1853.5"]!,
        floorWidgetModel1: floorMap["765.5; 1791.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["881.5; 1758.5"]!,
        floorWidgetModel1: floorMap["727.5; 1853.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["353.5; 1804.5"]!,
        floorWidgetModel1: floorMap["358.5; 1667.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["358.5; 1667.5"]!,
        floorWidgetModel1: floorMap["367; 1569.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["367; 1569.5"]!,
        floorWidgetModel1: floorMap["445.5; 1481.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["445.5; 1481.5"]!,
        floorWidgetModel1: floorMap["543; 1371.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["543; 1371.5"]!,
        floorWidgetModel1: floorMap["432.5; 1255.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["432.5; 1255.5"]!,
        floorWidgetModel1: floorMap["366; 1152.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["366; 1152.5"]!,
        floorWidgetModel1: floorMap["349.5; 1094.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["349.5; 1094.5"]!,
        floorWidgetModel1: floorMap["365; 961.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["365; 961.5"]!,
        floorWidgetModel1: floorMap["462.5; 871.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["462.5; 871.5"]!,
        floorWidgetModel1: floorMap["444.5; 790.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["444.5; 790.5"]!,
        floorWidgetModel1: floorMap["370.5; 691.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["370.5; 691.5"]!,
        floorWidgetModel1: floorMap["361.5; 566.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["361.5; 566.5"]!,
        floorWidgetModel1: floorMap["353; 490.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["353; 490.5"]!,
        floorWidgetModel1: floorMap["377.5; 354.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["377.5; 354.5"]!,
        floorWidgetModel1: floorMap["629.5; 183.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["629.5; 183.5"]!,
        floorWidgetModel1: floorMap["862.5; 392.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["862.5; 392.5"]!,
        floorWidgetModel1: floorMap["789.5; 469.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["789.5; 469.5"]!,
        floorWidgetModel1: floorMap["847.5; 595.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["847.5; 595.5"]!,
        floorWidgetModel1: floorMap["873.5; 654.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["873.5; 654.5"]!,
        floorWidgetModel1: floorMap["782.5; 792.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["782.5; 792.5"]!,
        floorWidgetModel1: floorMap["705.5; 872.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["705.5; 872.5"]!,
        floorWidgetModel1: floorMap["778; 988.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["778; 988.5"]!,
        floorWidgetModel1: floorMap["864.5; 1052.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["864.5; 1052.5"]!,
        floorWidgetModel1: floorMap["884.5; 1200.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["884.5; 1200.5"]!,
        floorWidgetModel1: floorMap["870.5; 1278.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["870.5; 1278.5"]!,
        floorWidgetModel1: floorMap["798; 1374.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["798; 1374.5"]!,
        floorWidgetModel1: floorMap["694.5; 1485.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["694.5; 1485.5"]!,
        floorWidgetModel1: floorMap["768; 1583.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["768; 1583.5"]!,
        floorWidgetModel1: floorMap["778.5; 1653.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["778.5; 1653.5"]!,
        floorWidgetModel1: floorMap["881.5; 1758.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["358.5; 1667.5"]!,
        floorWidgetModel1: floorMap["431.5; 1575.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["431.5; 1575.5"]!,
        floorWidgetModel1: floorMap["536; 1463.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["536; 1463.5"]!,
        floorWidgetModel1: floorMap["543; 1371.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["543; 1371.5"]!,
        floorWidgetModel1: floorMap["541; 1276.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["541; 1276.5"]!,
        floorWidgetModel1: floorMap["531.5; 1153.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["531.5; 1153.5"]!,
        floorWidgetModel1: floorMap["527.5; 1093.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["527.5; 1093.5"]!,
        floorWidgetModel1: floorMap["467; 971.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["467; 971.5"]!,
        floorWidgetModel1: floorMap["462.5; 871.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["629.5; 183.5"]!,
        floorWidgetModel1: floorMap["682.5; 352.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["682.5; 352.5"]!,
        floorWidgetModel1: floorMap["789.5; 469.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["682.5; 352.5"]!,
        floorWidgetModel1: floorMap["611.5; 456.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["611.5; 456.5"]!,
        floorWidgetModel1: floorMap["704.5; 581.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["704.5; 581.5"]!,
        floorWidgetModel1: floorMap["605.5; 671.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["605.5; 671.5"]!,
        floorWidgetModel1: floorMap["525; 753.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["525; 753.5"]!,
        floorWidgetModel1: floorMap["540.5; 868.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["540.5; 868.5"]!,
        floorWidgetModel1: floorMap["539; 977.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["539; 977.5"]!,
        floorWidgetModel1: floorMap["527.5; 1093.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["527.5; 1093.5"]!,
        floorWidgetModel1: floorMap["603; 1176.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["603; 1176.5"]!,
        floorWidgetModel1: floorMap["623.5; 1267.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["623.5; 1267.5"]!,
        floorWidgetModel1: floorMap["624.5; 1385.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["624.5; 1385.5"]!,
        floorWidgetModel1: floorMap["694.5; 1485.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["537.5; 1755.5"]!,
        floorWidgetModel1: floorMap["443.5; 1662.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["443.5; 1662.5"]!,
        floorWidgetModel1: floorMap["431.5; 1575.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["614.5; 1773.5"]!,
        floorWidgetModel1: floorMap["608; 1676.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["608; 1676.5"]!,
        floorWidgetModel1: floorMap["519.5; 1593.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["519.5; 1593.5"]!,
        floorWidgetModel1: floorMap["536; 1463.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["765.5; 1791.5"]!,
        floorWidgetModel1: floorMap["701; 1658.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["701; 1658.5"]!,
        floorWidgetModel1: floorMap["768; 1583.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["624.5; 1385.5"]!,
        floorWidgetModel1: floorMap["536; 1463.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["432.5; 1255.5"]!,
        floorWidgetModel1: floorMap["450.5; 1180.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["450.5; 1180.5"]!,
        floorWidgetModel1: floorMap["463; 1094.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["463; 1094.5"]!,
        floorWidgetModel1: floorMap["467; 971.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["467; 971.5"]!,
        floorWidgetModel1: floorMap["540.5; 868.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["623.5; 1267.5"]!,
        floorWidgetModel1: floorMap["694.5; 1161.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["694.5; 1161.5"]!,
        floorWidgetModel1: floorMap["707.5; 1054.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["707.5; 1054.5"]!,
        floorWidgetModel1: floorMap["703; 988.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["703; 988.5"]!,
        floorWidgetModel1: floorMap["705.5; 872.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["705.5; 872.5"]!,
        floorWidgetModel1: floorMap["691; 776.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["691; 776.5"]!,
        floorWidgetModel1: floorMap["793; 690.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["793; 690.5"]!,
        floorWidgetModel1: floorMap["847.5; 595.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["540.5; 868.5"]!,
        floorWidgetModel1: floorMap["444.5; 790.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["444.5; 790.5"]!,
        floorWidgetModel1: floorMap["518.5; 676.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["518.5; 676.5"]!,
        floorWidgetModel1: floorMap["445.5; 594.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["445.5; 594.5"]!,
        floorWidgetModel1: floorMap["521.5; 483.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["521.5; 483.5"]!,
        floorWidgetModel1: floorMap["451.5; 350.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["451.5; 350.5"]!,
        floorWidgetModel1: floorMap["629.5; 183.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["377.5; 354.5"]!,
        floorWidgetModel1: floorMap["432.5; 482.5"]!,
      ),
    );
    _transitionWidgetModelList.add(
      TransitionWidgetModel(
        floorWidgetModel0: floorMap["432.5; 482.5"]!,
        floorWidgetModel1: floorMap["361.5; 566.5"]!,
      ),
    );

    // Rewritten from a forEach because of avoid_function_literals_in_foreach_calls
    for (final feFloorEnum in FloorEnum.valuesMid) {
      final floorWidgetModelSameKindList = _floorWidgetModelList
          .where(
            (
              wFloorWidget,
            ) =>
                wFloorWidget.kind == feFloorEnum,
          )
          .toList();

      floorWidgetModelSameKindList.sort(byY);

      // Rewritten from a forEach because of avoid_function_literals_in_foreach_calls
      for (var feIndexedFloorWidget in floorWidgetModelSameKindList.indexed) {
        feIndexedFloorWidget.$2.number = feIndexedFloorWidget.$1.toString();
      }
    }

    notifyListeners();
  }
}
