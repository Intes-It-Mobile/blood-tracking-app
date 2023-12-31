// ignore_for_file: prefer_const_constructors

import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/constants/font_family.dart';
import 'package:blood_sugar_tracking/utils/locale/appLocalizations.dart';
import 'package:blood_sugar_tracking/views/heart_rate/heart_rate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/assets.dart';
import '../../widgets/customs_bottom_appbar.dart';
import '../../widgets/update_version_dialog.dart';
import '../../widgets/widget_appbar.dart';
import '../infomation/infomation_screen.dart';
import '../setting/setting_screen.dart';
import 'home_screen_content.dart';
// import '../../utils/locale/app_localization.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool hasAds = false;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.transparent,
      child: Container(
        child: Stack(
          children: [
            Scaffold(
              // extendBodyBehindAppBar: true,
              resizeToAvoidBottomInset: true,
              appBar: CustomAppBar(),
              backgroundColor: Colors.white,
              body: WillPopScope(
                onWillPop: _onWillPop,
                child: Container(
                  // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: _buildPageContent(),
                ),
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration( 
                color: Colors.transparent,
                  boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2), // Màu của bóng và độ trong suốt
          // spreadRadius: 5, // Độ lan rộng của bóng
          blurRadius: 10, // Độ mờ của bóng
          offset: Offset(0, 1), // Độ dịch chuyển của bóng
        ),
      ],),
                margin: EdgeInsets.only(bottom: hasAds ? 75.0 : 30),
                child: BottomAppBarCum(
                  color: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildNavItem(
                              Assets.iconBloodSugar,
                              'A',
                              0,
                              AppLocalizations.of(context)!
                                  .getTranslate('blood_sugar_txt'),
                            ),
                            // _buildNavItem(
                            //     Assets.iconHeartRate,
                            //     'B',
                            //     1,
                            //     AppLocalizations.of(context)!
                            //         .getTranslate('heart_rate_txt')),
                            _buildNavItem(
                                Assets.iconInfoNav,
                                'C',
                                1,
                                AppLocalizations.of(context)!
                                    .getTranslate('infor')),
                            _buildNavItem(
                                Assets.iconSettingsNav,
                                'C',
                                2,
                                AppLocalizations.of(context)!
                                    .getTranslate('setting_nav')),
                          ],
                        ),
                        // Container(width: double.infinity,height: 50,color: Colors.blue,)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                child: hasAds
                    ? Container(
                        width: screenWidth,
                        height: 87,
                        color: AppColors.AppColor2,
                        child: Image.asset(Assets.adsBanner))
                    : Container(
                        width: screenWidth,
                        height: 39,
                        color: AppColors.AppColor2,
                      ))
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String icon, String label, int index, String text) {
    final bool isSelected = _currentIndex == index;
    final double scale = isSelected ? 1.15 : 1.0;

    EdgeInsets margin;

    // Align button A to the left edge of the screen
    // margin = const EdgeInsets.only(left: 2.0, right: 1.0);

    // if (index == 1) {
    //   margin = EdgeInsets.fromLTRB(2, 10, 2, 0);
    // } else {
    //   margin = EdgeInsets.fromLTRB(0, 10, 0, 0);
    // }
    BorderRadius borderRadius;

    Color textColor = isSelected ? AppColors.AppColor4 : Colors.white;
    Color iconColor = isSelected ? AppColors.AppColor4 : Colors.white;
    Color btnColor = isSelected ? Colors.white : AppColors.AppColor2;

    // borderRadius = const BorderRadius.only(
    //   topLeft: Radius.circular(8.0),
    //   topRight: Radius.circular(8.0),
    // );

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabTapped(index),
        child: Container(
          // margin: margin,
          // padding: margin,
          child: Container(
            decoration: BoxDecoration(
              
              color: btnColor,
              // borderRadius: borderRadius,
            ),
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),  
            child: Center(
              child: Column(
                children: [
                  SvgPicture.asset(
                    icon,
                    color: iconColor,
                  ),
                  Text("${text}",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style:
                          AppTheme.appBodyTextStyle.copyWith(color: textColor)
                      // TextStyle(
                      //     color: textColor, fontWeight: FontWeight.w600),
                      )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent() {
    switch (_currentIndex) {
      case 0:
        return HomeScreenContent();
      // case 1:
      //   return HeartRateScreen();
      case 1:
        return InfomationScreen();
      case 2:
        return SettingScreen();
      default:
        return Container();
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  insetPadding: EdgeInsets.symmetric(horizontal: 16),
                  elevation: 0,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  content: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 42),
                          child: Text(
                            "${AppLocalizations.of(context)!.getTranslate('wanna_exit')}",
                            style: AppTheme.Headline16Text.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(true),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 9),
                                  decoration: BoxDecoration(
                                      color: AppColors.AppColor3,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Center(
                                    child: Text(
                                      "${AppLocalizations.of(context)!.getTranslate('exit')}",
                                      style:
                                          AppTheme.TextIntroline16Text.copyWith(
                                              color: AppColors.AppColor2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 23),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(false),
                                child: Container(
                                  // margin: EdgeInsets.only(left: 23),
                                  padding: EdgeInsets.symmetric(vertical: 9),
                                  decoration: BoxDecoration(
                                      color: AppColors.AppColor2,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Center(
                                    child: Text(
                                      "${AppLocalizations.of(context)!.getTranslate('stay')}",
                                      style: AppTheme.TextIntroline16Text,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ))) ??
        _onWillPop;
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(0); // Đặt chiều cao là 0

  @override
  Widget build(BuildContext context) {
    return WidgetAppBar();
    //   AppBar(
    //   systemOverlayStyle: const SystemUiOverlayStyle(
    //     // Status bar color
    //     statusBarColor: AppColors.AppColor2,
    //     // Status bar brightness (optional)`
    //     statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
    //     statusBarBrightness: Brightness.dark, // For iOS (dark icons)
    //   ),
    //
    //   // Các thuộc tính khác của AppBar
    // );
  }
}
