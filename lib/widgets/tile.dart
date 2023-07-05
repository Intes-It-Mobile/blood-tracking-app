import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../alarm.dart';
import '../constants/assets.dart';
import '../constants/colors.dart';
import '../views/edit_alarm/edit_alarm.dart';

class ExampleAlarmTile extends StatefulWidget {
  final String title;
  bool loopAudio;
  final void Function() onPressed;
  final void Function()? onDismissed;
  final AlarmSettings? alarmSettings;
   ExampleAlarmTile({
    Key? key,
    required this.title,
    required this.onPressed,
    this.onDismissed,
    this.alarmSettings, required this.loopAudio,
  }) : super(key: key);

  @override
  State<ExampleAlarmTile> createState() => _ExampleAlarmTileState();
}

class _ExampleAlarmTileState extends State<ExampleAlarmTile> {

  List<AlarmSettings>? alarms;

  @override
  void initState() {
    super.initState();
  }

  // AlarmSettings buildAlarmSettings() {
  //   final now = DateTime.now();
  //   final id = creating
  //       ? DateTime.now().millisecondsSinceEpoch % 100000
  //       : widget.alarmSettings!.id;
  //
  //   DateTime dateTime = DateTime(
  //     now.year,
  //     now.month,
  //     now.day,
  //     alarmTime.hour,
  //     alarmTime.minute,
  //     0,
  //     0,
  //   );
  //   if (dateTime.isBefore(DateTime.now())) {
  //     dateTime = dateTime.add(const Duration(days: 1));
  //   }
  //
  //   final alarmSettings = AlarmSettings(
  //     id: id,
  //     dateTime: dateTime,
  //     loopAudio: widget.loopAudio,
  //     vibrate: widget.loopAudio,
  //     notificationTitle: widget.loopAudio ? 'Enter a record' : null,
  //     notificationBody: widget.loopAudio ? 'Time: ${alarms?.last.dateTime}' : null,
  //     assetAudioPath: '',
  //     stopOnNotificationOpen: false,
  //   );
  //   return alarmSettings;
  // }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: widget.key!,
      direction: widget.onDismissed != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),
        child: const Icon(
          Icons.delete,
          size: 30,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => widget.onDismissed?.call(),
      child: RawMaterialButton(
        onPressed: widget.onPressed,
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    widget.title,
                    style: AppTheme.hintText.copyWith(
                        fontSize: 36,
                        color: AppColors.AppColor4,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15,right: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SvgPicture.asset(Assets.iconEditRecord),
                          const SizedBox(
                            width: 15,
                          ),
                          InkWell(
                            onTap: () {
                            },
                            child: SvgPicture.asset(Assets.iconDelete),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Switch(
                          value: widget.loopAudio,
                          onChanged: (value) {
                            setState(() {
                              widget.loopAudio = value;
                            });
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
