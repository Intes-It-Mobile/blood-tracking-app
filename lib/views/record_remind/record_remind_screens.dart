import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../utils/locale/appLocalizations.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/tile.dart';
import '../edit_alarm/edit_alarm.dart';

class ExampleAlarmHomeScreen extends StatefulWidget {
  ExampleAlarmHomeScreen({Key? key}) : super(key: key);

  @override
  State<ExampleAlarmHomeScreen> createState() => _ExampleAlarmHomeScreenState();
}

class _ExampleAlarmHomeScreenState extends State<ExampleAlarmHomeScreen> {
  late List<dynamic> alarms;
  DateTime? alarmTime;
  static StreamSubscription? subscription;
  bool check = false;

  @override
  void initState() {
    super.initState();
    loadAlarms();
    // subscription ??= Alarm.ringStream.stream.listen(
    //   (alarmSettings) => navigateToRingScreen(alarmSettings),
    // );
  }

  String savedDateString(DateTime date) {
    print("conver time: ${DateFormat("HH:mm").format(date)}");
    return DateFormat("HH:mm").format(date);
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) =>
          (savedDateString(a.dateTime)).compareTo(savedDateString(b.dateTime)));
    });
  }

  // Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
  //   await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) =>
  //             ExampleAlarmRingScreen(alarmSettings: alarmSettings),
  //       ));
  //   loadAlarms();
  // }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: 400,
              height: MediaQuery.of(context).size.height * 0.30,
              child: ExampleAlarmEditScreen(
                alarmSettings: settings,
              ),
            ),
          );
        });

    if (res != null && res == "set") {
      loadAlarms();
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        backgroundColor: AppColors.AppColor2,
        title: Column(
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
                      height: 40,
                      width: 40,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${AppLocalizations.of(context)!.getTranslate('record_remind')}",
                    style: AppTheme.Headline20Text, // Hiển thị dấu chấm ba khi có tràn
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: alarms.isNotEmpty
                    ? ListView.separated(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      itemCount: alarms.length,
                      separatorBuilder: (context, index) => Container(),
                      itemBuilder: (context, index) {
                        var alarmTime = DateFormat('HH:mm')
                            .format(alarms[index].dateTime);
                        print("aaaaaa: ${alarmTime}");

                        print("looAudio: ${alarms[index].loopAudio}");
                        // print("loopAudio: ${loopAudio}");
                        return Container(
                          height:
                              MediaQuery.of(context).size.height * 0.13,
                          margin: const EdgeInsets.only(
                              top: 15, left: 17, right: 17),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.AppColor3),
                          child: ExampleAlarmTile(
                            key: Key(alarms[index].id.toString()),
                            title: alarmTime,
                            onPressed: () async {
                              navigateToAlarmScreen(alarms[index]);
                            },
                            onDismissed: () {
                              Alarm.stopDelete(alarms[index].id)
                                  .then((_) => loadAlarms());
                            },
                            loopAudio: alarms[index].loopAudio,
                            onDelete: () {
                              Alarm.stopDelete(alarms[index].id)
                                  .then((_) => loadAlarms());
                            },
                            onLoopAudioChanged: (loopAudio) {
                              alarms[index].loopAudio = loopAudio;
                              var _alarmSettings =
                                  Alarm.getAlarm(alarms[index].id);
                              if (_alarmSettings != null) {
                                Alarm.set(
                                    alarmSettings: AlarmSettings(
                                  id: _alarmSettings.id,
                                  dateTime: _alarmSettings.dateTime,
                                  loopAudio: loopAudio,
                                  soundAudio: _alarmSettings.soundAudio,
                                  vibrate: _alarmSettings.vibrate,
                                  notificationTitle: loopAudio
                                      ? _alarmSettings.notificationTitle
                                      : null,
                                  notificationBody: loopAudio
                                      ? _alarmSettings.notificationBody
                                      : null,
                                  assetAudioPath: '.',
                                  fadeDuration: 3.0,
                                  stopOnNotificationOpen: true,
                                  enableNotificationOnKill: true,
                                ));
                              }
                            },
                            //   onSwitch: (bool v) {
                            //   alarms[index].loopAudio = false;
                            //
                            //   setState(() {
                            //
                            //   });
                            // },
                          ),
                        );
                      },
                    )
                    : Center(
                        child: Text(
                          "${AppLocalizations.of(context)!.getTranslate('no_alarms_set')}",
                          style: AppTheme.Headline20Text.copyWith(color: Colors.black), // Hiển thị dấu chấm ba khi có tràn
                        ),
                      ),
              ),
              ButtonWidget(
                mainAxisSizeMin: true,
                btnText: "new_alarm",
                btnColor: AppColors.AppColor2,
             //   suffixIconPath: Assets.iconEditBtn,
                onTap: () {
                  navigateToAlarmScreen(null);
                },
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget hourMinute12H(AlarmSettings alarmSettings) {
    return TimePickerSpinner(
      itemHeight: 30,
      highlightedTextStyle: AppTheme.hintText
          .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
      normalTextStyle: AppTheme.hintText.copyWith(
          fontWeight: FontWeight.w700, color: Colors.black.withOpacity(0.5)),
      is24HourMode: true,
      onTimeChange: (time) {
        setState(() {
          alarmSettings.dateTime = time;
        });
      },
    );
  }
}
