// ignore_for_file: prefer_const_constructors

import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/constants/font_family.dart';
import 'package:blood_sugar_tracking/utils/locale/appLocalizations.dart';
import 'package:blood_sugar_tracking/views/heart_rate/heart_rate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../constants/assets.dart';
import '../../constants/config_ads_id.dart';
import '../../utils/ads/banner_ads.dart';
import '../../utils/ads/mrec_ads.dart';
import '../../utils/ads_handle.dart';
import '../../utils/ads_helper.dart';
import '../../utils/ads_ios/ads.dart';
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
  late AppLifecycleReactor _appLifecycleReactor;
  int _currentIndex = 0;
  bool hasAds = true;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    _appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
    super.initState();
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
                color: Colors.transparent,
                margin: EdgeInsets.only(bottom: hasAds ? 44.0 : 30),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildNavItem(
                              Assets.iconBloodSugar,
                              'A',
                              0,
                              AppLocalizations.of(context)!
                                  .getTranslate('blood_sugar_txt'),
                            ),
                            _buildNavItem(
                                Assets.iconHeartRate,
                                'B',
                                1,
                                AppLocalizations.of(context)!
                                    .getTranslate('heart_rate_txt')),
                            _buildNavItem(
                                Assets.iconInfoNav,
                                'C',
                                2,
                                AppLocalizations.of(context)!
                                    .getTranslate('infor')),
                            _buildNavItem(
                                Assets.iconSettingsNav,
                                'C',
                                3,
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
                        height: 50,
                        color: AppColors.AppColor2,
                        child: BannerAds())
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
    margin = const EdgeInsets.only(left: 2.0, right: 1.0);

    if (index == 1) {
      margin = EdgeInsets.fromLTRB(2, isSelected ? 0 : 10, 2, 0);
    } else {
      margin = EdgeInsets.fromLTRB(0, isSelected ? 0 : 10, 0, 0);
    }
    BorderRadius borderRadius;

    Color textColor = isSelected ? AppColors.mainBgColor : AppColors.AppColor2;
    Color iconColor = isSelected ? AppColors.mainBgColor : AppColors.AppColor2;
    Color btnColor = isSelected ? AppColors.AppColor2 : AppColors.AppColor3;

    borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(8.0),
      topRight: Radius.circular(8.0),
    );

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabTapped(index),
        child: Container(
          // margin: margin,
          padding: margin,
          child: Container(
            decoration: BoxDecoration(
              color: btnColor,
              borderRadius: borderRadius,
            ),
            padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
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
      case 1:
        return HeartRateScreen();
      case 2:
        return InfomationScreen();
      case 3:
        return SettingScreen();
      default:
        return Container();
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
            barrierColor: Colors.black.withOpacity(0.75),
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
                        ),
                        // Center(
                        //   child: const Padding(
                        //     padding: const EdgeInsets.all(8),
                        //     child: AdsNative(
                        //       templateType: TemplateType.medium,
                        //       nativeAdUnitId: AdsIdConfig.nativeInAppAdsId,
                        //     ),
                        //   ),
                        // ),
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
