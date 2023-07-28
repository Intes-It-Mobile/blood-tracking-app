import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/constants/font_family.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatetime extends StatelessWidget {
  CustomDatetime({super.key, required this.date});
  DateTime date;

  TextStyle _textStyle = TextStyle(
    color: Colors.black,
    fontFamily: FontFamily.roboto,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildDateCustom(),
        Spacer(),
        _buildTimeCustom()
      ],
    );
  }

  Container _buildDateCustom() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.AppColor3,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [ 
          customText(DateFormat('yyyy').format(date)),
          customText(DateFormat('MM').format(date)),
          customText(DateFormat('dd').format(date)),
        ],
      ),
    );
  }

  Container _buildTimeCustom() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.AppColor3,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          customText(DateFormat('HH').format(date)),
          Text(
            ":",
            style: _textStyle,
          ),
          customText(DateFormat('mm').format(date)),
        ],
      ),
    );
  }

  Widget customText(String content){
    return Container(
      height: 32,
      width: 60,
      alignment: Alignment.center,
      child: Text(
        content,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: _textStyle,
      ),
    );
  }

}