import 'package:blood_sugar_tracking/controllers/information/information_item.dart';
import 'package:blood_sugar_tracking/models/goal/goal_amount.dart';
import 'package:blood_sugar_tracking/models/information/information.dart';
import 'package:blood_sugar_tracking/models/information/information_provider.dart';
import 'package:blood_sugar_tracking/views/personal_data/components/components_personal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../controllers/stores/sugar_info_store.dart';
import '../../utils/ads/applovin_function.dart';
import '../../utils/ads_helper.dart';
import '../../utils/ads_ios/ads.dart';
import '../../utils/locale/appLocalizations.dart';

class PersonalDataScreen extends StatefulWidget {
  // Information? information;
  PersonalDataScreen({
    super.key,
    //   this.information,
  });

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  SugarInfoStore? sugarInfoStore;
  GoalAmount? goalAmount;
  ShowInterstitialAdsController showInterstitialAdsController = ShowInterstitialAdsController();

  @override
  void didChangeDependencies() {
     sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
     sugarInfoStore!.fetchGoalAmountFromSharedPreferences();
    goalAmount = sugarInfoStore!.goalAmount;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    showInterstitialAdsController.loadAd();
    AppLovinFunction().initializeInterstitialAds();
    // sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: false);
    //   Provider.of<InformationNotifier>(context, listen: true).setInformationData(sugarInfoStore!.information!);
    Future.delayed(const Duration(microseconds: 100), () {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          backgroundColor: AppColors.AppColor2,
          title: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      // AppLovinFunction().showInterstitialAds();
                      showInterstitialAdsController.showAlert();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: SvgPicture.asset(
                        Assets.iconBack,
                        height: 40,
                        width: 40,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${AppLocalizations.of(context)!.getTranslate('personal_data')}",
                      style: AppTheme.Headline20Text, // Hiển thị dấu chấm ba khi có tràn
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: CheckDataInformation(context));
  }

  Widget CheckDataInformation(BuildContext context) {
    return Consumer<InformationNotifier>(builder: (context, provider, _) {
      sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: false);
       sugarInfoStore?.information = provider.informations;

      sugarInfoStore?.information = provider.getUserData(
        'information_key',
      );
      print("data: ${sugarInfoStore?.information}");
      return Observer(builder: (_) {
        return Visibility(
          visible:  provider.informations != null,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Components().DialogGender(context);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.14,
                            margin: const EdgeInsets.only(left: 15, right: 8),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(color: AppColors.AppColor3, borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.getTranslate('gender')}",
                                      style: AppTheme.Headline16Text.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Spacer(),
                                    SvgPicture.asset(Assets.iconEditRange),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                provider.informations != null
                                    ? Text(
                                        '${provider.informations.gender}',
                                        style: AppTheme.Headline20Text.copyWith(
                                            color: AppColors.AppColor4, fontWeight: FontWeight.w500),
                                      )
                                    : const Text('error')
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Components().DialogAge(context);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.14,
                            margin: const EdgeInsets.only(right: 15, left: 8),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(color: AppColors.AppColor3, borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.getTranslate('age')}",
                                      style: AppTheme.Headline16Text.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Spacer(),
                                    SvgPicture.asset(Assets.iconEditRange),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                provider.informations != null
                                    ? Text(
                                        '${provider.informations.old}',
                                        style: AppTheme.Headline20Text.copyWith(
                                            color: AppColors.AppColor4, fontWeight: FontWeight.w500),
                                      )
                                    : const Text('error')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Components().DialogWeight(context);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.14,
                            margin: const EdgeInsets.only(left: 15, right: 8),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(color: AppColors.AppColor3, borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!.getTranslate('weight')}',
                                      style: AppTheme.Headline16Text.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Spacer(),
                                    SvgPicture.asset(Assets.iconEditRange),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                provider.informations != null
                                    ? Row(
                                        children: [
                                          Text(
                                            '${provider.informations.weight}',
                                            style: AppTheme.Headline20Text.copyWith(
                                                color: AppColors.AppColor4, fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '(kg)',
                                            style: AppTheme.Headline16Text.copyWith(
                                                color: Colors.black, fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      )
                                    : const Text("error")
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Components().DialogHeight(context);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.14,
                            margin: const EdgeInsets.only(right: 15, left: 8),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(color: AppColors.AppColor3, borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.getTranslate('height')}",
                                      style: AppTheme.Headline16Text.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Spacer(),
                                    SvgPicture.asset(Assets.iconEditRange),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                provider.informations != null
                                    ? Row(
                                        children: [
                                          Text(
                                            '${provider.informations.tall}',
                                            style: AppTheme.Headline20Text.copyWith(
                                                color: AppColors.AppColor4, fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '(cm)',
                                            style: AppTheme.Headline16Text.copyWith(
                                                color: Colors.black, fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      )
                                    : const Text('error')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (sugarInfoStore!.isSwapedToMol == true) {
                              Components().showDialogGoalMol(context);
                            } else {
                              Components().showDialogGoalMg(context);
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.14,
                            margin: const EdgeInsets.only(left: 15, right: 8),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(color: AppColors.AppColor3, borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!.getTranslate('goal')}',
                                      style: AppTheme.Headline16Text.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Spacer(),
                                    SvgPicture.asset(Assets.iconEditPen),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Observer(builder: (_) {
                                  return Row(
                                    children: [
                                      Observer(builder: (_) {
                                        return Text(
                                          '${cutString(sugarInfoStore!.goalAmount!.amount!)}',
                                          style: AppTheme.Headline20Text.copyWith(
                                              color: AppColors.AppColor4, fontWeight: FontWeight.w500),
                                        );
                                      }),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "${sugarInfoStore!.isSwapedToMol == true ? "(mmol/L)" : "(mg/dL)"}",
                                        style: AppTheme.Headline16Text.copyWith(
                                            color: Colors.black, fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  );
                                })
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.14,
                          margin: const EdgeInsets.only(right: 15, left: 8),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Text(
                                  //   "${AppLocalizations.of(context)!.getTranslate('height')}",
                                  //   style: AppTheme.appBodyTextStyle.copyWith(
                                  //     fontWeight: FontWeight.w500,
                                  //     color: Colors.white,
                                  //   ),
                                  // ),
                                  const Spacer(),
                                  SvgPicture.asset(
                                    Assets.iconEdit,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                      children: [
                                        Text(
                                          '',
                                          style: AppTheme.Headline20Text.copyWith(
                                              color: Colors.white, fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '(cm)',
                                          style: AppTheme.Headline20Text.copyWith(
                                              color: Colors.white, fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    )
                                 
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Center(
                    child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: AdsNative(
                          templateType: TemplateType.medium,
                          unitId: AdHelper.nativeInAppAdUnitId,
                        )),
                  ),
                ),
              ],
            ),
          ),
        );
      });
    });
  }

  String cutString(double number) {
    if (number.toString().length > 5) {
      String numberString = number.toString();
      String before = numberString.split('.').first;
      String after = numberString.split('.').last.substring(0, 1);
      return "${before}.${after}";
    } else {
      return "${number.toString()}";
    }
  }
}
