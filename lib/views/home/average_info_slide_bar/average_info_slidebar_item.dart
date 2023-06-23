import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../constants/app_theme.dart';
import '../../../constants/colors.dart';
import '../../../utils/locale/appLocalizations.dart';

class AverageInfoSlideBarItemWidget extends StatefulWidget {
  String? typeAverage = "";
  String? title = "";
  bool? hasType = false;
  double? number = 0;
  AverageInfoSlideBarItemWidget(
      {super.key,
      this.typeAverage,
      required this.hasType,
      required this.title,
      required this.number});

  @override
  State<AverageInfoSlideBarItemWidget> createState() =>
      _AverageInfoSlideBarItemWidgetState();
}

class _AverageInfoSlideBarItemWidgetState
    extends State<AverageInfoSlideBarItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.12,
      // width: MediaQuery.of(context).size.width * 0.39,
      margin: const EdgeInsets.only(right: 10, top: 20),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: AppColors.AppColor3),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15),
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
                  child: Observer(builder: (_) {
                    return Text(
                      "${widget.number}",
                      style: AppTheme.appBodyTextStyle36,
                    );
                  }),
                ),
                Text("mg/dL", style: AppTheme.appBodyTextStyle),
              ],
            ),
          )
        ],
      ),
    );
  }
}
