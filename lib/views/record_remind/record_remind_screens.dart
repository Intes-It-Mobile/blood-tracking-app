import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../utils/locale/appLocalizations.dart';

class RecordRemindScreens extends StatefulWidget {
  final void Function(bool isToggled) onToggled;

  RecordRemindScreens({Key? key, required this.onToggled}) : super(key: key);

  @override
  State<RecordRemindScreens> createState() => _RecordRemindScreensState();
}

class _RecordRemindScreensState extends State<RecordRemindScreens> {
  List<RecordRemind> recordRemind = [
    RecordRemind(hour: 16, minute: 00),
    RecordRemind(hour: 20, minute: 00),
  ];
  bool isToggled = false;
  double size = 30;
  double innerPadding = 0;

  @override
  void initState() {
    innerPadding = size / 10;
    super.initState();
  }

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
                      "${AppLocalizations.of(context)!.getTranslate('record_remind')}",
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
      body: Padding(
        padding: EdgeInsets.only(
            top: 20,
            right: 10,
            left: 10,
            bottom: MediaQuery.of(context).padding.bottom + Get.height * 0.09),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: ListView.builder(
                  itemCount: recordRemind.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(left: 5, right: 5, top: 15),
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.AppColor3,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                '${recordRemind[index].hour}' +
                                    ' : ' +
                                    '${recordRemind[index].minute.toString().padLeft(2, '0')}',
                                style: AppTheme.hintText.copyWith(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.AppColor4),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 14),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              _showDiaLog(context);
                                            },
                                            child: SvgPicture.asset(
                                                Assets.iconEditRecord)),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        SvgPicture.asset(Assets.iconDelete),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(
                                              () => isToggled = !isToggled);
                                          widget.onToggled(isToggled);
                                        },
                                        onPanEnd: (b) {
                                          setState(
                                              () => isToggled = !isToggled);
                                          widget.onToggled(isToggled);
                                        },
                                        child: AnimatedContainer(
                                          height: 34,
                                          width: 58,
                                          padding: EdgeInsets.all(innerPadding),
                                          alignment: isToggled
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight,
                                          duration:
                                              const Duration(milliseconds: 400),
                                          curve: Curves.easeOut,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: isToggled
                                                ? AppColors.AppColor1
                                                : AppColors.AppColor2,
                                          ),
                                          child: Container(
                                            width: size,
                                            height: size,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: isToggled
                                                  ? Colors.white
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    );
                  }),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.32,
              decoration: BoxDecoration(
                  color: AppColors.AppColor2,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                  child: Text(
                "${AppLocalizations.of(context)!.getTranslate('new_alarm')}",
                style: AppTheme.hintText.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              )),
            )
          ],
        ),
      ),
    );
  }

  Future<String?> _showDiaLog(BuildContext context) {
    DateTime dateTime = DateTime.now();


    Widget hourMinute12H() {
      return TimePickerSpinner(

        itemHeight: 30,
        highlightedTextStyle: AppTheme.hintText.copyWith(fontWeight: FontWeight.w700,color: Colors.black),
        normalTextStyle: AppTheme.hintText.copyWith(fontWeight: FontWeight.w700,color: Colors.black.withOpacity(0.5)),
        is24HourMode: true,
        onTimeChange: (time) {
          setState(() {
            dateTime = time;
          });
        },
      );
    }

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.27,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "${AppLocalizations.of(context)!.getTranslate('set_alarm')}",
                  style: AppTheme.hintText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.AppColor4),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Center(child: hourMinute12H()),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.getTranslate('sound')}",
                          style: AppTheme.hintText.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() => isToggled = !isToggled);
                            widget.onToggled(isToggled);
                          },
                          onPanEnd: (b) {
                            setState(() => isToggled = !isToggled);
                            widget.onToggled(isToggled);
                          },
                          child: AnimatedContainer(
                            height: 34,
                            width: 58,
                            padding: EdgeInsets.all(innerPadding),
                            alignment: isToggled
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: isToggled
                                  ? AppColors.AppColor1
                                  : AppColors.AppColor2,
                            ),
                            child: Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: isToggled ? Colors.white : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "${AppLocalizations.of(context)!.getTranslate('vibrate')}",
                          style: AppTheme.hintText.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() => isToggled = !isToggled);
                            widget.onToggled(isToggled);
                          },
                          onPanEnd: (b) {
                            setState(() => isToggled = !isToggled);
                            widget.onToggled(isToggled);
                          },
                          child: AnimatedContainer(
                            height: 34,
                            width: 58,
                            padding: EdgeInsets.all(innerPadding),
                            alignment: isToggled
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: isToggled
                                  ? AppColors.AppColor1
                                  : AppColors.AppColor2,
                            ),
                            child: Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: isToggled ? Colors.white : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.31,
                    decoration: BoxDecoration(
                        color: AppColors.AppColor3,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        "${AppLocalizations.of(context)!.getTranslate('cancel')}",
                        style: AppTheme.hintText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.AppColor2),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.31,
                    decoration: BoxDecoration(
                        color: AppColors.AppColor2,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        "${AppLocalizations.of(context)!.getTranslate('set')}",
                        style: AppTheme.hintText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RecordRemind {
  final int hour;
  final int minute;

  RecordRemind({required this.hour, required this.minute});
}
