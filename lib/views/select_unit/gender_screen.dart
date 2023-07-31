import 'dart:convert';

import 'package:blood_sugar_tracking/models/information/information_provider.dart';
import 'package:blood_sugar_tracking/views/personal_data/personal_data_screen.dart';
import 'package:blood_sugar_tracking/views/select_unit/old_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../controllers/information/information_item.dart';
import '../../models/information/information.dart';
import '../../routes.dart';
import '../../utils/locale/appLocalizations.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  int _selectedIndex = -1;
  int? value;

  @override
  void initState() {
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
                  "${AppLocalizations.of(context)!.getTranslate('choose_your_gender')}",
                  style: AppTheme.unit24Text,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.23,
                child: ListView.builder(
                  itemCount: ListInformation().information.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          value = index;
                          if (_selectedIndex == index) {
                            _selectedIndex = 0;
                          } else {
                            _selectedIndex = index;
                          }
                        });
                      },
                      child: Container(
                        height: 44,
                        margin: EdgeInsets.only(
                          top: 12,
                          left: MediaQuery.of(context).size.width * 0.23,
                          right: MediaQuery.of(context).size.width * 0.23,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: index == _selectedIndex
                                ? AppColors.AppColor2
                                : Colors.white),
                        child: Center(
                          child: Text(
                            ListInformation()
                                .information[index]
                                .gender
                                .toString(),
                            style: AppTheme.Headline20Text.copyWith(fontWeight: FontWeight.w600,color: index == _selectedIndex ? Colors.white : AppColors.AppColor2 ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            right: 20,
            top: MediaQuery.of(context).size.height * 0.067,
            child: InkWell(
              onTap: () {
                informationNotifier.informations = Information(gender: ListInformation().information[value!.toInt()].gender);
                informationNotifier.informationList.add(informationNotifier.informations);
                informationNotifier.saveUserData('information_key', informationNotifier.informations);
                print("gender: ${informationNotifier.informations}");
             //   Provider.of<InformationNotifier>(context, listen: false).setInformationData(information);
                Navigator.push(context, MaterialPageRoute(builder: (context) => OldScreen()));

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
