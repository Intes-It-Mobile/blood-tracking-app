import 'package:blood_sugar_tracking/models/goal/goal_amount.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../controllers/stores/sugar_info_store.dart';
import '../../models/information/information_provider.dart';
import '../../utils/locale/appLocalizations.dart';

class EditGoalMg extends StatefulWidget {
  const EditGoalMg({Key? key}) : super(key: key);

  @override
  State<EditGoalMg> createState() => _EditGoalMgState();
}

class _EditGoalMgState extends State<EditGoalMg> {
  SugarInfoStore? sugarInfoStore;
  int? currentValue;
  FixedExtentScrollController controllerWC = FixedExtentScrollController();

  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    sugarInfoStore!.fetchGoalAmountFromSharedPreferences();
    controllerWC = FixedExtentScrollController(
        initialItem: sugarInfoStore!.goalAmount!.amount!.toInt());
    currentValue = sugarInfoStore!.goalAmount!.amount!.toInt();
    super.didChangeDependencies();
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InformationNotifier informationNotifier =
        Provider.of<InformationNotifier>(context);
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          '${AppLocalizations.of(context)!.getTranslate('declare_your_goal')}',
          style: AppTheme.edit20Text,
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          height: 180,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Observer(builder: (_) {
                return SizedBox(
                  width: 80,
                  child: WheelChooser.integer(
                    onValueChanged: (value) {
                      sugarInfoStore!.setGoalAmount(value * 1.0);
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
                );
              }),
              const SizedBox(
                width: 8,
              ),
              Text(
                'mg/dL',
                style: AppTheme.unit20Text,
              )
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.only(left: 15, right: 12),
                    decoration: BoxDecoration(
                        color: const Color(0xFFCFF3FF),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        '${AppLocalizations.of(context)!.getTranslate('cancel')}',
                        style: AppTheme.Headline16Text.copyWith(
                            color: AppColors.AppColor2),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      sugarInfoStore!
                          .setGoalAmount(sugarInfoStore!.goalAmount!.amount);
                      sugarInfoStore!.saveGoalAmountToSharedPreferences();
                      Navigator.pop(context);
                      //informationNotifier.saveUserData('information_key', updatedItem);
                    });
                  },
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.only(left: 12, right: 15),
                    decoration: BoxDecoration(
                        color: AppColors.AppColor2,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                          '${AppLocalizations.of(context)!.getTranslate('done')}',
                          style: AppTheme.Headline16Text),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
