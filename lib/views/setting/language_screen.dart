import 'package:blood_sugar_tracking/AppLanguage.dart';
import 'package:blood_sugar_tracking/widgets/share_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/config_ads_id.dart';
import '../../main.dart';
import '../../utils/ads/applovin_function.dart';
import '../../utils/ads/mrec_ads.dart';
import '../../utils/ads_handle.dart';
import '../../utils/ads_helper.dart';
import '../../utils/ads_ios/ads.dart';
import '../../utils/locale/appLocalizations.dart';
import '../../widgets/loading_ad_dialog.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  List<String> languages = [
    'English',
    '中国人',
    'español',
    'français',
    'Tiếng Việt',
  ];
  int _selectedIndex = 0;
  int value = 0;
  String? langCode;
  AppLanguage appLanguage = AppLanguage();
  ShowInterstitialAdsController showInterstitialAdsController =
      ShowInterstitialAdsController();

  @override
  void initState() {
    if (shareLocal.getString('language_code') == "vi") {
      _selectedIndex = 4;
    } else if (shareLocal.getString('language_code') == "en") {
      _selectedIndex = 0;
    } else if (shareLocal.getString('language_code') == "zh") {
      _selectedIndex = 1;
    } else if (shareLocal.getString('language_code') == "es") {
      _selectedIndex = 2;
    } else if (shareLocal.getString('language_code') == "fr") {
      _selectedIndex = 3;
    } else {
      _selectedIndex = 0;
    }
    AppLovinFunction().initializeInterstitialAds();
    showInterstitialAdsController.loadAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    var appLanguage = Provider.of<AppLanguage>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        backgroundColor: AppColors.AppColor2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                if (context != null) {
                  Navigator.of(context).pop();
                  Loading.show(GlobalContext.navigatorKey.currentContext!);
                  Future.delayed(Duration(seconds: 1), () {
                    // Navigator.of(context).pop();
                    Loading.hide(GlobalContext.navigatorKey.currentContext!);
                    showInterstitialAdsController.showAlert();
                  });
                }
              },
              child: SvgPicture.asset(
                Assets.iconBack,
                height: 40,
                width: 40,
                fit: BoxFit.scaleDown,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 17),
              child: Text(
                "${AppLocalizations.of(context)!.getTranslate('languages')}",
                style: AppTheme.Headline20Text,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                FunctionLanguages(value, context, langCode!);
                // setState(() {
                //   langCode = myLocale.toString();
                //   print('dashdufs: ${myLocale.toString()}');
                // });
              },
              child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: Center(
                    child: SvgPicture.asset(Assets.icSelect),
                  )),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(top: 36),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: languages.length,
                itemBuilder: (context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        value = index;
                        langCode = appLanguage.appLocal.languageCode;
                        if (_selectedIndex == index) {
                          _selectedIndex = 0;
                        } else {
                          _selectedIndex = index;
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      // height: 44,
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.26,
                          right: MediaQuery.of(context).size.width * 0.26,
                          top: 8),
                      decoration: BoxDecoration(
                        color: index == _selectedIndex
                            ? AppColors.AppColor2
                            : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Text(
                          languages[index],
                          style: AppTheme.Headline20Text.copyWith(
                            color: index == _selectedIndex
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
          ),
          Center(
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: AdsNative(
                  templateType: TemplateType.medium,
                  unitId: AdHelper.nativeInAppAdUnitId,
                )),
          ),
        ],
      ),
    );
  }

  void FunctionLanguages(int index, context, String langCode) {
    var appLanguage = Provider.of<AppLanguage>(context, listen: false);
    switch (index) {
      case 0:
        appLanguage.changeLanguage(const Locale("en"));
        break;
      case 1:
        appLanguage.changeLanguage(const Locale("zh"));
        break;
      case 2:
        appLanguage.changeLanguage(const Locale("es"));
        break;
      case 3:
        appLanguage.changeLanguage(const Locale("fr"));
        break;
      case 4:
        appLanguage.changeLanguage(const Locale("vi"));
        break;
    }
  }
}
