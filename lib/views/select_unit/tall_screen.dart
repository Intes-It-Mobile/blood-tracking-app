import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../models/information/information.dart';
import '../../models/information/information_provider.dart';
import '../../routes.dart';
import '../../utils/locale/appLocalizations.dart';

class TallScreen extends StatefulWidget {
  const TallScreen({super.key});

  @override
  State<TallScreen> createState() => _TallScreenState();
}

class _TallScreenState extends State<TallScreen> {
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
                  "${AppLocalizations.of(context)!.getTranslate('How_tall_are_you')}",
                  style: AppTheme.unit24Text,
                ),
              ),
              Container(
                height: 300,
                child: WheelChooser.integer(
                  onValueChanged: (value) {
                    setState(() {
                      int tall = controllerWC.initialItem;
                      tall = value;
                      informationNotifier.informations.tall = tall;
                      print("tuổi: ${tall}");
                      print("dasdasddas: ${informationNotifier.informations.tall?.toInt()}");
                    });
                  },
                  maxValue: 400,
                  minValue: 1,
                  initValue: currentValue,
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
                informationNotifier.informations = Information(
                    tall: informationNotifier.informations.tall?.toInt()
                );
                // Provider.of<InformationNotifier>(context, listen: false).update(informations);
                print("age: ${informationNotifier.informations.tall}");
                informationNotifier.informationList.add(informationNotifier.informations);
                informationNotifier.saveUserData('information_key', informationNotifier.informations);
                Navigator.of(context).pushNamed(Routes.weight_screen);
                print('danh sach: ${informationNotifier.informationList.length}');
                 Navigator.of(context).pushNamed(Routes.select_unit);

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
