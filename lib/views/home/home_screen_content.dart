import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/controllers/stores/sugar_info_store.dart';
import 'package:blood_sugar_tracking/views/home/record_info_slide_bar/record_info_slide_bar.dart';
import 'package:blood_sugar_tracking/views/home/top_widget_home_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../constants/assets.dart';
import '../../utils/ads_ios/ads.dart';
import '../../widgets/goal_dialog/goal_far_dialog.dart';
import '../../widgets/update_version_dialog.dart';
import 'chart_widget/chart_widget.dart';
import '../../models/sugar_info/sugar_info.dart';
import '../../routes.dart';
import '../../utils/locale/appLocalizations.dart';
import '../../widgets/button_widget.dart';
import 'average_info_slide_bar/average_info_slidebar.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({
    super.key,
  });

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  SugarInfoStore? sugarInfoStore;
  bool? isFirst = false;
  List<SugarRecord>? listRecords = [];

  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);

    // TODO: implement didChangeDependencies
    // sugarInfoStore!.setListRecordArrangedByTime();
    sugarInfoStore!.setListRecordArrangedByTime();
    if (sugarInfoStore!.listRecord != null &&
        sugarInfoStore!.listRecord!.isNotEmpty) {
      sugarInfoStore!.getAverageNumber();
      sugarInfoStore!.homeScreenContext = context;
      listRecords = sugarInfoStore!.listRecordArrangedByTime!;
    }
    if (isFirst = true) {
      sugarInfoStore!.setConditionFilterId("all");
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Observer(builder: (_) {
      return Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    color: AppColors.AppColor2,
                    height: screenHeight * 0.19,
                     padding: const EdgeInsets.only(top: 10),
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.transparent,
                            height:
                                MediaQuery.of(context).size.height * 0.20 / 2,
                            child: const TopWidgetHomeContent()),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  primary: true,
                  physics: const BouncingScrollPhysics(),
                  child: Observer(builder: (_) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.18 / 2,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.getTranslate('chart')}",
                                style: AppTheme.TextIntroline16Text.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.AppColor2),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: sugarInfoStore!
                                                  .listRecordArrangedByTime! !=
                                              null &&
                                          sugarInfoStore!
                                              .listRecordArrangedByTime!
                                              .isNotEmpty
                                      ? Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 0),
                                          child: Observer(builder: (_) {
                                            return ScrollableChart(
                                              listRecords: sugarInfoStore!
                                                  .listRecordArrangedByTime!,
                                            );
                                          }),
                                        )
                                      : Image.asset(Assets.empty_chart)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
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
                        ),
                        // const AdsBanner()
                        // GestureDetector(
                        //   onTap: () {
                        //     showDiaLogUpdateVersion(context);
                        //   },
                        //   child: Container(
                        //     width: 20,
                        //     height: 20,
                        //     color: Colors.amber,
                        //   ),
                        // )
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
          Positioned(
            top:  MediaQuery.of(context).size.height * 0.20 * 0.68,
            left: 0,
            right: 0,
            child: sugarInfoStore!.recentNumber != null
                ? const AverageInfoSlideBarWidget()
                : Container(),
          ),
        ],
      );
    });
  }

  Future<String?> showDiaLogUpdateVersion(
    BuildContext context,
  ) {
    return showDialog<String>(
      context: context,
      builder: (
        BuildContext context,
      ) =>
          UpdateVersionDialog(),
    );
  }

  Future<String?> showDiaLogGoal(
    BuildContext context,
  ) {
    return showDialog<String>(
      context: context,
      builder: (
        BuildContext context,
      ) =>
          GoalFarDialog(),
    );
  }
}
