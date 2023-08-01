import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../controllers/stores/sugar_info_store.dart';
import '../../utils/locale/appLocalizations.dart';
import '../home/record_info_slide_bar/record_info_slide_bar_item.dart';

class RecordHistory extends StatefulWidget {
  const RecordHistory({super.key});

  @override
  State<RecordHistory> createState() => _RecordHistoryState();
}

class _RecordHistoryState extends State<RecordHistory> {
  SugarInfoStore? sugarInfoStore;

  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        backgroundColor: AppColors.AppColor2,
        title: Container(
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 12),
                      child: SvgPicture.asset(
                        Assets.iconBack,
                        height: 44,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${AppLocalizations.of(context)!.getTranslate('record_history')}",
                      style: AppTheme.Headline20Text,
                      overflow: TextOverflow.ellipsis, // Hiển thị dấu chấm ba khi có tràn
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          // margin: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
          margin: EdgeInsets.fromLTRB(27, 16, 12, 16),
          child: sugarInfoStore!.listRecord != null && sugarInfoStore!.listRecord!.isNotEmpty
              ? GridView.count(
                  childAspectRatio: 1.5,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: buildHistoryRecord(),
                )
              : Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(Assets.history_mpt, width: 146, height: 146),
                      SizedBox(height: 30),
                      Text("${AppLocalizations.of(context)!.getTranslate('you_have_not_record')}",
                          textAlign: TextAlign.center,
                          style:
                              AppTheme.TextIntroline16Text.copyWith(fontWeight: FontWeight.w700, color: Colors.black)),
                    ],
                  ),
                ) //Trường hợp chưa có record,
          ),
    );
  }

  List<Widget> buildHistoryRecord() {
    return sugarInfoStore!.listRecord!.map((e) {
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
