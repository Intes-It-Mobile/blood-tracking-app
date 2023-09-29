import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/models/information/information.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../../../controllers/information/information_item.dart';
import '../../../controllers/stores/sugar_info_store.dart';
import '../../../models/information/information_provider.dart';
import '../../../utils/locale/appLocalizations.dart';

class EditPersonalData extends StatefulWidget {
  const EditPersonalData({super.key});

  @override
  State<EditPersonalData> createState() => _EditPersonalDataState();
}

class _EditPersonalDataState extends State<EditPersonalData> {
  int selectedIndex = 0;
  int value = 0;
  SugarInfoStore? sugarInfoStore;

  @override
  void initState() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: false);
      if(sugarInfoStore?.information?.gender == "Male"){
        selectedIndex = 0;
      }else if(sugarInfoStore?.information?.gender == "Female"){
        selectedIndex = 1;
      }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InformationNotifier informationNotifier =
        Provider.of<InformationNotifier>(context);
    final Information information = informationNotifier.informations;
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          '${AppLocalizations.of(context)!.getTranslate('choose_your_gender')}',
          style: AppTheme.edit20Text,
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 115,
          child: ListView.builder(
            itemCount: ListInformation().information.length,
            itemBuilder: (context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    value = index;
                    if (selectedIndex == index) {
                      selectedIndex = 0;
                    } else {
                      selectedIndex = index;
                    }
                  });
                },
                child: Container(
                  height: 44,
                  margin: EdgeInsets.only(
                      top: 8,
                      left: MediaQuery.of(context).size.width * 0.14,
                      right: MediaQuery.of(context).size.width * 0.14),
                  decoration: BoxDecoration(
                      color: index == selectedIndex
                          ? AppColors.AppColor2
                          : Colors.white,
                      borderRadius: BorderRadius.circular(22)),
                  child: Center(
                    child: Text(
                      "${ListInformation().information[index].gender}",
                      style: AppTheme.Headline20Text.copyWith(
                        fontWeight: FontWeight.w600,
                        color: index == selectedIndex
                            ? Colors.white
                            : AppColors.AppColor2,
                      ),
                    ),
                  ),
                ),
              );
            },
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
                      informationNotifier.informations.gender =
                          ListInformation().information[value].gender;
                    });
                    informationNotifier.saveUserData(
                        'information_key', informationNotifier.informations);
                    Navigator.pop(context);
                    //informationNotifier.saveUserData('information_key', updatedItem);
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

class EditPersonalAge extends StatefulWidget {
  const EditPersonalAge({Key? key}) : super(key: key);

  @override
  State<EditPersonalAge> createState() => _EditPersonalAgeState();
}

class _EditPersonalAgeState extends State<EditPersonalAge> {
  SugarInfoStore? sugarInfoStore;
  int currentValue = 25;
  bool? isFirst = true;
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
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);

    if (isFirst == true) {
      currentValue = informationNotifier.informations.old!;
      setState(() {
        isFirst = false;
      });
    }
    return Consumer<InformationNotifier>(builder: (context, provider, _){
      return Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Text(
            '${AppLocalizations.of(context)!.getTranslate('how_old_are_you')}',
            style: AppTheme.edit20Text,
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 180,
            child: WheelChooser.integer(
              // controller: controllerWC,
              onValueChanged: (value) {
                currentValue = value;
                setState(() {
                  // int age = controllerWC.initialItem;
                  // age = value;
                  informationNotifier.informations.old = value;
                  // print("tuổi: ${age}");
                  print(
                      "dasdasddas: ${sugarInfoStore?.information?.old?.toInt()}");
                });
              },
              maxValue: 115,
              minValue: 1,
              initValue: currentValue,
              step: 1,
              selectTextStyle: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w800, fontSize: 22),
              unSelectTextStyle: TextStyle(color: Colors.grey),
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
                        informationNotifier.informations.old =
                            informationNotifier.informations.old;
                      });
                      informationNotifier.saveUserData(
                          'information_key', informationNotifier.informations);

                      Navigator.pop(context);
                      //informationNotifier.saveUserData('information_key', updatedItem);
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
    });
  }
}

class EditPersonalWeight extends StatefulWidget {
  const EditPersonalWeight({Key? key}) : super(key: key);

  @override
  State<EditPersonalWeight> createState() => _EditPersonalWeightState();
}

class _EditPersonalWeightState extends State<EditPersonalWeight> {
  SugarInfoStore? sugarInfoStore;
  int currentValue = 50;
  bool? isFirst = true;
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
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    if (isFirst == true) {
      currentValue = informationNotifier.informations.weight!;
      setState(() {
        isFirst = false;
      });
    }
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          '${AppLocalizations.of(context)!.getTranslate('what_is_your_weight')}',
          style: AppTheme.edit20Text,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          height: 180,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                child: WheelChooser.integer(
                  // controller: controllerWC,
                  onValueChanged: (value) {
                    currentValue = value;
                    setState(() {
                     // int age = controllerWC.initialItem;
                      informationNotifier.informations.weight = value;
                    });
                  },
                  maxValue: 115,
                  minValue: 1,
                  initValue: currentValue,
                  step: 1,
                  selectTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 22),
                  unSelectTextStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Kg',
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
                      informationNotifier.informations.weight =
                          informationNotifier.informations.weight;
                    });
                    informationNotifier.saveUserData(
                        'information_key', informationNotifier.informations);
                    Navigator.pop(context);
                    //informationNotifier.saveUserData('information_key', updatedItem);
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

class EditPersonalHeight extends StatefulWidget {
  const EditPersonalHeight({Key? key}) : super(key: key);

  @override
  State<EditPersonalHeight> createState() => _EditPersonalHeightState();
}

class _EditPersonalHeightState extends State<EditPersonalHeight> {
  SugarInfoStore? sugarInfoStore;
  int currentValue = 170;
  FixedExtentScrollController controllerWC = FixedExtentScrollController();
  bool? isFirst = true;
  @override
  void initState() {
   // controllerWC = FixedExtentScrollController(initialItem: currentValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InformationNotifier informationNotifier =
        Provider.of<InformationNotifier>(context);
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    if (isFirst == true) {
      currentValue = informationNotifier.informations.tall!;
      setState(() {
        isFirst = false;
      });
    }
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          '${AppLocalizations.of(context)!.getTranslate('How_tall_are_you')}',
          style: AppTheme.edit20Text,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 180,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                child: WheelChooser.integer(
                  // controller: controllerWC,
                  onValueChanged: (value) {
                    currentValue = value;
                    setState(() {
                    //  int age = controllerWC.initialItem;
                    //  age = value;
                      informationNotifier.informations.tall = value;
                   //   print("tuổi: ${age}");
                      print(
                          "dasdasddas: ${sugarInfoStore?.information?.tall?.toInt()}");

                    });

                  },
                  maxValue: 400,
                  minValue: 1,
                  initValue: currentValue,
                  step: 1,
                  selectTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 22),
                  unSelectTextStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Cm',
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
                      informationNotifier.informations.tall =
                          informationNotifier.informations.tall;
                    });
                    informationNotifier.saveUserData(
                        'information_key', informationNotifier.informations);
                    Navigator.pop(context);
                    //informationNotifier.saveUserData('information_key', updatedItem);
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
