import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/views/home/record_info_slide_bar/record_info_slide_bar.dart';
import 'package:blood_sugar_tracking/views/home/top_widget_home_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/assets.dart';
import '../../routes.dart';
import '../../utils/locale/appLocalizations.dart';
import '../../widgets/button_widget.dart';
import 'average_info_slide_bar/average_info_slidebar.dart';
import 'chart/chart_widget.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: screenWidth,
          height: screenHeight * 0.24384236453,
          color: AppColors.AppColor2,
        ),
        Container(
            child: SingleChildScrollView(
          child: Column(
            children: [
              TopWidgetHomeContent(),
              AverageInfoSlideBarWidget(),
              ChartWidget(),
              RecordInfoSlideBarWidget(),
              ButtonWidget(
                mainAxisSizeMin: true,
                btnText: "new_record",
                btnColor: AppColors.AppColor4,
                suffixIconPath: Assets.iconEditBtn,
                onTap: (){
                  Navigator.of(context).pushNamed(Routes.new_record);
                },
              )
            ],
          ),
        )),
      ],
    );
  }
}
