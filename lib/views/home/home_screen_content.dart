import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/controllers/stores/sugar_info_store.dart';
import 'package:blood_sugar_tracking/views/home/record_info_slide_bar/record_info_slide_bar.dart';
import 'package:blood_sugar_tracking/views/home/top_widget_home_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../constants/assets.dart';
import '../../routes.dart';
import '../../utils/locale/appLocalizations.dart';
import '../../widgets/button_widget.dart';
import 'average_info_slide_bar/average_info_slidebar.dart';
import 'chart/chart_widget.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({
    super.key,
  });

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  SugarInfoStore? sugarInfoStore;
  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);

    // TODO: implement didChangeDependencies
    // sugarInfoStore!.setListRecordArrangedByTime();
    sugarInfoStore!.setListRecordArrangedByTime();
    if (sugarInfoStore!.listRecord != null &&
        sugarInfoStore!.listRecord!.isNotEmpty) {
      sugarInfoStore!.getAverageNumber();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.32,
          child: Stack(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight * 0.24384236453,
                color: AppColors.AppColor2,
                padding: const EdgeInsets.only(top: 20),
                child: const TopWidgetHomeContent(),
              ),
              const Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 20,
                child: AverageInfoSlideBarWidget(),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            primary: true,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const ChartWidget(),
                RecordInfoSlideBarWidget(),
                const SizedBox(
                  height: 5,
                ),
                ButtonWidget(
                  mainAxisSizeMin: true,
                  btnText: "new_record",
                  btnColor: AppColors.AppColor4,
                  suffixIconPath: Assets.iconEditBtn,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.new_record);
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
