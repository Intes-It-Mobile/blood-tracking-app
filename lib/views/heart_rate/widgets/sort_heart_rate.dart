import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/constants/font_family.dart';
import 'package:blood_sugar_tracking/utils/device/size_config.dart';
import 'package:blood_sugar_tracking/utils/locale/appLocalizations.dart';
import 'package:flutter/material.dart';

class SortHeartRate extends StatelessWidget {
  SortHeartRate({super.key, required this.indicator});
  final int indicator;
  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.AppColor3
      ),
      child: Column(
        children: [
          _showStatus(),
          _showIndicator()
        ],  
      ),
    );
  }

  Container _showStatus() {
    return Container(
      padding: const EdgeInsets.only(top: 7, left: 6, right: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusColor(color: AppColors.LowStt, check: indicator<=60),
          _buildStatusColor(color: AppColors.NormalStt, check: indicator>60 && indicator<=100),
          _buildStatusColor(color: AppColors.DiabetesStt, check: indicator>100),
          const SizedBox(width: 10),
          _buildStatusString(),
          const Spacer(),
          _buildStatusInt()
        ],
      ),
    );
  }

  Widget _buildStatusColor({required Color color, required bool check}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        children: [
          Container(
            height: 20,
            width: 28,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5)
            ),
          ),
          if (check)
            const Icon(
              Icons.arrow_drop_up_rounded, 
              color: AppColors.AppColor4,
            )
        ]
      ),
    );
  }

  Widget _buildStatusString() {
    return Text(
      indicator > 100
        ? "Fast"
        : indicator > 60
          ? "Normal"
          : "Slow",
      style: TextStyle(
        fontSize: TextSizeConfig.getAdjustedFontSize(12),
        fontFamily: FontFamily.IBMPlexSans,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        letterSpacing: 0.6,
        color: indicator > 100
                  ? AppColors.DiabetesStt
                  : indicator > 60
                    ? AppColors.NormalStt
                    : AppColors.LowStt,
      )
    );
  }

Widget _buildStatusInt() {
    return Text(
      indicator > 100
        ? ">100"
        : indicator > 60
          ? "60~100"
          : "1~60",
      style: TextStyle(
        fontSize: TextSizeConfig.getAdjustedFontSize(12),
        fontFamily: FontFamily.IBMPlexSans,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        letterSpacing: 0.6,
        color: Colors.black,
      )
    );
  }

  Container _showIndicator() {
    return Container(
      padding: const EdgeInsets.only(left: 50, top: 9, bottom: 9, right: 76),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.AppColor4
                  )
                )
              ),
              child: Text(
                indicator.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: TextSizeConfig.getAdjustedFontSize(50),
                  fontFamily: FontFamily.IBMPlexSans,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(width: 25),
          Text(
            AppLocalizations.of(context).getTranslate("bpm"),
            style: TextStyle(
              fontSize: TextSizeConfig.getAdjustedFontSize(12),
              fontFamily: FontFamily.IBMPlexSans,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              color: Colors.black,
            ),
          )
        ]
        
      ),
    );
  }
}