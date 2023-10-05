import 'package:blood_sugar_tracking/AppLanguage.dart';
import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/utils/locale/appLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';
import '../../utils/ads_helper.dart';
import '../../utils/ads_ios/ads.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  List<String> languages = [
    'English',
    '中国人',
    'español',
    'français',
    'Tiếng Việt',
  ];
  int _selectedIndex = 0;

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
              Container(
                padding: EdgeInsets.only(
                  right: 10,
                  top: 40,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.select_unit);
                      },
                      child: Text(
                        "${AppLocalizations.of(context)!.getTranslate('next')}",
                        style: AppTheme.Headline20Text.copyWith(
                            color: Colors.transparent),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${AppLocalizations.of(context)!.getTranslate('choose_your_language')}",
                      style: AppTheme.unit24Text,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.40,
                      // width: double.infinity,
                      child: ListView.builder(
                          primary: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: languages.length,
                          itemBuilder: (context, int index) {
                            return GestureDetector(
                              onTap: () {
                                FunctionLanguages(index, context);
                                setState(() {
                                  if (_selectedIndex == index) {
                                    _selectedIndex = 0;
                                  } else {
                                    _selectedIndex = index;
                                  }
                                });
                              },
                              child: Container(
                                height: 40,
                                margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.16,
                                    right: MediaQuery.of(context).size.width *
                                        0.16,
                                    top: 14),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    color: index == _selectedIndex
                                        ? AppColors.AppColor2
                                        : Colors.white),
                                child: Center(
                                  child: Text(
                                    languages[index],
                                    style: AppTheme.Headline20Text.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: index == _selectedIndex
                                            ? Colors.white
                                            : AppColors.AppColor2),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
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
          Positioned(
            right: 20,
            top: MediaQuery.of(context).size.height * 0.067,
            child: InkWell(
              onTap: () {
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

  void FunctionLanguages(int index, context) {
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
