import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/floor.enum.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/graph_regex.enum.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/result_status.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/settings.dart';
import 'package:slay_the_spire_path_finder_mobile/models/edge.model.dart';
import 'package:slay_the_spire_path_finder_mobile/models/floor.model.dart';
import 'package:slay_the_spire_path_finder_mobile/models/node.model.dart';
import 'package:slay_the_spire_path_finder_mobile/models/result.model.dart';

class UserBloc extends ChangeNotifier {
  String? _output;

  String? get output => _output;

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

    // TODO

    _output = "Hello, World!";
    notifyListeners();

    return ResultModel(
      status: ResultStatus.success,
    );
  }
}
