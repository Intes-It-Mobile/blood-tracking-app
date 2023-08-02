import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../controllers/stores/sugar_info_store.dart';
import '../../models/information/information.dart';
import '../../models/information/information_provider.dart';
import '../../routes.dart';
import '../../utils/locale/appLocalizations.dart';

class GoalmmolScreen extends StatefulWidget {
  const GoalmmolScreen({super.key});

  @override
  State<GoalmmolScreen> createState() => _GoalmmolScreenState();
}

class _GoalmmolScreenState extends State<GoalmmolScreen> {
  int currentFirstValue = 4;
  int currentSecondValue = 0;
  FixedExtentScrollController controller = FixedExtentScrollController();
  FixedExtentScrollController controller1 = FixedExtentScrollController();
  SugarInfoStore? sugarInfoStore;
  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);

    super.didChangeDependencies();
  }

  @override
  void initState() {
    controller = FixedExtentScrollController(initialItem: currentFirstValue);
    controller1 = FixedExtentScrollController(initialItem: currentSecondValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InformationNotifier informationNotifier =
        Provider.of<InformationNotifier>(context);
    sugarInfoStore!.goalFirstMolValue = currentFirstValue;
    sugarInfoStore!.goalSecondMolValue = currentSecondValue;
    
    sugarInfoStore!.setGoalMolAmount();
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
                  "${AppLocalizations.of(context)!.getTranslate('declare_your_goal')}",
                  style: AppTheme.unit24Text,
                ),
              ),
              Container(
                height: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: 80,
                      child: WheelChooser.integer(
                        onValueChanged: (value) {
                          sugarInfoStore!.goalFirstMolValue = value;
                          sugarInfoStore!.setGoalMolAmount();
                        },
                        maxValue: 35,
                        minValue: 1,
                        initValue: currentFirstValue,
                        selectTextStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 22),
                        unSelectTextStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Container(
                      child: Text(
                        ",",
                        style: AppTheme.BtnText.copyWith(
                            color: Colors.black, fontSize: 30),
                      ),
                    ),
                    Container(
                      height: 200,
                      width: 80,
                      child: WheelChooser.integer(
                        onValueChanged: (value) {
                          sugarInfoStore!.goalSecondMolValue = value;
                          sugarInfoStore!.setGoalMolAmount();
                        },
                        maxValue: 9,
                        minValue: 0,
                        initValue: currentSecondValue,
                        selectTextStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 22),
                        unSelectTextStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.getTranslate('mmol/L')}',
                      style: AppTheme.unit20Text,
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 20,
            top: MediaQuery.of(context).size.height * 0.067,
            child: InkWell(
              onTap: () {
                sugarInfoStore!.saveGoalAmountToSharedPreferences();
                Navigator.of(context).pushNamed(Routes.intro);
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
