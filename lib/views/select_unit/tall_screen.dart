import 'package:flutter/material.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../routes.dart';
import '../../utils/locale/appLocalizations.dart';

class TallScreen extends StatefulWidget {
  const TallScreen({super.key});

  @override
  State<TallScreen> createState() => _TallScreenState();
}

class _TallScreenState extends State<TallScreen> {
  @override
  Widget build(BuildContext context) {
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
                  "${AppLocalizations.of(context)!.getTranslate('How_tall_are_you')}",
                  style: AppTheme.unit24Text,
                ),
              ),
              Container(
                height: 300,
                child: WheelChooser.integer(
                  onValueChanged: (old) {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => PersonalDataScreen(
                    //       old: s,
                    //     ),
                    //   ),
                    // );

                  },
                  maxValue: 400,
                  minValue: 1,
                  initValue: 25,
                  selectTextStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w800,fontSize: 22),
                  unSelectTextStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          Positioned(
            right: 20,
            top: MediaQuery.of(context).size.height * 0.067,
            child: InkWell(
              onTap: () {
                 Navigator.of(context).pushNamed(Routes.select_unit);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalDataScreen(
                //   name: information[_selectedIndex].gender,
                // )));
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
