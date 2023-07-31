import 'dart:convert';

import 'package:blood_sugar_tracking/models/information/information.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformationNotifier extends ChangeNotifier {
  Information? _information;
   SharedPreferences? _prefs;
  Information informations = Information();

   List<Information> informationList = [];

  Information? get information => _information;

  InformationNotifier() {
    _initSharedPreferences();
  }
  Information? getUserData(String key) {
    final jsonString = _prefs?.getString(key);
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString);
      return Information.fromJson(jsonMap);
    }
    return null;
  }
  void saveUserData(String key, Information information) {
    final jsonString = json.encode(information.toJson());
    _prefs?.setString(key, jsonString);
    notifyListeners();
  }
  void saveInformationData(String key, Information information) {
    final jsonString = json.encode(information.toJson());
    _prefs?.setString(key, jsonString);
    notifyListeners();
  }

  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void setInformationData(Information information) {
    _information = information;
    notifyListeners();
  }
  void update(Information information) {
    _information = information;
    notifyListeners();
  }

}
