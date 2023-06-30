import 'dart:convert';

import 'package:blood_sugar_tracking/alarm_helper.dart';
import 'package:blood_sugar_tracking/main.dart';
import 'package:blood_sugar_tracking/models/alarm_info/alarm_info.dart';
import 'package:blood_sugar_tracking/widgets/custom_alarm/time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../utils/locale/appLocalizations.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class RecordRemindScreens extends StatefulWidget {
  final void Function(bool isToggled) onToggled;

  RecordRemindScreens({Key? key, required this.onToggled}) : super(key: key);

  @override
  State<RecordRemindScreens> createState() => _RecordRemindScreensState();
}

class _RecordRemindScreensState extends State<RecordRemindScreens> {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  DateTime? _alarmTime;
  DateTime? _alarmTime1;
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        child: FutureBuilder<List<AlarmInfo>>(
          future: _alarms,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _currentAlarms = snapshot.data;
              //  print("List: ${_currentAlarms?.map((e) => null)}");
              //   _currentAlarms?.forEach((e) => print(e.toMap()));
              return Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _currentAlarms?.length,
                      itemBuilder: (context, int index) {
                        if (_currentAlarms!.isNotEmpty) {
                          _currentAlarms!.sort((b, a) =>
                              (DateFormat('dd-MM-yyyy HH:mm').parse(
                                  "${a.alarmDateTime}}")).compareTo(
                                  DateFormat('dd-MM-yyyy HH:mm').parse("${b.alarmDateTime}")));
                        }
                        var alarmTime = DateFormat('hh:mm')
                            .format(_currentAlarms![index].alarmDateTime!);
                        print(alarmTime);
                        return Card(
                          child: Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.12,
                            //margin: const EdgeInsets.only(bottom: 32),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 4),
                            decoration: const BoxDecoration(
                              color: AppColors.AppColor3,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
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
                                              InkWell(
                                                onTap: () {
                                                  showDiaLogEdit(
                                                      context,
                                                      _currentAlarms![index]
                                                          .id);
                                                  print(_currentAlarms![index]);
                                                  // print(_currentAlarms![index].alarmDateTime);
                                                },
                                                child: SvgPicture.asset(
                                                    Assets.iconEditRecord),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  deleteAlarm(
                                                      _currentAlarms![index]
                                                          .id);
                                                },
                                                child: SvgPicture.asset(
                                                    Assets.iconDelete),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 13,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: StatefulBuilder(
                                            builder: (context, setModalState) {
                                              return CupertinoSwitch(
                                                onChanged: (bool value) {
                                                  setModalState(() {
                                                    _isRepeatSelected = value;
                                                  });
                                                },
                                                value: _isRepeatSelected,
                                                trackColor: AppColors.AppColor1,
                                                activeColor: AppColors
                                                    .AppColor2,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        );
                      }),
                  if (_currentAlarms!.length < 100)
                    MaterialButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      onPressed: () {
                        _alarmTimeString =
                            DateFormat('HH:mm').format(DateTime.now());
                        showDiaLog(context, null);
                        // scheduleAlarm();
                      },
                      child: Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.05,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.32,
                        decoration: BoxDecoration(
                            color: AppColors.AppColor2,
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                            child: Text(
                              "${AppLocalizations.of(context)!.getTranslate(
                                  'new_alarm')}",
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
                ],
              );
            }
            return Center(
              child: Text(
                'Loading..',
                style: TextStyle(color: Colors.white),
              ),
            );
          },
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


  Widget CustomSwitchTimer(BuildContext context, int? id) {
    return StatefulBuilder(builder: (context, setModalState) {
      print("id: ${id}");
      return CupertinoSwitch(
        trackColor: AppColors.AppColor1,
        activeColor: AppColors.AppColor2,
        onChanged: (value) {
          setModalState(() {
            _isRepeatSelected = value;
          });
        },
        value: _isRepeatSelected,
      );
    });
  }

  Future<String?> showDiaLog(BuildContext context, int? id) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            content: StatefulBuilder(builder: (context, setModalState) {
              return SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.29,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "${AppLocalizations.of(context)!.getTranslate(
                            'set_alarm')}",
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
                                "${AppLocalizations.of(context)!.getTranslate(
                                    'sound')}",
                                style: AppTheme.hintText.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomSwitchTimer(context, id),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "${AppLocalizations.of(context)!.getTranslate(
                                    'vibrate')}",
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
                                  "${AppLocalizations.of(context)!.getTranslate(
                                      'cancel')}",
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
                              print("dateTime convert: ${savedDateString(
                                  _alarmTimeString)}");

                            },
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  color: AppColors.AppColor2,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: Text(
                                    "${AppLocalizations.of(context)!
                                        .getTranslate('set')}",
                                    style: AppTheme.hintText.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  )),
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

  Future<String?> showDiaLogEdit(BuildContext context, int? id,) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            content: StatefulBuilder(builder: (context, setModalState) {
              return SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.29,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "${AppLocalizations.of(context)!.getTranslate(
                            'set_alarm')}",
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
                                "${AppLocalizations.of(context)!.getTranslate(
                                    'sound')}",
                                style: AppTheme.hintText.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomSwitchTimer(context, id),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "${AppLocalizations.of(context)!.getTranslate(
                                    'vibrate')}",
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
                                  "${AppLocalizations.of(context)!.getTranslate(
                                      'cancel')}",
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
                              // print(id);
                              _editToDoItem(id!, _isRepeatSelected);
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  color: AppColors.AppColor2,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Text(
                                  "${AppLocalizations.of(context)!.getTranslate(
                                      'edit')}",
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

  void scheduleAlarm(DateTime scheduledNotificationDateTime,
      AlarmInfo alarmInfo,
      {required bool isRepeating}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      channelDescription: 'Channel for Alarm notification',
      icon: '@mipmap/ic_launcher',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
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
        'Enter a record',
        'Time: ${savedDateString(_alarmTimeString)}',
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
        'Enter a record',
        'Time: ${savedDateString(_alarmTimeString)}',
        tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
  }

  String savedDateString(String date) {
    return date = DateFormat("hh:mm yyyy-MM-dd").format(_alarmTime!);
  }

  void _editToDoItem(int id, bool _isRepeatingEdit) {
    DateTime? scheduleAlarmDateTime;
    AlarmInfo alarmInfo = _currentAlarms?.firstWhere((element) =>
    element.id == id) as AlarmInfo;
    if (_alarmTime!.isAfter(DateTime.now())) {
      alarmInfo.alarmDateTime = _alarmTime;
      scheduleAlarmDateTime = _alarmTime;
    } else
      scheduleAlarmDateTime = _alarmTime!.add(Duration(days: 1));
    _alarmHelper.update(alarmInfo);
    if (scheduleAlarmDateTime != null) {
      scheduleAlarm(scheduleAlarmDateTime, alarmInfo,
          isRepeating: _isRepeatingEdit);
    }
    Navigator.pop(context);
    loadAlarms();
  }

  // static Future<void> saveListRecord(AlarmInfo? alarmInfo) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String jsonString = json.encode(alarmInfo!.toJson());
  //   prefs.setString('myObjectKey', jsonString);
  //   print("Save to shprf: ${alarmInfo.alarmDateTime} ");
  // }
  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
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
    print("date time: ${scheduleAlarmDateTime}");
    Navigator.pop(context);
    loadAlarms();
  }

  void deleteAlarm(int? id) {
    _alarmHelper.delete(id);
    //unsubscribe for notification
    loadAlarms();
  }
}
