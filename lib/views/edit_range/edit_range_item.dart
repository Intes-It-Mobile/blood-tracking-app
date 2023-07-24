import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../controllers/stores/sugar_info_store.dart';
import '../../models/sugar_info/sugar_info.dart';

class EditRangeItem extends StatefulWidget {
  String? conditionName;
  int? id;
  String? status;
  double? minValue, maxValue;
  EditRangeItem(
      {super.key,
      this.id,
      this.conditionName,
      this.maxValue,
      this.minValue,
      this.status});

  @override
  State<EditRangeItem> createState() => _EditRangeItemState();
}

class _EditRangeItemState extends State<EditRangeItem> {
  SugarInfoStore? sugarInfoStore;
  TextEditingController maxValueController = TextEditingController();

  @override
  void initState() {
    maxValueController.text = "${widget.maxValue}";
    super.initState();
  }

  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);

    super.didChangeDependencies();
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
    sugarInfoStore!.tempConditionDisplay
        .where((e) => e.id == widget.id)
        .first
        .maxValue = doubleValue;

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
              "${widget.status}",
              style: AppTheme.appBodyTextStyle
                  .copyWith(color: SttTextColor(widget.status)),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Text("${widget.minValue}",
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
                    width: 60,
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: AppColors.AppColor3,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Container(
                      color: Colors.amber,
                      child: Center(
                        child: TextField(
                          controller: maxValueController,
                          textAlign: TextAlign.center,
                          // onChanged: setMaxValue(maxValueController.text),
                          onSubmitted: setMaxValue(maxValueController.text),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 1),
                              border: InputBorder.none,
                              hintText: "${widget.maxValue}",
                              hintStyle: AppTheme.appBodyTextStyle
                                  .copyWith(color: Colors.black)),
                          style: AppTheme.appBodyTextStyle
                              .copyWith(color: Colors.black),
                        ),
                      ),
                    )

                    // Text("${widget.maxValue}",
                    //     style: AppTheme.appBodyTextStyle
                    //         .copyWith(color: Colors.black)),
                    ),
              ],
            )
          ]),
    );
  }
}
