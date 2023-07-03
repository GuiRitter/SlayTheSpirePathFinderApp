import 'package:flutter/material.dart';

class UserBloc extends ChangeNotifier {
  String? _output;

  String? get output => _output;

  clearPaths() {
    _output = null;
    notifyListeners();
  }

  findPaths(String graph) {
    // TODO
    _output = "Hello, World!";
    notifyListeners();
  }
}
