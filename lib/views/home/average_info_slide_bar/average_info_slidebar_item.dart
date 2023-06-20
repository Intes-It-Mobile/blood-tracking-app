
import 'package:flutter/cupertino.dart';

import '../../../constants/app_theme.dart';
import '../../../constants/colors.dart';
import '../../../utils/locale/appLocalizations.dart';

class AverageInfoSlideBarItemWidget extends StatefulWidget {
  String? typeAverage = "";
  String? title = "";
  bool? hasType = false;
  AverageInfoSlideBarItemWidget(
      {super.key,
      this.typeAverage,
      required this.hasType,
      required this.title});

  @override
  State<AverageInfoSlideBarItemWidget> createState() =>
      _AverageInfoSlideBarItemWidgetState();
}

class _AverageInfoSlideBarItemWidgetState extends State<AverageInfoSlideBarItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: AppColors.AppColor3),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Text(
              widget.hasType == true
                  ? "${AppLocalizations.of(context)!.getTranslate('${widget.title}')} (${AppLocalizations.of(context)!.getTranslate('${widget.typeAverage}')})"
                  : "${AppLocalizations.of(context)!.getTranslate('${widget.title}')}",
              style: AppTheme.appBodyTextStyle,
            ),
          ),
          Center(
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
          )
        ],
      ),
    );
  }
}
