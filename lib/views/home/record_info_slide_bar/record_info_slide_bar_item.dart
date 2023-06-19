// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/app_theme.dart';
import '../../../constants/assets.dart';
import '../../../constants/colors.dart';
import '../../../utils/locale/appLocalizations.dart';

class RecordInfoSliderItemWidget extends StatefulWidget {
  String? status;

  RecordInfoSliderItemWidget({super.key, required this.status});

  @override
  State<RecordInfoSliderItemWidget> createState() => _RecordInfoSliderItemWidgetState();
}

class _RecordInfoSliderItemWidgetState extends State<RecordInfoSliderItemWidget> {
  Color? SttTextColor(String? value) {
    switch (value) {
      case 'normal':
        return AppColors.NormalStt;
      case 'diabetes':
        return AppColors.DiabetesStt;
      case 'pre_diabetes':
        return AppColors.PreDiaStt;
      case 'low':
        return AppColors.LowStt;
      default:
        throw RangeError("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: AppColors.AppColor3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(right: 7),
                        child: Text(
                          "2023/06/15",
                          style: AppTheme.timeText,
                        )),
                    Container(
                        margin: EdgeInsets.only(right: 7),
                        child: Text(
                          "15:58",
                          style: AppTheme.timeText,
                        )),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: SvgPicture.asset(
                    Assets.iconEdit,
                    width: 18,
                    height: 18,
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  child: Text(
                    "4.0",
                    style: AppTheme.appBodyTextStyle36,
                  ),
                ),
                Text("mmol/L", style: AppTheme.appBodyTextStyle),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Text("Status : ", style: AppTheme.appBodyTextStyle.copyWith(color: Colors.black)),
                Text(
                  "${AppLocalizations.of(context)!.getTranslate('${widget.status}')}",
                  style: AppTheme.statusTxt.copyWith(color: SttTextColor(widget.status)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
