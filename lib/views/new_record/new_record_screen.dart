import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../utils/locale/appLocalizations.dart';

class NewRecordScreen extends StatefulWidget {
  NewRecordScreen({
    super.key,
  });

  @override
  State<NewRecordScreen> createState() => _NewRecordScreenState();
}

class _NewRecordScreenState extends State<NewRecordScreen> {
  String? type;
  @override
  void didChangeDependencies() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                      "${AppLocalizations.of(context)!.getTranslate('new_record')}",
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
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "${AppLocalizations.of(context)!.getTranslate('date_and_time')}",
                style: AppTheme.Headline16Text.copyWith(
                    color: AppColors.AppColor4),
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 30),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                    decoration: BoxDecoration(
                        color: AppColors.AppColor3,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          child: Text(
                            "2023",
                            style: AppTheme.appBodyTextStyle
                                .copyWith(color: Colors.black),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 35),
                          child: Text(
                            "05",
                            style: AppTheme.appBodyTextStyle
                                .copyWith(color: Colors.black),
                          ),
                        ),
                        Container(
                          child: Text(
                            "17",
                            style: AppTheme.appBodyTextStyle
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                    decoration: BoxDecoration(
                        color: AppColors.AppColor3,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          child: Text(
                            "10",
                            style: AppTheme.appBodyTextStyle
                                .copyWith(color: Colors.black),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            ":",
                            style: AppTheme.appBodyTextStyle
                                .copyWith(color: Colors.black),
                          ),
                        ),
                        Container(
                          child: Text(
                            "5",
                            style: AppTheme.appBodyTextStyle
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "${AppLocalizations.of(context)!.getTranslate('condition')}",
                style: AppTheme.Headline16Text.copyWith(
                    color: AppColors.AppColor4),
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 30),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                    decoration: BoxDecoration(
                        color: AppColors.AppColor3,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          child: Text(
                            "2023",
                            style: AppTheme.appBodyTextStyle
                                .copyWith(color: Colors.black),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 35),
                          child: Text(
                            "05",
                            style: AppTheme.appBodyTextStyle
                                .copyWith(color: Colors.black),
                          ),
                        ),
                        Container(
                          child: Text(
                            "17",
                            style: AppTheme.appBodyTextStyle
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                    decoration: BoxDecoration(
                        color: AppColors.AppColor3,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          child: Text(
                            "10",
                            style: AppTheme.appBodyTextStyle
                                .copyWith(color: Colors.black),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            ":",
                            style: AppTheme.appBodyTextStyle
                                .copyWith(color: Colors.black),
                          ),
                        ),
                        Container(
                          child: Text(
                            "5",
                            style: AppTheme.appBodyTextStyle
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
