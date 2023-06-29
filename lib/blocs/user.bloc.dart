import 'package:flutter/material.dart';

class UserBloc extends ChangeNotifier {
  String? _output;

  String? get output => _output;

  set output(String? value) {
    _output = output;
    notifyListeners();
  }
}
