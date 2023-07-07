// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_theme.dart';
import '../../../constants/assets.dart';
import '../../../constants/colors.dart';
import '../../../controllers/stores/sugar_info_store.dart';
import '../../../models/sugar_info/sugar_info.dart';
import '../../../routes.dart';
import '../../../utils/locale/appLocalizations.dart';

class RecordInfoSliderItemWidget extends StatefulWidget {
  String? status = "default_txt";
  String? dayTime = "";
  String? hourTime = "";
  double? sugarAmount = 0.0;
  int? id = 0;
  RecordInfoSliderItemWidget(
      {super.key,
      required this.status,
      this.dayTime,
      this.hourTime,
      this.sugarAmount,
      this.id});

  @override
  State<RecordInfoSliderItemWidget> createState() =>
      _RecordInfoSliderItemWidgetState();
}

class _RecordInfoSliderItemWidgetState
    extends State<RecordInfoSliderItemWidget> {
  SugarInfoStore? sugarInfoStore;    
  SugarRecord? editRecord;
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
        return AppColors.LowStt;
    }
  }
  final String texttahng = "333.333";

  @override
  void didChangeDependencies() {
        sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(Routes.edit_record,
                arguments: {"record_id": widget.id});
          },
          child: Container(
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
                        child: widget.sugarAmount.toString().length > 7
                            ? Text(
                                "${widget.sugarAmount.toString().substring(0, 7)}",
                                style: AppTheme.appBodyTextStyle26

                              )
                            : Text(
                                "${widget.sugarAmount}",
                                style: AppTheme.appBodyTextStyle26

                              ),
                      ),
                      Text("${sugarInfoStore!.isSwapedToMol == true ? AppLocalizations.of(context)!.getTranslate('mmol/L') : AppLocalizations.of(context)!.getTranslate('mg/dL')}", style: AppTheme.appBodyTextStyle),
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
                        // "abd",
                        style: AppTheme.statusTxt
                            .copyWith(color: SttTextColor(widget.status)),
                      ),
                    ],
                  ),
                )
              ],
            ),
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
