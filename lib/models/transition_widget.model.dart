import 'package:slay_the_spire_path_finder_mobile/constants/floor.enum.dart';
import 'package:slay_the_spire_path_finder_mobile/models/floor_widget.model.dart';

class TransitionWidgetModel {
  final FloorWidgetModel floorWidgetModel0;
  final FloorWidgetModel floorWidgetModel1;

  FloorWidgetModel? enteringFloorWidgetModel;
  FloorWidgetModel? exitingFloorWidgetModel;

  TransitionWidgetModel({
    required this.floorWidgetModel0,
    required this.floorWidgetModel1,
  });

  @override
  int get hashCode => floorWidgetModel0.hashCode ^ floorWidgetModel1.hashCode;

  @override
  bool operator ==(
    Object other,
  ) {
    if (other is! TransitionWidgetModel) {
      return false;
    }

    return ((floorWidgetModel0 == other.floorWidgetModel0) &&
            (floorWidgetModel1 == other.floorWidgetModel1)) ||
        (floorWidgetModel0 == other.floorWidgetModel1) &&
            (floorWidgetModel1 == other.floorWidgetModel0);
  }

  bool hasEnteringAndExiting() =>
      (enteringFloorWidgetModel != null) && (exitingFloorWidgetModel != null);

  bool hasKind(
    FloorEnum kind,
  ) =>
      (floorWidgetModel0.kind == kind) || (floorWidgetModel1.kind == kind);

  toJson() => {
        "floorWidgetModel0": floorWidgetModel0.toJson(),
        "floorWidgetModel1": floorWidgetModel1.toJson(),
        "enteringFloorWidgetModel": enteringFloorWidgetModel?.toJson(),
        "exitingFloorWidgetModel": exitingFloorWidgetModel?.toJson(),
      };
}
