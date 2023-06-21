// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/app_theme.dart';
import '../../../constants/assets.dart';
import '../../../constants/colors.dart';
import '../../../utils/locale/appLocalizations.dart';

class RecordInfoSliderItemWidget extends StatefulWidget {
  String? status = "default_txt";
  String? dayTime = "";
  String? hourTime = "";
  double? sugarAmount = 0.0;

  RecordInfoSliderItemWidget(
      {super.key,
      required this.status,
      this.dayTime,
      this.hourTime,
      this.sugarAmount});

  @override
  State<RecordInfoSliderItemWidget> createState() =>
      _RecordInfoSliderItemWidgetState();
}

class _RecordInfoSliderItemWidgetState
    extends State<RecordInfoSliderItemWidget> {
  String? date = "2023/06/15";
  String? time = "15:58";

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
    return Stack(
      children: [
        Container(
          width: (MediaQuery.of(context).size.width / 350) * 144,
          // padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          padding: EdgeInsets.fromLTRB(7, 5, 9, 5),
          margin: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              color: AppColors.AppColor3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "${widget.dayTime}   ${widget.hourTime}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.timeText,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Text(
                        "${widget.sugarAmount}",
                        style: AppTheme.appBodyTextStyle36.copyWith(fontSize: 32),
                      ),
                    ),
                    Text("mmol/L", style: AppTheme.appBodyTextStyle),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Text("Status : ",
                        style: AppTheme.appBodyTextStyle
                            .copyWith(color: Colors.black)),
                    Text(
                      "${AppLocalizations.of(context)!.getTranslate('${widget.status}')}",
                      style: AppTheme.statusTxt
                          .copyWith(color: SttTextColor(widget.status)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 20,
          child: SvgPicture.asset(Assets.iconEdit),
        ),
      ],
    );
  }
}
