import 'package:slay_the_spire_path_finder_mobile/constants/result_status.dart';

class ResultModel<DataType> {
  final DataType? data;
  final ResultStatus status;
  final String? message;

  ResultModel({
    this.data,
    required this.status,
    this.message,
  });
}
