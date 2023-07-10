import 'package:alarm/model/alarm_settings.dart';
import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/assets.dart';
import '../constants/colors.dart';

class ExampleAlarmTile extends StatefulWidget {
  final String title;
  final void Function()? onDelete;
  bool loopAudio;
  final void Function(bool loopAudio)? onLoopAudioChanged;
  final void Function() onPressed;
  // final void Function(bool) onSwitch;
  final void Function()? onDismissed;
  final AlarmSettings? alarmSettings;
  ExampleAlarmTile({
    Key? key,
    required this.title,
    required this.onPressed,
    this.onDismissed,
    this.onLoopAudioChanged,
    this.alarmSettings,
     required this.loopAudio,
    this.onDelete,
    // required this.onSwitch,
  }) : super(key: key);

  @override
  State<ExampleAlarmTile> createState() => _ExampleAlarmTileState();
}

class _ExampleAlarmTileState extends State<ExampleAlarmTile> {
  List<AlarmSettings>? alarms;
  late DateTime alarmTime;
  late bool creating;
  @override
  void initState() {
    // widget.loopAudio = widget.alarmSettings!.loopAudio;
    super.initState();
    //getSwitchValues();
  }

  // getSwitchValues() async {
  //   widget.loopAudio = await getSwitchState();
  //   setState(() {});
  // }
  //
  // Future<bool> saveSwitchState(bool value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool("switchState", value);
  //   print('Switch Value saved $value');
  //   return prefs.setBool("switchState", value);
  // }
  //
  // Future<bool> getSwitchState() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool? isSwitchedFT = prefs.getBool("switchState");
  //   print(isSwitchedFT);
  //
  //   return isSwitchedFT!;
  // }
  //
  // String savedDateString(DateTime date) {
  //   print("conver time: ${DateFormat("HH:mm dd/MM/yyyy").format(date)}");
  //   return DateFormat("HH:mm dd/MM/yyyy").format(date);
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
          height: 104,
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
                  padding: const EdgeInsets.only(top: 15, right: 20),
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
                              widget.onDelete?.call();
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
                        child: StatefulBuilder(
                          builder: (context, setModalState) {
                            return CupertinoSwitch(
                              onChanged: (bool value) {
                                setModalState(() {
                                  widget.loopAudio = value;
                                  widget.onLoopAudioChanged?.call(value);
                                  //saveSwitchState(value);
                                });
                              },
                              value: widget.loopAudio,
                              trackColor: AppColors.AppColor1,
                              activeColor: AppColors.AppColor2,
                            );
                          },
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
