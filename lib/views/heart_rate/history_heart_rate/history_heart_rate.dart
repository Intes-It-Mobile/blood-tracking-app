import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/constants/font_family.dart';
import 'package:blood_sugar_tracking/models/heart_rate/heart_rate_info.dart';
import 'package:blood_sugar_tracking/routes.dart';
import 'package:blood_sugar_tracking/utils/locale/appLocalizations.dart';
import 'package:blood_sugar_tracking/views/heart_rate/history_heart_rate/history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HistoryHeartRateScreen extends StatelessWidget {
  HistoryHeartRateScreen({super.key});
  List<HeartRateInfo> history = [
    HeartRateInfo(
      date: DateTime(2017, 9, 7, 8, 30), 
      indicator: 120
    ),
    HeartRateInfo(
      date: DateTime(2017, 9, 7, 17, 30), 
      indicator: 60
    ),
    HeartRateInfo(
      date: DateTime(2017, 9, 7, 17, 30), 
      indicator: 100
    ),
  ];
  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: _buildAppBarCustom(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBarCustom(){ 
    return AppBar(
      toolbarHeight: 56,
      backgroundColor: AppColors.AppColor2,
      title: Text(
        AppLocalizations.of(context).getTranslate("record_history"),
        style: AppTheme.appBarTextStyle,
      ),
      titleSpacing: 0,
      leadingWidth : 48,
      leading: _buildButtonBack(),
    );
  }

  Widget _buildButtonBack() {
    return InkWell(
      onTap:() {
        Navigator.pop(context);
      },
      child: SvgPicture.asset(
        Assets.iconBack, 
        height: 16,
        width: 20, 
        fit: BoxFit.scaleDown,
      ),
    );
  }

  Widget _buildBody(){
    return Container(
      margin: EdgeInsets.fromLTRB(27, 16, 27, 16),
      child: GridView.count(
        childAspectRatio: 1.5,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        crossAxisCount: 2,
        children: List.generate(
          history.length, 
          (index) 
            => HistoryHeartRateRecord(info: history[index])
        ),
      )
    );
  }
}