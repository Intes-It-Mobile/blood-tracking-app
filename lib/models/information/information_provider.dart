import 'package:blood_sugar_tracking/models/information/information.dart';
import 'package:flutter/material.dart';

class InformationNotifier extends ChangeNotifier {
  Information? _information;

  Information? get information => _information;

  void setInformationData(Information information) {
    _information = information;
    notifyListeners();
  }
}
