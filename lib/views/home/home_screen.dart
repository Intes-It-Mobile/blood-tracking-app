import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blood_sugar_tracking/utils/locale/appLocalizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';

import '../../widgets/customs_bottom_appbar.dart';
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
    return Container(
      child: Stack(
        children: [
          Scaffold(
            // extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: true,
            appBar: CustomAppBar(),
            backgroundColor: Colors.white,

            body: Container(
              // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: _buildPageContent(),
            ),
            bottomNavigationBar: Container(
              color: Colors.transparent,
              margin: EdgeInsets.only(bottom: hasAds ? 75.0 : 30),
              child: BottomAppBarCum(
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
                            Assets.iconHomeNav,
                            'A',
                            0,
                            AppLocalizations.of(context)!
                                .getTranslate('home_page_nav'),
                          ),
                          _buildNavItem(
                              Assets.iconInfoNav,
                              'B',
                              1,
                              AppLocalizations.of(context)!
                                  .getTranslate('info_nav')),
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
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Center(
              child: Column(
                children: [
                  SvgPicture.asset(
                    icon,
                    color: iconColor,
                  ),
                  Text(
                    "${text}",
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.w600),
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
        return InfomationScreen();
      case 2:
        return SettingScreen();
      default:
        return Container();
    }
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(0); // Đặt chiều cao là 0

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: AppColors.AppColor2,
        // Status bar brightness (optional)`
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.dark, // For iOS (dark icons)
      ),

      // Các thuộc tính khác của AppBar
    );
  }
}
