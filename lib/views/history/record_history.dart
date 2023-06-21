import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/locale/appLocalizations.dart';
import '../home/record_info_slide_bar/record_info_slide_bar_item.dart';

class RecordHistory extends StatefulWidget {
  const RecordHistory({super.key});

  @override
  State<RecordHistory> createState() => _RecordHistoryState();
}

class _RecordHistoryState extends State<RecordHistory> {
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
                      overflow: TextOverflow
                          .ellipsis, // Hiển thị dấu chấm ba khi có tràn
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
        // margin: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        margin: EdgeInsets.fromLTRB(27, 16, 12, 16),
        child: GridView.count(
          childAspectRatio: 1.5,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: List.generate(
            15, 
            (index) => RecordInfoSliderItemWidget(
              status: 'normal',
            ),
          ),
        ),
      ),
    );
  }
}
