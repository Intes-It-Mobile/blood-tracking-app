import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_switch/sliding_switch.dart';

import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../utils/locale/appLocalizations.dart';

class RecordRemindScreens extends StatefulWidget {
  const RecordRemindScreens({Key? key}) : super(key: key);

  @override
  State<RecordRemindScreens> createState() => _RecordRemindScreensState();
}

class _RecordRemindScreensState extends State<RecordRemindScreens> {
  List<RecordRemind> recordRemind = [
    RecordRemind(hour: 16, minute: 00),
    RecordRemind(hour: 20, minute: 00),
  ];
  int _toggleValue = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        backgroundColor: AppColors.AppColor2,
        title: Container(
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: SvgPicture.asset(
                        Assets.iconBack,
                        height: 44,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${AppLocalizations.of(context)!.getTranslate(
                          'record_remind')}",
                      style: AppTheme.Headline20Text,
                      overflow: TextOverflow
                          .ellipsis, // Hiển thị dấu chấm ba khi có tràn
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: recordRemind.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(left: 16, right: 16, top: 20),
              height: 72,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.AppColor3,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('${recordRemind[index].hour}'+ ' : ' + '${recordRemind[index].minute.toString().padLeft(2,'0')}', style:
                           AppTheme.hintText.copyWith(fontSize: 36,fontWeight: FontWeight.w700,color: AppColors.AppColor4),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child:Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SvgPicture.asset(Assets.iconAlarm),
                            const SizedBox(width: 8,),
                            SvgPicture.asset(Assets.iconDelete),
                          ],
                        ),
                        SlidingSwitch(
                          value: false,
                          width: 90,
                          onChanged: (bool value) {
                            print(value);
                          },
                          height : 30,
                          animationDuration : const Duration(milliseconds: 400),
                          onTap:(){},
                          onDoubleTap:(){},
                          onSwipe:(){},
                          contentSize: 12,
                          colorOn : const Color(0xffdc6c73),
                          colorOff : const Color(0xff6682c0),
                          background : const Color(0xffe4e5eb),
                          buttonColor : const Color(0xfff7f5f7),
                          inactiveColor : const Color(0xff636f7b),
                        ),
                      ],
                    )
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class RecordRemind {
  final int hour;
  final int minute;

  RecordRemind({required this.hour, required this.minute});
}
