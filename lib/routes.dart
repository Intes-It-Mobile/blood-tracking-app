import 'package:blood_sugar_tracking/views/edit_range/edit_range_screens.dart';
import 'package:blood_sugar_tracking/views/heart_rate/edit_record_heart_rate/edit_record_heart_rate.dart';
import 'package:blood_sugar_tracking/views/heart_rate/history_heart_rate/history_heart_rate.dart';
import 'package:blood_sugar_tracking/views/history/record_history.dart';
import 'package:blood_sugar_tracking/views/home/home_screen.dart';
import 'package:blood_sugar_tracking/views/infomation/information_detail_screen.dart';
import 'package:blood_sugar_tracking/views/record/edit_record_screen.dart';
import 'package:blood_sugar_tracking/views/record/new_record_screen.dart';
import 'package:blood_sugar_tracking/views/record_remind/record_remind_screens.dart';
import 'package:blood_sugar_tracking/views/select_unit/select_unit_screen.dart';
import 'package:blood_sugar_tracking/views/setting/abt_us_screen.dart';
import 'package:blood_sugar_tracking/views/splash/splash_intro.dart';
import 'package:blood_sugar_tracking/views/splash/splash_screen.dart';
import 'package:flutter/cupertino.dart';

import 'views/heart_rate/new_record_heart_rate/new_record_heart_rate.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String home = '/home';
  static const String detail_info = '/detail_info';
  static const String abt_us = '/abt_us';
  static const String new_record = '/new_record';
  static const String edit_record = '/edit_record';
  static const String edit_range = '/edit_range';
  static const String record_remind = '/record_remind';
  static const String intro = '/splash_intro';
  static const String select_unit = '/select_unit';
  static const String history = "/record_history";
  static const String history_heart_rate = "/history_heart_rate";
  static const String edit_record_heart_rate = "/edit_record_heart_rate";
  static const String new_record_heart_rate = "/new_record_heart_rate";

  static final routes = <String, WidgetBuilder>{
    splash: (context) => SplashScreen(),
    home: (context) => HomeScreen(),
    detail_info: (context) => DetailInformationScreen(),
    abt_us: (context) => AboutUsScreen(),
    new_record: (context) => NewRecordScreen(),
    edit_record: (context) => EditRecordScreen(),
    edit_range: (context) => EditRangeScreens(),
    record_remind: (context) => ExampleAlarmHomeScreen(),
    intro: (context) => IntroScreen(),
    history: (context) => RecordHistory(),
    select_unit: (context) => SelectUnit(),
    history_heart_rate: (context) => HistoryHeartRateScreen(),
    edit_record_heart_rate: (context) => EditRecordHeartRateScreen(), 
    new_record_heart_rate: (context) => NewRecordHeartRateScreen(), 
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    return CupertinoPageRoute(builder: (context) => routes[settings.name]!(context), settings: settings);
  }

  static bool isScreenNameExisted(String screenName) {
    return routes.containsKey(screenName);
  }
}
