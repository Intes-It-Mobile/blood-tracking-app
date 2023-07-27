import 'package:blood_sugar_tracking/AppLanguage.dart';
import 'package:blood_sugar_tracking/widgets/share_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../utils/locale/appLocalizations.dart';

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
  int _selectedIndex = -1;
  int value = 0;
  String? langCode;
  AppLanguage appLanguage = AppLanguage();

  @override
  void initState() {
    if(shareLocal.getString('language_code') == "vi"){
      _selectedIndex = 4;
    }else if(shareLocal.getString('language_code') == "en"){
      _selectedIndex = 0;
    }else if(shareLocal.getString('language_code') == "zh"){
      _selectedIndex = 1;
    }else if(shareLocal.getString('language_code') == "es"){
      _selectedIndex = 2;
    }else {
      _selectedIndex = 3;
    }
    // if(prefs.getString('language_code'))
    // for (int i = 0; i < languages.length; i++) {
    //   if (langCode == languages[i]) {
    //     _selectedIndex = i;
    //     print('qweqwewq: ${i}');
    //     break;
    //   }
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SvgPicture.asset(
                Assets.iconBack,
                height: 44,
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
                appLanguage.appLocal.languageCode == langCode
                    ? FunctionLanguages(value, context, langCode!)
                    : null;
                print("tangdasdsa: ${appLanguage.appLocal.languageCode}");
                print("ssssss: ${langCode}");
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
      body: Padding(
        padding: const EdgeInsets.only(top: 28),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: languages.length,
          itemBuilder: (context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  value = index;
                  langCode = appLanguage.appLocal.languageCode ;
                  if (_selectedIndex == index) {
                    _selectedIndex = -1;
                  } else {
                    _selectedIndex = index;
                  }
                });
                print('aaaaaaa: ${langCode}');
                print('aaaaaaa: $appLanguage');
              },
              child: Container(
                height: 45,
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
                    style: AppTheme.TextInfomation14Text.copyWith(
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
