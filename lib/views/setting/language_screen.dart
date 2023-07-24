import 'package:blood_sugar_tracking/AppLanguage.dart';
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

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
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
              onTap: (){
                appLanguage.changeLanguage(Locale("vi"));
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white
                ),
                child: Center(
                  child: SvgPicture.asset(Assets.icSelect),
                )
              ),
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
              onTap: (){
                setState(() {
                  if (_selectedIndex == index) {
                    _selectedIndex = -1;
                  } else {
                    _selectedIndex = index;
                  }
                });
              },
              child: Container(
                height: 45,
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.26,
                    right: MediaQuery.of(context).size.width * 0.26,
                top: 8),
                decoration: BoxDecoration(
                    color: index == _selectedIndex ? AppColors.AppColor2 : Colors.white, borderRadius: BorderRadius.circular(22)),
                child: Center(
                  child: Text(
                    languages[index], style: AppTheme.TextInfomation14Text.copyWith(
                      color: index == _selectedIndex ? Colors.white : AppColors.AppColor2,),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
