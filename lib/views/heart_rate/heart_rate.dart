import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/constants/font_family.dart';
import 'package:blood_sugar_tracking/routes.dart';
import 'package:blood_sugar_tracking/utils/locale/appLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({super.key});

  @override
  State<HeartRateScreen> createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBarCustom(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBarCustom(){ 
    return AppBar(
      toolbarHeight: 56,
      backgroundColor: AppColors.AppColor2,
      title: Text(
        AppLocalizations.of(context).getTranslate("heart_rate_tracking"),
        style: AppTheme.appBarTextStyle,
      ),
      actions: [
        _buildButtonHeartRateHistory()
      ],
    );
  }

  Widget _buildButtonHeartRateHistory() {
    return InkWell(
      onTap:() {
        Navigator.of(context).pushNamed(Routes.history_heart_rate);
      },
      child: Container(
          height: 32,
          width: 32,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: SvgPicture.asset(Assets.iconHearRate),
        ),
    );
  }

  Widget _buildBody() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButtonHeartRate(),
          _buildButtonNewRecord()
        ],
      ),
    );
  }

  Container _buildButtonHeartRate() {
    return Container(
      height: 181,
      width: 181,
      margin: const EdgeInsets.symmetric(vertical: 36),
      padding: const EdgeInsets.only(top: 25, left: 35, right: 35, bottom: 35),
      decoration: BoxDecoration(
        color: AppColors.AppColor3,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(102, 136, 255, 0.70),
            blurRadius: 40,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Assets.image_heart,
            height: 91,
            width: 91,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          SizedBox(
            width: 110,
            child: Text(
              AppLocalizations.of(context).getTranslate("tap_to_measure"),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.AppColor4,
                fontFamily: FontFamily.IBMPlexSans,
                fontSize: 12,
                fontWeight: FontWeight.w600
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtonNewRecord() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.new_record_heart_rate);
      },
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.AppColor4,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context).getTranslate("new_record"),
              style: TextStyle(
                color: Colors.white,
                fontFamily: FontFamily.IBMPlexSans,
                fontStyle: FontStyle.normal,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(Assets.iconEditBtn)
          ],
        ),
      ),
    );
  }
}