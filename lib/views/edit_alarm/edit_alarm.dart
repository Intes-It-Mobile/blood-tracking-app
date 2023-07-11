import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../utils/locale/appLocalizations.dart';

class ExampleAlarmEditScreen extends StatefulWidget {
  final AlarmSettings? alarmSettings;

  ExampleAlarmEditScreen({
    Key? key,
    required this.alarmSettings,
  }) : super(key: key);

  @override
  State<ExampleAlarmEditScreen> createState() => _ExampleAlarmEditScreenState();
}

class _ExampleAlarmEditScreenState extends State<ExampleAlarmEditScreen> {
  late bool creating;
  late TimeOfDay selectedTime;
  late DateTime alarmTime;
  late bool loopAudio;
  List<AlarmSettings>? alarms;
  late bool vibrate;
  late bool showNotification;
  late String assetAudio;

  @override
  void didUpdateWidget(covariant ExampleAlarmEditScreen oldWidget) {
   saveAlarm();
    super.didUpdateWidget(oldWidget);
  }
  @override
  void initState() {
    super.initState();
    creating = widget.alarmSettings == null;
    if (creating) {
      final dt = DateTime.now().add(const Duration(minutes: 1));
      alarmTime = DateTime(dt.hour, dt.minute);
      loopAudio = true;
      vibrate = true;
      showNotification = true;
      assetAudio = 'assets/marimba.mp3';
    } else {
      alarmTime = DateTime(
        widget.alarmSettings!.dateTime.hour,
        widget.alarmSettings!.dateTime.minute,
      );
      loopAudio = widget.alarmSettings!.loopAudio;
      vibrate = widget.alarmSettings!.vibrate;
      showNotification = widget.alarmSettings!.soundAudio;
      showNotification = widget.alarmSettings!.notificationTitle != null &&
          widget.alarmSettings!.notificationTitle!.isNotEmpty &&
          widget.alarmSettings!.notificationBody != null &&
          widget.alarmSettings!.notificationBody!.isNotEmpty;
      assetAudio = widget.alarmSettings!.assetAudioPath;
    }
  }

  String savedDateString(DateTime date) {
    print("conver time: ${DateFormat("HH:mm dd/MM/yyyy").format(date)}");
    return DateFormat("HH:mm dd/MM/yyyy").format(date);
  }

  // Future<void> pickTime() async {
  //   final res = await showTimePicker(
  //     initialTime: alarmTime,
  //     context: context,
  //   );
  //   if (res != null) setState(() => alarmTime = res);
  // }


  AlarmSettings buildAlarmSettings() {
    final now = DateTime.now();
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 100000
        : widget.alarmSettings!.id;

    DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      alarmTime.hour,
      alarmTime.minute,
      0,
      0,
    );
    if (dateTime.isBefore(DateTime.now())) {
      dateTime = dateTime.add(const Duration(days: 1));
    }

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      notificationTitle: loopAudio ? 'Enter a record' : null,
      notificationBody: loopAudio ? 'Time: ${savedDateString(dateTime)}' : null,
      assetAudioPath: showNotification ? assetAudio : '.',
      soundAudio: showNotification,
      fadeDuration: 3.0,
      stopOnNotificationOpen: true,
      enableNotificationOnKill: true,
    );
    return alarmSettings;
  }

  void saveAlarm() {
    Alarm.set(alarmSettings: buildAlarmSettings()).then((res) {
      if (res) {
        Navigator.pop(context, "set");
      }
    });
  }


  void deleteAlarm() {
    Alarm.stop(widget.alarmSettings!.id).then((res) {
      if (res) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
                child: TimePickerSpinner(
                  time: widget.alarmSettings?.dateTime,
                  itemHeight: 30,
                  highlightedTextStyle: AppTheme.hintText.copyWith(
                      fontWeight: FontWeight.w700, color: Colors.black),
                  normalTextStyle: AppTheme.hintText.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withOpacity(0.5)),
                  is24HourMode: true,
                  onTimeChange: (time) {
                    setState(() {
                      alarmTime = time;
                    });
                  },
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sound',
                            style: AppTheme.hintText.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                          StatefulBuilder(
                            builder: (context, setModalState) {
                              return CupertinoSwitch(
                                onChanged: (bool value) {
                                  setModalState(() {
                                    showNotification = value;
                                  });
                                },
                                value: showNotification,
                                trackColor: AppColors.AppColor1,
                                activeColor: AppColors.AppColor2,
                              );
                            },
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Vibrate',
                            style: AppTheme.hintText.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                          StatefulBuilder(
                            builder: (context, setModalState) {
                              return CupertinoSwitch(
                                onChanged: (bool value) {
                                  setModalState(() {
                                    vibrate = value;
                                  });
                                },
                                value: vibrate,
                                trackColor: AppColors.AppColor1,
                                activeColor: AppColors.AppColor2,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, "edit");
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    height: 35,
                    width: double.infinity,
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
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  height: 35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.AppColor2,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: creating == false
                        ? InkWell(
                            onTap: () {
                              saveAlarm();
                            },
                            child: Container(
                              width: double.infinity,
                              height: 35,
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  "${AppLocalizations.of(context)!.getTranslate('edit')}",
                                  style: AppTheme.hintText.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              saveAlarm();
                            },
                            child: Container(
                              width: double.infinity,
                              height: 35,
                              color: Colors.transparent,
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
