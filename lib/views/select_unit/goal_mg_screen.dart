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

class GoalmgScreen extends StatefulWidget {
  const GoalmgScreen({super.key});

  @override
  State<GoalmgScreen> createState() => _GoalmgScreenState();
}

class _GoalmgScreenState extends State<GoalmgScreen> {
  int currentValue = 80;
  FixedExtentScrollController controller = FixedExtentScrollController();
  SugarInfoStore? sugarInfoStore;
  @override
  void didChangeDependencies() {
    Provider.of<InformationNotifier>(context);
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    controller = FixedExtentScrollController(initialItem: currentValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InformationNotifier informationNotifier =
        Provider.of<InformationNotifier>(context);
    sugarInfoStore!.setGoalAmount(80);
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
                    SizedBox(
                      width: 80,
                      child: WheelChooser.integer(
                        onValueChanged: (value) {
                          sugarInfoStore!.goalAmount!.amount = value * 1.0;
                        },
                        maxValue: 630,
                        minValue: 18,
                        initValue: currentValue,
                        selectTextStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 22),
                        unSelectTextStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.getTranslate('mg/dL')}',
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
