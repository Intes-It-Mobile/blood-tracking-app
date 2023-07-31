import 'dart:convert';

import 'package:blood_sugar_tracking/views/personal_data/personal_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../models/information/information.dart';
import '../../models/information/information_provider.dart';
import '../../routes.dart';
import '../../utils/locale/appLocalizations.dart';

class OldScreen extends StatefulWidget {
  OldScreen({super.key,});

  @override
  State<OldScreen> createState() => _OldScreenState();
}

class _OldScreenState extends State<OldScreen> {
  int currentValue = 25;
  FixedExtentScrollController controllerWC = FixedExtentScrollController();

  @override
  void initState() {
   controllerWC = FixedExtentScrollController(initialItem: currentValue);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    InformationNotifier informationNotifier =
    Provider.of<InformationNotifier>(context);
    return Scaffold(
      backgroundColor: AppColors.AppColor1,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "${AppLocalizations.of(context)!.getTranslate('how_old_are_you')}",
                  style: AppTheme.unit24Text,
                ),
              ),
              Container(
                height: 300,
                child: WheelChooser.integer(
                 // controller: controllerWC,
                  onValueChanged: (value) {
                    setState(() {
                      int age = controllerWC.initialItem;
                      age = value;
                      informationNotifier.informations.old = age;
                      print("tuổi: ${age}");
                      print("dasdasddas: ${informationNotifier.informations.old?.toInt()}");
                    });
                  },
                  maxValue: 115,
                  minValue: 1,
                  initValue: currentValue,
                  step: 1,
                  selectTextStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w800,fontSize: 22),
                  unSelectTextStyle: TextStyle(color: Colors.grey),
                ),
              ),
              //thang
            ],
          ),
          Positioned(
            right: 20,
            top: MediaQuery.of(context).size.height * 0.067,
            child: InkWell(
              onTap: () {
                informationNotifier.informations = Information(
                  old: informationNotifier.informations.old?.toInt()
                );
               // Provider.of<InformationNotifier>(context, listen: false).update(informations);
                print("age: ${informationNotifier.informations.old}");
                informationNotifier.informationList.add(informationNotifier.informations);
                informationNotifier.saveUserData('information_key', informationNotifier.informations);
                Navigator.of(context).pushNamed(Routes.weight_screen);
                print('danh sach: ${informationNotifier.informationList.length}');
              },
              child: Text(
                "${AppLocalizations.of(context)!.getTranslate('next')}",
                style: AppTheme.Headline20Text.copyWith(
                    color: AppColors.AppColor4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
