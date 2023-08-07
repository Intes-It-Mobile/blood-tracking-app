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

  String getFormattedValue(String input) {
    // Tìm vị trí của dấu chấm trong chuỗi
    int dotIndex = input.indexOf('.');

    if (dotIndex != -1) {
      // Lấy các kí tự trước dấu chấm
      String beforeDot = input.substring(0, dotIndex);

      // Lấy kí tự sau dấu chấm và kiểm tra độ dài
      String afterDot = input.substring(dotIndex + 1);
      if (afterDot.length > 2) {
        // Giới hạn độ dài của kí tự sau dấu chấm là 2
        afterDot = afterDot.substring(0, 2);
      }

      // Kết hợp các kết quả lại với nhau
      String formattedValue = beforeDot + '.' + afterDot;

      return formattedValue;
    }

    // Nếu không tìm thấy dấu chấm, trả về giá trị gốc
    return input;
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                color: AppColors.AppColor3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                                "${getFormattedValue(widget.sugarAmount.toString())}",
                                style: AppTheme.appBodyTextStyle26.copyWith(fontSize: 32))
                            : Text("${widget.sugarAmount}",
                                style: AppTheme.appBodyTextStyle26.copyWith(fontSize: 32)),
                      ),
                      Text(
                          "${sugarInfoStore!.isSwapedToMol == true ? AppLocalizations.of(context)!.getTranslate('mmol/L') : AppLocalizations.of(context)!.getTranslate('mg/dL')}",
                          style: AppTheme.appBodyTextStyle),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Text("${AppLocalizations.of(context)!.getTranslate('status')}" + ": ",
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
          right: 8,
          child: SvgPicture.asset(Assets.iconEdit),
        ),
      ],
    );
  }
}
