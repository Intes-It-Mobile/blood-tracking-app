import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/views/home/record_info_slide_bar/record_info_slide_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../controllers/stores/sugar_info_store.dart';
import '../../../models/sugar_info/sugar_info.dart';
import '../../../routes.dart';

class RecordInfoSlideBarWidget extends StatefulWidget {
  RecordInfoSlideBarWidget({
    super.key,
  });

  @override
  State<RecordInfoSlideBarWidget> createState() =>
      _RecordInfoSlideBarWidgetState();
}

class _RecordInfoSlideBarWidgetState extends State<RecordInfoSlideBarWidget> {
  SugarInfoStore? sugarInfoStore;

  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: sugarInfoStore!.listRecordArrangedByTime!.length <= 3
              ? Row(
                  children: sugarInfoStore!.listRecord != null &&
                          sugarInfoStore!.listRecord!.isNotEmpty
                      ? listRecordDisplay()
                      : [Container()],
                )
              : Row(
                  children: <Widget>[
                    Row(children: listRecordDisplay().sublist(0,3)),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushNamed(Routes.history);
                      },
                      child: Container(
                        height: 85,
                        width: 20,
                        decoration: BoxDecoration(
                          color: AppColors.AppColor3,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                              'assets/icons/ic_chevron_right.svg'),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }

  List<Widget> listRecordDisplay() {
    return sugarInfoStore!.listRecordArrangedByTime!.map((e) {
      return RecordInfoSliderItemWidget(
        id: e.id,
        status: e.status,
        dayTime: e.dayTime,
        hourTime: e.hourTime,
        sugarAmount: e.sugarAmount,
      );
    }).toList();
  }
}
