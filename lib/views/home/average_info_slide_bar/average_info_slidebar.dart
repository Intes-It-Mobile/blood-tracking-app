import 'package:flutter/cupertino.dart';

import '../../../constants/app_theme.dart';
import '../../../constants/colors.dart';
import '../../../utils/locale/appLocalizations.dart';
import 'average_info_slidebar_item.dart';

class AverageInfoSlideBarWidget extends StatefulWidget {
  const AverageInfoSlideBarWidget({super.key});

  @override
  State<AverageInfoSlideBarWidget> createState() => _AverageInfoSlideBarWidgetState();
}

class _AverageInfoSlideBarWidgetState extends State<AverageInfoSlideBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 15,),
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        primary: true,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            AverageInfoSlideBarItemWidget(hasType: false, title: "recent_txt"),
            AverageInfoSlideBarItemWidget(
                hasType: true, title: "average_txt", typeAverage: "3_days"),
            AverageInfoSlideBarItemWidget(
                hasType: true, title: "average_txt", typeAverage: "week"),
            AverageInfoSlideBarItemWidget(
                hasType: true, title: "average_txt", typeAverage: "month"),
            AverageInfoSlideBarItemWidget(
                hasType: true, title: "average_txt", typeAverage: "year"),
            AverageInfoSlideBarItemWidget(
                hasType: true, title: "average_txt", typeAverage: "all"),
          ],
        ),
      ),
    );
  }
}
