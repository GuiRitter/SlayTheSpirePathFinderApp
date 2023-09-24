import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slay_the_spire_path_finder_mobile/blocs/user.bloc.dart';
import 'package:slay_the_spire_path_finder_mobile/constants/settings.dart';
import 'package:slay_the_spire_path_finder_mobile/models/floor_widget.model.dart';
import 'package:slay_the_spire_path_finder_mobile/models/transition_widget.model.dart';
import 'package:slay_the_spire_path_finder_mobile/ui/pages/home.page.dart';

class MapWidget extends StatelessWidget {
  final List<TransitionWidgetModel> transitionWidgetModelList;
  final List<FloorWidgetModel> floorWidgetModelList;

  const MapWidget({
    super.key,
    required this.transitionWidgetModelList,
    required this.floorWidgetModelList,
  });

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

  @override
  Widget build(
    BuildContext context,
  ) {
    final userBloc = Provider.of<UserBloc>(
      context,
    );

    return Stack(
      children: [
        userBloc.image!,
        ...transitionWidgetModelList.map(
          (
            transitionWidgetModel,
          ) {
            final distance = sqrt(
              pow(
                    transitionWidgetModel.floorWidgetModel0.x -
                        transitionWidgetModel.floorWidgetModel1.x,
                    2,
                  ) +
                  pow(
                    transitionWidgetModel.floorWidgetModel0.y -
                        transitionWidgetModel.floorWidgetModel1.y,
                    2,
                  ),
            );

            final center0 = getPoint(
              floorWidgetModel: transitionWidgetModel.floorWidgetModel0,
            );

            final center1 = getPoint(
              floorWidgetModel: transitionWidgetModel.floorWidgetModel1,
            );

            final center = Point(
              (center0.x + center1.x) / 2,
              (center0.y + center1.y) / 2,
            );

            final angle = atan2(center1.y - center0.y, center1.x - center0.x);

            return Positioned(
              left: center.x - (distance / 2),
              top: center.y - Settings.materialBaselineGridSizeHalf,
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
        ...floorWidgetModelList.map(
          (
            floorWidgetModel,
          ) =>
              Positioned(
            left: floorWidgetModel.x,
            top: floorWidgetModel.y,
            child: Text(
              "${floorWidgetModel.kind.name}${(kDebugMode && (floorWidgetModel.number?.isNotEmpty ?? false)) ? floorWidgetModel.number : ""}",
              style: userBloc.isFocused(floorWidgetModel: floorWidgetModel)
                  ? floorWidgetFocusStyle
                  : floorWidgetBlurStyle,
            ),
          ),
        )
      ],
    );
  }
}
