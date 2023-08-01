import 'dart:async';

import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_theme.dart';
import '../../utils/locale/appLocalizations.dart';

class GoalNearlyDialog extends StatefulWidget {
  const GoalNearlyDialog({super.key});

  @override
  State<GoalNearlyDialog> createState() => _GoalNearlyDialogState();
}

class _GoalNearlyDialogState extends State<GoalNearlyDialog> {
  int countDown = 5;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startCountDown();
  }

  void startCountDown() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timer) {
      if (countDown == 0) {
        // Đóng AlertDialog khi đếm về 0
        Navigator.of(context).pop();
        timer.cancel();
      } else {
        // Giảm giá trị đếm ngược
        setState(() {
          countDown--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 5),
        insetPadding: EdgeInsets.symmetric(horizontal: 35),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        content: StatefulBuilder(builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.33,
            // width: 300,
            child: Container(
              // color: Colors.amber,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 20),
                            height: 99,
                            width: 99,
                            child: Image.asset(
                              Assets.leadership,
                              fit: BoxFit.fill,
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "${AppLocalizations.of(context)!.getTranslate('goal_nearly_txt')}",
                          style: AppTheme.TextIntroline16Text.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.getTranslate('popup_will_close')} ",
                          style: AppTheme.appBodyTextStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "$countDown",
                          style: AppTheme.appBodyTextStyle.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
