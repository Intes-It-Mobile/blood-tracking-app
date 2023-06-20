import 'package:blood_sugar_tracking/views/edit_range/edit_range_screens.dart';
import 'package:blood_sugar_tracking/views/history/record_history.dart';
import 'package:blood_sugar_tracking/views/home/home_screen.dart';
import 'package:blood_sugar_tracking/views/infomation/information_detail_screen.dart';
import 'package:blood_sugar_tracking/views/new_record/new_record_screen.dart';
import 'package:blood_sugar_tracking/views/record_remind/record_remind_screens.dart';
import 'package:blood_sugar_tracking/views/setting/abt_us_screen.dart';
import 'package:blood_sugar_tracking/views/splash/splash_intro.dart';
import 'package:blood_sugar_tracking/views/splash/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String home = '/home';
  static const String detail_info = '/detail_info';
  static const String abt_us = '/abt_us';
  static const String new_record = '/new_record';
  static const String edit_range = '/edit_range';
  static const String record_remind = '/record_remind';
  static const String intro = '/splash_intro';
  static const String history = "/record_history";

  static final routes = <String, WidgetBuilder>{
    splash: (context) => SplashScreen(),
    home: (context) => HomeScreen(),
    detail_info: (context) => DetailInformationScreen(),
    abt_us: (context) => AboutUsScreen(),
    new_record: (context) => NewRecordScreen(),
    edit_range: (context) => EditRangeScreens(),
    record_remind: (context) => RecordRemindScreens(onToggled: (bool isToggled) {  },),
    intro: (context) => IntroScreen(),
    history: (context) => RecordHistory(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    return CupertinoPageRoute(builder: (context) => routes[settings.name]!(context), settings: settings);
  }

  static bool isScreenNameExisted(String screenName) {
    return routes.containsKey(screenName);
  }
}
