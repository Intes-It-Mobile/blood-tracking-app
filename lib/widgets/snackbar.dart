import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/assets.dart';
import '../main.dart';

class SnackBarWidget extends StatefulWidget {
  String? dateTime ="";
   SnackBarWidget({super.key,this.dateTime});

  @override
  State<SnackBarWidget> createState() => _SnackBarWidgetState();
}

String getPreviousRouteName(BuildContext context) {
  if (routeObserver.history.length >= 2) {
    // Lấy routeName của màn hình trước đó
    final previousRoute =
        routeObserver.history[routeObserver.history.length - 2];
    if (previousRoute.settings.name! != "/record_remind" &&
        previousRoute.settings.name! != "/home") {
      Navigator.of(context).pushNamed(Routes.record_remind);
      print("previos: ${previousRoute.settings.name!} ");
    }
    return previousRoute.settings.name!;
  }
  return "null"; // Nếu không có màn hình trước đó
}

class _SnackBarWidgetState extends State<SnackBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          getPreviousRouteName(context);
        },
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    child: Image.asset(Assets.alarmClock),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Remind",
                        style: AppTheme.appBodyTextStyle
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text("Enter a record",
                          style: AppTheme.timeText.copyWith(color: Colors.grey)),
                      SizedBox(
                        height: 8,
                      ),
                      Text("${widget.dateTime}",
                          style: AppTheme.timeText.copyWith(color: Colors.grey))
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                child: SvgPicture.asset(
                  Assets.iconX,
                  color: Colors.black,
                ),
                width: 20,
                height: 20,
              ),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}

extension NavigatorStateExtension on NavigatorState {
  void pushNamedIfNotCurrent(String routeName, {Object? arguments}) {
    if (!isCurrent(routeName)) {
      pushNamed(routeName, arguments: arguments);
    }
  }

  bool isCurrent(String routeName) {
    bool isCurrent = false;
    popUntil((route) {
      if (route.settings.name == routeName) {
        isCurrent = true;
      }
      return true;
    });
    return isCurrent;
  }
}
