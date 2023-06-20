// ignore_for_file: prefer_const_constructors

import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/views/home/home_screen.dart';
import 'package:blood_sugar_tracking/views/splash/splash_intro.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../routes.dart';
import '../../widgets/share_local.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Assets assets;

  nextPage() async {
    await Future.delayed(const Duration(seconds: 2), () {
      shareLocal.getBools("isFirst") == true
          ? Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.home,
              (route) => false,
            )
          : Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.intro,
              (route) => false,
            );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    nextPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Assets.splash), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 76, top: 680),
              width: 301,
              child: LinearPercentIndicator(
                progressColor: AppColors.AppColor3,
                backgroundColor: AppColors.AppColor4,
                animation: true,
                animationDuration: 2250,
                lineHeight: 12,
                percent: 1,
                // value: ,
              ),
            )
          ],
        ),
      ),
    );
  }
}
