

import 'package:blood_sugar_tracking/widgets/share_local.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = Locale('en');


  Locale get appLocal => _appLocale ?? Locale("en");
  fetchLocale() async {
    if (shareLocal.getString('language_code') == null) {
      _appLocale = Locale('en');
      return Null;
    }
    _appLocale = Locale(shareLocal.getString('language_code')!);
    return Null;
  }


  void changeLanguage(Locale type) async {
    if (_appLocale == type) {
      return;
    }
    if (type == Locale("vi")) {
      _appLocale = Locale("vi");
      await shareLocal.putString('language_code', 'vi');
      await shareLocal.putString('countryCode', 'VI');
    } else if(type == Locale("en")){
      _appLocale = Locale("en");
      await shareLocal.putString('language_code', 'en');
      await shareLocal.putString('countryCode', 'EN');
    }else if(type == Locale("zh")){
      _appLocale = Locale("zh");
      await shareLocal.putString('language_code', 'zh');
      await shareLocal.putString('countryCode', 'CN');
    }else if(type == Locale("es")){
      _appLocale = Locale("es");
      await shareLocal.putString('language_code', 'es');
      await shareLocal.putString('countryCode', 'SP');
    }else{
      _appLocale = Locale("fr");
      await shareLocal.putString('language_code', 'fr');
      await shareLocal.putString('countryCode', 'FR');
    }
    notifyListeners();
  }
}
