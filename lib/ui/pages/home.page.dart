import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slay_the_spire_path_finder_mobile/blocs/user.bloc.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/floor.enum.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/operation.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/settings.dart';
import 'package:slay_the_spire_path_finder_mobile/main.dart';
import 'package:slay_the_spire_path_finder_mobile/models/floor_widget.model.dart';
import 'package:slay_the_spire_path_finder_mobile/ui/shared/formatters/decimal_text_input.formatter.dart';

const boxDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    stops: [
      0,
      0.2,
      0.8,
      1,
    ],
    colors: [
      Colors.transparent,
      Colors.white,
      Colors.white,
      Colors.transparent,
    ],
  ),
);

class HomePage extends StatelessWidget {
  static final floorWidgetSizeByEnum = <FloorEnum, Size>{};

  static const floorWidgetBlurStyle = TextStyle(
    color: Colors.white,
    fontSize: Settings.floorWidgetFontSize,
    fontWeight: FontWeight.bold,
  );

  static const floorWidgetFocusStyle = TextStyle(
    color: Colors.black,
    fontSize: Settings.floorWidgetFontSize,
    fontWeight: FontWeight.bold,
  );

  final controllerByEnum = {
    FloorEnum.unknown: TextEditingController(
      text: "1",
    ),
    FloorEnum.merchant: TextEditingController(
      text: "1",
    ),
    FloorEnum.treasure: TextEditingController(
      text: "1",
    ),
    FloorEnum.rest: TextEditingController(
      text: "1",
    ),
    FloorEnum.enemy: TextEditingController(
      text: "1",
    ),
    FloorEnum.elite: TextEditingController(
      text: "1",
    ),
  };

  final floorWidgetKeyByEnum = Map.fromEntries(
    FloorEnum.values.map(
      (
        floorEnum,
      ) =>
          MapEntry<FloorEnum, GlobalKey>(
        floorEnum,
        GlobalKey(),
      ),
    ),
  );

  final scrollKey = const PageStorageKey("PageStorageKey");

  HomePage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(
      context,
    )!;

    final fieldPadding = Theme.of(
          context,
        ).textTheme.labelLarge?.fontSize ??
        0.0;

    // final halfFieldPadding = fieldPadding / 2.0;

    final mediaSize = MediaQuery.of(
      context,
    ).size;

    final formKey = GlobalKey<FormState>();

    final userBloc = Provider.of<UserBloc>(
      context,
    );

    Widget? leading;
    final actionList = <Widget>[];

    if (userBloc.image == null) {
      actionList.add(
        IconButton(
          onPressed: () => loadImage(
            context: context,
          ),
          icon: const Icon(
            Icons.add,
          ),
        ),
      );
    } else if (userBloc.output?.isEmpty ?? true) {
      // TODO debug
      actionList.add(
        IconButton(
          onPressed: () => userBloc.buildScenario(),
          icon: const Icon(
            Icons.settings,
          ),
        ),
      );
      actionList.add(
        IconButton(
          onPressed: () => onFindPressed(
            context: context,
            formKey: formKey,
            l10n: l10n,
          ),
          icon: const Icon(
            Icons.send,
          ),
        ),
      );
      leading = BackButton(
        onPressed: () => onBackPressed(
          context: context,
        ),
      );
    } else {
      leading = BackButton(
        onPressed: () => onBackPressed(
          context: context,
        ),
      );
    }

    final childList = <Widget>[
      IntrinsicWidth(
        child: TextFormField(
          inputFormatters: [
            DecimalTextInputFormatter(
              floorEnum: FloorEnum.unknown,
            ),
          ],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.floorEnum(FloorEnum.unknown.name),
            hintText: l10n.floorEnum(FloorEnum.unknown.name),
          ),
          controller: controllerByEnum[FloorEnum.unknown],
        ),
      ),
      IntrinsicWidth(
        child: TextFormField(
          inputFormatters: [
            DecimalTextInputFormatter(
              floorEnum: FloorEnum.merchant,
            ),
          ],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.floorEnum(FloorEnum.merchant.name),
            hintText: l10n.floorEnum(FloorEnum.merchant.name),
          ),
          controller: controllerByEnum[FloorEnum.merchant],
        ),
      ),
      IntrinsicWidth(
        child: TextFormField(
          inputFormatters: [
            DecimalTextInputFormatter(
              floorEnum: FloorEnum.treasure,
            ),
          ],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.floorEnum(FloorEnum.treasure.name),
            hintText: l10n.floorEnum(FloorEnum.treasure.name),
          ),
          controller: controllerByEnum[FloorEnum.treasure],
        ),
      ),
      IntrinsicWidth(
        child: TextFormField(
          inputFormatters: [
            DecimalTextInputFormatter(
              floorEnum: FloorEnum.rest,
            ),
          ],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.floorEnum(FloorEnum.rest.name),
            hintText: l10n.floorEnum(FloorEnum.rest.name),
          ),
          controller: controllerByEnum[FloorEnum.rest],
        ),
      ),
      IntrinsicWidth(
        child: TextFormField(
          inputFormatters: [
            DecimalTextInputFormatter(
              floorEnum: FloorEnum.enemy,
            ),
          ],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.floorEnum(FloorEnum.enemy.name),
            hintText: l10n.floorEnum(FloorEnum.enemy.name),
          ),
          controller: controllerByEnum[FloorEnum.enemy],
        ),
      ),
      IntrinsicWidth(
        child: TextFormField(
          inputFormatters: [
            DecimalTextInputFormatter(
              floorEnum: FloorEnum.elite,
            ),
          ],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.floorEnum(FloorEnum.elite.name),
            hintText: l10n.floorEnum(FloorEnum.elite.name),
          ),
          controller: controllerByEnum[FloorEnum.elite],
        ),
      ),
      IntrinsicWidth(
        child: InputDecorator(
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: l10n.operation,
          ),
          child: DropdownButton<Operation>(
            isDense: true,
            value: userBloc.operation,
            icon: const Icon(
              Icons.arrow_drop_down,
            ),
            isExpanded: true,
            onChanged: (
              value,
            ) =>
                onOperationChanged(
              context: context,
              value: value!,
            ),
            items: Operation.values
                .map(
                  (
                    operation,
                  ) =>
                      DropdownMenuItem<Operation>(
                    value: operation,
                    child: Text(
                      l10n.operationEnum(
                        operation.name,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    ];

    if (userBloc.operation == Operation.placeFloor) {
      childList.add(
        IntrinsicWidth(
          child: InputDecorator(
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: l10n.floor,
            ),
            child: DropdownButton<FloorEnum>(
              isDense: true,
              value: userBloc.floor,
              icon: const Icon(
                Icons.arrow_drop_down,
              ),
              isExpanded: true,
              onChanged: (
                value,
              ) =>
                  onFloorChanged(
                context: context,
                value: value!,
              ),
              items: FloorEnum.values
                  .map(
                    (
                      floor,
                    ) =>
                        DropdownMenuItem<FloorEnum>(
                      value: floor,
                      child: Text(
                        l10n.floorEnum(
                          floor.name,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );
    }

    childList.addAll(
      FloorEnum.values.map(
        (
          floorEnum,
        ) =>
            Offstage(
          offstage: true,
          child: Text(
            floorEnum.name,
            key: floorWidgetKeyByEnum[floorEnum],
            style: const TextStyle(
              fontSize: Settings.floorWidgetFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: leading,
        title: Text(
          l10n.title,
        ),
        actions: actionList,
      ),
      body: SizedBox(
        height: mediaSize.height,
        width: mediaSize.width,
        child: Padding(
          padding: EdgeInsets.all(
            Theme.of(
                  context,
                ).textTheme.labelLarge?.fontSize ??
                0,
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                FutureBuilder(
                  future: getWeightList(),
                  builder: (
                    buildContext,
                    snapshot,
                  ) =>
                      Wrap(
                    spacing: fieldPadding,
                    children: childList,
                  ),
                ),
                SizedBox.square(
                  dimension: fieldPadding,
                ),
                (userBloc.image == null)
                    ? Expanded(
                        child: Center(
                          child: Text(
                            l10n.imagePlaceHolder,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                          key: scrollKey,
                          child: GestureDetector(
                            onTapUp: (
                              tapUpDetails,
                            ) =>
                                onImageTapped(
                              context: context,
                              tapUpDetails: tapUpDetails,
                            ),
                            child: Stack(
                              children: [
                                userBloc.image!,
                                ...userBloc.transitionWidgetModelList.map(
                                  (
                                    transitionWidgetModel,
                                  ) {
                                    final distance = sqrt(
                                      pow(
                                            transitionWidgetModel
                                                    .floorWidgetModel0.x -
                                                transitionWidgetModel
                                                    .floorWidgetModel1.x,
                                            2,
                                          ) +
                                          pow(
                                            transitionWidgetModel
                                                    .floorWidgetModel0.y -
                                                transitionWidgetModel
                                                    .floorWidgetModel1.y,
                                            2,
                                          ),
                                    );

                                    final center0 = getPoint(
                                      floorWidgetModel: transitionWidgetModel
                                          .floorWidgetModel0,
                                    );

                                    final center1 = getPoint(
                                      floorWidgetModel: transitionWidgetModel
                                          .floorWidgetModel1,
                                    );

                                    final center = Point(
                                      (center0.x + center1.x) / 2,
                                      (center0.y + center1.y) / 2,
                                    );

                                    final angle = atan2(center1.y - center0.y,
                                        center1.x - center0.x);

                                    return Positioned(
                                      left: center.x - (distance / 2),
                                      top: center.y -
                                          Settings.materialBaselineGridSizeHalf,
                                      child: Transform.rotate(
                                        angle: angle,
                                        alignment: Alignment.center,
                                        child: SizedBox.fromSize(
                                          size: Size(
                                            distance,
                                            Settings.materialBaselineGridSize,
                                          ),
                                          child: Container(
                                            decoration: boxDecoration,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                ...userBloc.floorWidgetModelList.map(
                                  (
                                    floorWidgetModel,
                                  ) =>
                                      Positioned(
                                    left: floorWidgetModel.x,
                                    top: floorWidgetModel.y,
                                    child: Text(
                                      "${floorWidgetModel.kind.name}${(kDebugMode && (floorWidgetModel.number?.isNotEmpty ?? false)) ? floorWidgetModel.number : ""}",
                                      style: userBloc.isFocused(
                                              floorWidgetModel:
                                                  floorWidgetModel)
                                          ? floorWidgetFocusStyle
                                          : floorWidgetBlurStyle,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Point<double> getPoint({
    required FloorWidgetModel floorWidgetModel,
  }) {
    return Point(
      floorWidgetModel.x +
          ((floorWidgetSizeByEnum[floorWidgetModel.kind]!.width) / 2),
      floorWidgetModel.y +
          ((floorWidgetSizeByEnum[floorWidgetModel.kind]!.height) / 2),
    );
  }

  Future<void> getWeightList() async {
    final prefs = await SharedPreferences.getInstance();
    // Rewritten from a forEach because of avoid_function_literals_in_foreach_calls
    for (var element in FloorEnum.valuesMid) {
      final weight = prefs.getDouble(
        element.name,
      );

      if (weight != null) {
        controllerByEnum[element]!.text = weight.toString();
      }
    }
  }

  loadImage({
    required BuildContext context,
  }) async {
    final userBloc = Provider.of<UserBloc>(
      context,
      listen: false,
    );

    final result = await FilePicker.platform.pickFiles();

    if ((result != null) && (result.files.single.bytes != null)) {
      final image = Image.memory(
        result.files.single.bytes!,
      );

      userBloc.setImage(
        image: image,
      );

      if (floorWidgetSizeByEnum.isEmpty) {
        // Rewritten from a forEach because of avoid_function_literals_in_foreach_calls
        for (var floorEnum in FloorEnum.values) {
          final key = floorWidgetKeyByEnum[floorEnum]!;

          if (context.mounted) {
            final size =
                (key.currentContext!.findRenderObject()! as RenderBox).size;

            floorWidgetSizeByEnum[floorEnum] = Size.copy(
              size,
            );
          }
        }
      }
    }
  }

  onBackPressed({
    required BuildContext context,
  }) {
    final userBloc = Provider.of<UserBloc>(
      context,
      listen: false,
    );

    if (userBloc.output?.isNotEmpty ?? false) {
      userBloc.clearPaths();
    } else {
      userBloc.clearImage();
    }
  }

  onFindPressed({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required AppLocalizations l10n,
  }) {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    final userBloc = Provider.of<UserBloc>(
      context,
      listen: false,
    );

    final result = userBloc.findPaths(
      weightMap: {
        FloorEnum.unknown: double.parse(
          controllerByEnum[FloorEnum.unknown]!.text,
        ),
        FloorEnum.merchant: double.parse(
          controllerByEnum[FloorEnum.merchant]!.text,
        ),
        FloorEnum.treasure: double.parse(
          controllerByEnum[FloorEnum.treasure]!.text,
        ),
        FloorEnum.rest: double.parse(
          controllerByEnum[FloorEnum.rest]!.text,
        ),
        FloorEnum.enemy: double.parse(
          controllerByEnum[FloorEnum.enemy]!.text,
        ),
        FloorEnum.elite: double.parse(
          controllerByEnum[FloorEnum.elite]!.text,
        ),
      },
      l10n: l10n,
    );

    if (result.message?.isNotEmpty ?? false) {
      showSnackBar(
        message: result.message,
      );
    }
  }

  onFloorChanged({
    required BuildContext context,
    required FloorEnum value,
  }) {
    final userBloc = Provider.of<UserBloc>(
      context,
      listen: false,
    );

    userBloc.setFloor(
      floor: value,
    );
  }

  onImageTapped({
    required BuildContext context,
    required TapUpDetails tapUpDetails,
  }) {
    final userBloc = Provider.of<UserBloc>(
      context,
      listen: false,
    );

    final size = floorWidgetSizeByEnum[userBloc.floor]!;

    userBloc.treatFloorWidgetAtLocation(
      x: tapUpDetails.localPosition.dx - (size.width / 2),
      y: tapUpDetails.localPosition.dy - (size.height / 2),
    );
  }

  onOperationChanged({
    required BuildContext context,
    required Operation value,
  }) {
    final userBloc = Provider.of<UserBloc>(
      context,
      listen: false,
    );

    userBloc.setOperation(
      operation: value,
    );
  }

  String? onValidateMap({
    required BuildContext context,
    required String? value,
  }) {
    final l10n = AppLocalizations.of(
      context,
    )!;

    if ((value == null) || value.isEmpty) {
      return l10n.mapNull;
    }

    return Settings.mapRegex.hasMatch("$value\n") ? null : l10n.mapRegexFail;
  }
}
