import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_theme.dart';
import '../../../constants/colors.dart';
import '../../../utils/locale/appLocalizations.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          AppLocalizations.of(context)!.getTranslate('chart'),
          style: AppTheme.BtnText.copyWith(color: AppColors.AppColor2),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        )
      ]),
    );
  }
}
