import 'package:slay_the_spire_path_finder_mobile/models/floor_widget.model.dart';

class TransitionWidgetModel {
  final FloorWidgetModel floorWidgetModel0;
  final FloorWidgetModel floorWidgetModel1;

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
}
