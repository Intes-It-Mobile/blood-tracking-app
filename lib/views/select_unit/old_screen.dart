import 'dart:convert';

import 'package:blood_sugar_tracking/views/personal_data/personal_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../controllers/stores/sugar_info_store.dart';
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
  SugarInfoStore? sugarInfoStore;
  @override
  void initState() {
   controllerWC = FixedExtentScrollController(initialItem: currentValue);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: false);
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
               //  controller: controllerWC,
                  onValueChanged: (value) {
                    setState(() {
                      int age = controllerWC.initialItem;
                      age = value;
                      sugarInfoStore?.information?.old = age;
                      print("tuổi: ${age}");
                      print("dasdasddas: ${sugarInfoStore?.information?.old?.toInt()}");
                    });
                  },
                  maxValue: 115,
                  minValue: 1,
                  initValue: currentValue,
                  step: 1,
                  isInfinite: true,
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
                sugarInfoStore?.information?.old = sugarInfoStore?.information?.old?.toInt();
                //informationNotifier.addItem(informationNotifier.informations);
                sugarInfoStore?.information = informationNotifier.information;
                informationNotifier.saveUserData('information_key', sugarInfoStore!.information!,);
                Navigator.of(context).pushNamed(Routes.weight_screen);
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
