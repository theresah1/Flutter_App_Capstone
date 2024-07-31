import 'dart:math';
import 'package:flutter/material.dart';

class SharedData extends ChangeNotifier {
  List<double> _phValues = List.generate(10, (index) => Random().nextDouble() * 14);

  List<double> get phValues => _phValues;

  void updatePhValues() {
    _phValues = List.generate(10, (index) => Random().nextDouble() * 14);
    notifyListeners();
  }
}
