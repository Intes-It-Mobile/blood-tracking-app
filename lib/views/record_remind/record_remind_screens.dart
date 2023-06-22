import 'package:blood_sugar_tracking/alarm_helper.dart';
import 'package:blood_sugar_tracking/main.dart';
import 'package:blood_sugar_tracking/models/alarm_info/alarm_info.dart';
import 'package:blood_sugar_tracking/widgets/custom_alarm/time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../utils/locale/appLocalizations.dart';

class RecordRemindScreens extends StatefulWidget {
  final void Function(bool isToggled) onToggled;

  RecordRemindScreens({Key? key, required this.onToggled}) : super(key: key);

  @override
  State<RecordRemindScreens> createState() => _RecordRemindScreensState();
}

class _RecordRemindScreensState extends State<RecordRemindScreens> {
  DateTime? _alarmTime;
  late String _alarmTimeString;
  bool _isRepeatSelected = false;
  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>>? _alarms;
  List<AlarmInfo>? _currentAlarms;

  double size = 30;
  double innerPadding = 0;

  @override
  void initState() {
    _alarmTime = DateTime.now();
    _alarmHelper.initializeDatabase().then((value) {
      print('------database intialized');
      loadAlarms();
    });
    innerPadding = size / 10;
    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) setState(() {});
  }

  bool val1 = true;
  bool val2 = false;

  onChangeFuntion1(bool newValue1) {
    setState(() {
      val1 = newValue1;
    });
  }

  onChangeFuntion2(bool newValue2) {
    setState(() {
      val2 = newValue2;
    });
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<AlarmInfo>>(
                future: _alarms,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _currentAlarms = snapshot.data;
                    return ListView(
                      children: snapshot.data!.map<Widget>((alarm) {
                        var alarmTime =
                            DateFormat('hh:mm aa').format(alarm.alarmDateTime!);
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          margin: const EdgeInsets.only(bottom: 32),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: const BoxDecoration(
                            color: AppColors.AppColor3,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Text(
                                  alarmTime,
                                  style: AppTheme.hintText.copyWith(
                                      fontSize: 36,
                                      color: AppColors.AppColor4,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 2, right: 2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SvgPicture.asset(
                                                Assets.iconEditRecord),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                deleteAlarm(alarm.id);
                                              },
                                              child: SvgPicture.asset(
                                                  Assets.iconDelete),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                       Align(
                                        alignment: Alignment.centerRight,
                                        child: CustomSwitchTimer(context),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        );
                      }).followedBy([
                        if (_currentAlarms!.length < 5)
                          MaterialButton(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            onPressed: () {
                              _alarmTimeString =
                                  DateFormat('HH:mm').format(DateTime.now());
                              showDiaLog(context);
                              // scheduleAlarm();
                            },
                            child: Container(
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
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              )),
                            ),
                          )
                        else
                          const Center(
                              child: Text(
                            'Only 5 alarms allowed!',
                            style: TextStyle(color: Colors.white),
                          )),
                      ]).toList(),
                    );
                  }
                  return const Center(
                    child: Text(
                      'Loading..',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget hourMinute12H() {
    return TimePickerSpinner(
      itemHeight: 30,
      highlightedTextStyle: AppTheme.hintText
          .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
      normalTextStyle: AppTheme.hintText.copyWith(
          fontWeight: FontWeight.w700, color: Colors.black.withOpacity(0.5)),
      is24HourMode: true,
      onTimeChange: (time) {
        setState(() {
          _alarmTime = time;
        });
      },
    );
  }

  Widget CustomSwitchTimer(BuildContext context){
    return StatefulBuilder(builder: (context,setModalState){
      return  CupertinoSwitch(
        trackColor: AppColors.AppColor1,
        activeColor: AppColors.AppColor2,
        value: _isRepeatSelected,
        onChanged: (value) {
          setModalState(() {
            _isRepeatSelected = value;
          });
        },
      );
    });
  }

  Future<String?> showDiaLog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        content: StatefulBuilder(builder: (context, setModalState) {
          return SizedBox(
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
                          CustomSwitchTimer(context),
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
                          customSwitchDialog(val2, onChangeFuntion2),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 35,
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
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          onSaveAlarm(_isRepeatSelected);
                        },
                        child: Container(
                          height: 35,
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
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget customSwitchDialog(bool val, Function onChangeMethod) {
    return CupertinoSwitch(
      trackColor: AppColors.AppColor1,
      activeColor: AppColors.AppColor2,
      value: val,
      onChanged: (newValue) {
        onChangeMethod(newValue);
      },
    );
  }

  void scheduleAlarm(
      DateTime scheduledNotificationDateTime, AlarmInfo alarmInfo,
      {required bool isRepeating}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      channelDescription: 'Channel for Alarm notification',
      icon: 'codex_logo',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
      sound: 'a_long_cold_sting.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    if (isRepeating)
      await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Office',
        alarmInfo.title,
        Time(
          scheduledNotificationDateTime.hour,
          scheduledNotificationDateTime.minute,
          scheduledNotificationDateTime.second,
        ),
        platformChannelSpecifics,
      );
    else
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Office',
        alarmInfo.title,
        tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
  }

  void onSaveAlarm(bool _isRepeating) {
    DateTime? scheduleAlarmDateTime;
    if (_alarmTime!.isAfter(DateTime.now()))
      scheduleAlarmDateTime = _alarmTime;
    else
      scheduleAlarmDateTime = _alarmTime!.add(Duration(days: 1));

    var alarmInfo = AlarmInfo(
      alarmDateTime: scheduleAlarmDateTime,
      gradientColorIndex: _currentAlarms!.length,
      title: 'alarm',
    );
    _alarmHelper.insertAlarm(alarmInfo);
    if (scheduleAlarmDateTime != null) {
      scheduleAlarm(scheduleAlarmDateTime, alarmInfo,
          isRepeating: _isRepeating);
    }
    Navigator.pop(context);
    loadAlarms();
  }

  void deleteAlarm(int? id) {
    _alarmHelper.delete(id);
    //unsubscribe for notification
    loadAlarms();
  }
}

