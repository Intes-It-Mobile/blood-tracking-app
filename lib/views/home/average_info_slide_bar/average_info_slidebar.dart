import 'package:blood_sugar_tracking/controllers/stores/sugar_info_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_theme.dart';
import '../../../constants/colors.dart';
import '../../../utils/locale/appLocalizations.dart';
import 'average_info_slidebar_item.dart';

class AverageInfoSlideBarWidget extends StatefulWidget {
  const AverageInfoSlideBarWidget({super.key});

  @override
  State<AverageInfoSlideBarWidget> createState() =>
      _AverageInfoSlideBarWidgetState();
}

class _AverageInfoSlideBarWidgetState extends State<AverageInfoSlideBarWidget> {
  SugarInfoStore? sugarInfoStore;

  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 15,),
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        primary: true,
        scrollDirection: Axis.horizontal,
        child: Observer(builder: (_) {
          return Row(
            children: [
              AverageInfoSlideBarItemWidget(
                  hasType: false,
                  title: "recent_txt",
                  number: sugarInfoStore!.recentNumber),
              AverageInfoSlideBarItemWidget(
                  hasType: true,
                  title: "average_txt",
                  typeAverage: "3_days",
                  number: sugarInfoStore!.threeDaysNumber),
              AverageInfoSlideBarItemWidget(
                  hasType: true,
                  title: "average_txt",
                  typeAverage: "week",
                  number: sugarInfoStore!.weekNumber),
              AverageInfoSlideBarItemWidget(
                  hasType: true,
                  title: "average_txt",
                  typeAverage: "month",
                  number: sugarInfoStore!.monthNumber),
              AverageInfoSlideBarItemWidget(
                  hasType: true,
                  title: "average_txt",
                  typeAverage: "year",
                  number: sugarInfoStore!.yearNumber),
              AverageInfoSlideBarItemWidget(
                  hasType: true,
                  title: "average_txt",
                  typeAverage: "all",
                  number: sugarInfoStore!.allNumber),
            ],
          );
        }),
      ),
    );
  }
}
