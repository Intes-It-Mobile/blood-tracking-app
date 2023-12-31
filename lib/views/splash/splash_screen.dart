// ignore_for_file: prefer_const_constructors

import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/views/home/home_screen.dart';
import 'package:blood_sugar_tracking/views/splash/splash_intro.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../routes.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/stores/sugar_info_store.dart';
import '../../models/sugar_info/sugar_info.dart';
import '../../widgets/share_local.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SugarInfoStore? sugarInfoStore;
  SugarInfo? data;
  late Assets assets;
  final String jsonPath = 'assets/json/default_conditions.json';
  nextPage() async {
    await Future.delayed(const Duration(seconds: 3), () {
      print("${shareLocal.getBools("isFirst")}");

      shareLocal.getBools("isFirst") == true
          ? Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.home,
              (route) => false,
            )
          : Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.language_page,
              (route) => false,
            ).then((value) {
              FirebaseAnalytics.instance.logEvent(name: 'first_open');
            });
      ;
    });
  }

  @override
  void initState() {
    loadJsonData();
    // TODO: implement initState
    nextPage();

    super.initState();
  }

  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    sugarInfoStore!.getIsSwapedToMol();
    sugarInfoStore!.getListRecords();
    sugarInfoStore!.getGoalAmountFromSharedPreferences();
    sugarInfoStore!.getSugarRecordGoal();
    super.didChangeDependencies();
  }

  Future<String> getJson() {
    return rootBundle.loadString(jsonPath);
  }

  Future<void> saveDataToSharedPreferences(String jsonData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('json_data', jsonData);
  }

  Future<void> getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('json_data');
    if (jsonData != null) {
      Map<String, dynamic> json = jsonDecode(jsonData);
      setState(() {
        data = SugarInfo.fromJson(json);
        sugarInfoStore!.getRootSugarInfo(data);
      });
    }
  }

  void loadJsonData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoaded = prefs.getBool('json_loaded');
    if (isLoaded == null || !isLoaded) {
      String jsonData = await getJson();
      saveDataToSharedPreferences(jsonData);
      prefs.setBool('json_loaded', true);
      setState(() {
        data = SugarInfo.fromJson(jsonDecode(jsonData));
        sugarInfoStore!.getRootSugarInfo(data);
      });
    } else {
      getDataFromSharedPreferences();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Assets.splash), fit: BoxFit.cover)),
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(horizontal: 37),
          margin: EdgeInsets.only(bottom: 76),
          child: LinearPercentIndicator(
            progressColor: AppColors.AppColor3,
            backgroundColor: AppColors.AppColor4,
            animation: true,
            animationDuration: 2250,
            lineHeight: 12,
            percent: 1,
            // value: ,
          ),
        ),
      ),
    );
  }
}
