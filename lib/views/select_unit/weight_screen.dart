import 'package:blood_sugar_tracking/models/information/information_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../controllers/stores/sugar_info_store.dart';
import '../../models/information/information.dart';
import '../../routes.dart';
import '../../utils/locale/appLocalizations.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
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
    InformationNotifier informationNotifier =
    Provider.of<InformationNotifier>(context);
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: false);
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
                  "${AppLocalizations.of(context)!.getTranslate('what_is_your_weight')}",
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
                          setState(() {
                            int weight = controllerWC.initialItem;
                            weight = value;

                            sugarInfoStore?.information?.weight = weight;
                            print("cân nặng: ${weight}");
                            print("dasdasddas: ${sugarInfoStore?.information?.weight?.toInt()}");
                          });
                        },
                        maxValue: 400,
                        minValue: 1,
                        initValue: currentValue,
                        selectTextStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w800,fontSize: 22),
                        unSelectTextStyle: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    Text('Kg',style: AppTheme.unit20Text,)
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
                sugarInfoStore?.information?.weight = sugarInfoStore?.information?.weight?.toInt();
                // Provider.of<InformationNotifier>(context, listen: false).update(informations);
                sugarInfoStore?.information = informationNotifier.information;
                print("age: ${informationNotifier.informations.weight}");
              //  informationNotifier.addItem(informationNotifier.informations);
                informationNotifier.saveUserData('information_key', sugarInfoStore!.information!);
                Navigator.of(context).pushNamed(Routes.tall_screen);
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
