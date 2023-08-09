import 'package:blood_sugar_tracking/controllers/stores/edit_range_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../controllers/stores/sugar_info_store.dart';
import '../../models/sugar_info/sugar_info.dart';
import '../../utils/locale/appLocalizations.dart';

class EditRangeItem extends StatefulWidget {
  String? conditionName;
  int? id;
  String? status;
  double? minValue, maxValue;
  bool? isLastItem;
  Function(String value, int id)? onEdit;
  EditRangeItem(
      {super.key,
      this.id,
      this.conditionName,
      this.maxValue,
      this.minValue,
      this.status,
      this.onEdit,
      this.isLastItem});

  @override
  State<EditRangeItem> createState() => _EditRangeItemState();
}

class _EditRangeItemState extends State<EditRangeItem> {
  SugarInfoStore? sugarInfoStore;
  EditRangeStore? editRangeStore;
  TextEditingController maxValueController = TextEditingController();
  List<SugarAmount> tempConditionDisplay = [];

  bool? can = false;
  @override
  void initState() {
    maxValueController.text = cutString(widget.maxValue!);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    editRangeStore = EditRangeStore();
    tempConditionDisplay = sugarInfoStore!.tempConditionDisplay;
    super.didChangeDependencies();
  }

  String cutString(double number) {
    if (number.toString().length > 6) {
      String numberString = number.toString();
      String before = numberString.split('.').first;
      String after = numberString.split('.').last.substring(0, 1);
      return "${before}.${after}";
    } else {
      return "${number.toString()}";
    }
  }

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

  setMaxValue(String value) {
    double doubleValue = double.parse(value);
    tempConditionDisplay.where((e) => e.id == widget.id).first.maxValue =
        doubleValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${AppLocalizations.of(context)!.getTranslate('${widget.status}')}",
              style: AppTheme.appBodyTextStyle
                  .copyWith(color: SttTextColor(widget.status)),
            ),
            SizedBox(
              height: 12,
            ),
            widget.isLastItem != true
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Text("${cutString(widget.minValue!)}",
                            style: AppTheme.appBodyTextStyle
                                .copyWith(color: Colors.black)),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        child: Text("~",
                            style: AppTheme.appBodyTextStyle
                                .copyWith(color: Colors.black)),
                      ),
                      Container(
                          // padding: Ed,
                          width: 60,
                          // height: 30,
                          // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: AppColors.AppColor3,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Container(
                            // color: Colors.amber,
                            child: Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                },
                                child: TextField(
                                  cursorColor: AppColors.AppColor2,
                                  textAlignVertical: TextAlignVertical.top,
                                  
                                  // cursorHeight: 10,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    CustomInputFormatter(),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d{0,3}\.?\d{0,1}')),
                                  ],
                                  // inputFormatters: [
                                  //   LengthLimitingTextInputFormatter(5),
                                  //   // Allow Decimal Number With Precision of 2 Only
                                  // FilteringTextInputFormatter.allow(
                                  //     RegExp(r'^\d{0,3}\.?\d{0,2}')),
                                  // ],
                                  controller: maxValueController,
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {
                                    setMaxValue(maxValueController.text);
                                  },
                                  onSubmitted: (value) {
                                    setMaxValue(maxValueController.text);
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 1),
                                      border: InputBorder.none,
                                      hintStyle: AppTheme.appBodyTextStyle
                                          .copyWith(color: Colors.black)),
                                  style: AppTheme.appBodyTextStyle
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ),
                          )),
                    ],
                  )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 8),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          child: Text(">=",
                              style: AppTheme.appBodyTextStyle
                                  .copyWith(color: Colors.black)),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Text("${cutString(widget.minValue!)}",
                              style: AppTheme.appBodyTextStyle
                                  .copyWith(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
          ]),
    );
  }
}

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (text.contains('.')) {
      // Nếu có dấu "." trong chuỗi, giới hạn tối đa 5 ký tự
      if (text.length <= 5) {
        return newValue;
      } else {
        // Nếu nhập quá 5 ký tự, không cho phép cập nhật giá trị
        return oldValue;
      }
    } else {
      // Nếu không có dấu ".", giới hạn tối đa 4 ký tự
      if (text.length <= 4) {
        return newValue;
      } else {
        // Nếu nhập quá 4 ký tự, không cho phép cập nhật giá trị
        return oldValue;
      }
    }
  }
}
