import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WidgetAppBar extends StatelessWidget {
  const WidgetAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.AppColor2,
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 7, bottom: 7, right: 16, left: 16),
        child: Container());
  }
}
