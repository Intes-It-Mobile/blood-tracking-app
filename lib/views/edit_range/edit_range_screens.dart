import 'dart:convert';

import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../utils/locale/appLocalizations.dart';

class EditRangeScreens extends StatefulWidget {
  const EditRangeScreens({Key? key}) : super(key: key);

  @override
  State<EditRangeScreens> createState() => _EditRangeScreensState();
}

class _EditRangeScreensState extends State<EditRangeScreens> {
  List<EditTargetRange> editTargetRange = [
    EditTargetRange(name: 'Default', max: 7.0, min: 4.0),
    EditTargetRange(name: 'Before exercise', max: 8.5, min: 4.0),
    EditTargetRange(name: 'Before a meal', max: 7.0, min: 4.0),
    EditTargetRange(name: 'After a meal (1h)', max: 8.5, min: 4.0),
    EditTargetRange(name: 'After a meal (2h)', max: 7.0, min: 4.0),
    EditTargetRange(name: 'After exercise', max: 7.0, min: 4.0),
    EditTargetRange(name: 'Asleep', max: 8.0, min: 4.5),
  ];

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
                        "${AppLocalizations.of(context)!.getTranslate('edit_target_range')}",
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
        body: Stack(
          children: [
            ListView.builder(
                primary: true,
                physics: const BouncingScrollPhysics(),
                itemCount: editTargetRange.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.23,
                    width: double.infinity,
                    color: index.isEven || index == 0
                        ? AppColors.AppColor3
                        : Colors.white,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Text(
                                editTargetRange[index].name,
                                style: AppTheme.hintText.copyWith(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800),
                              ),
                              const Spacer(),
                              SvgPicture.asset(Assets.iconEditRange),
                              const SizedBox(
                                width: 24,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${AppLocalizations.of(context)!.getTranslate('low')}",
                                        style: AppTheme.hintText.copyWith(
                                            fontSize: 12,
                                            color: AppColors.LowStt,
                                            fontWeight: FontWeight.w700),
                                        // Hiển thị dấu chấm ba khi có tràn
                                        maxLines: 2,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text('<' +
                                          '${editTargetRange[index].min.toString()}'),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.getTranslate('normal')}",
                                      style: AppTheme.hintText.copyWith(
                                          fontSize: 12,
                                          color: AppColors.NormalStt,
                                          fontWeight: FontWeight.w700),
                                      // Hiển thị dấu chấm ba khi có tràn
                                      maxLines: 2,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text('${editTargetRange[index].min.toString()}' +
                                        '~' +
                                        '${editTargetRange[index].max.toString()}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${AppLocalizations.of(context)!.getTranslate('pre_diabetes')}",
                                        style: AppTheme.hintText.copyWith(
                                            fontSize: 12,
                                            color: AppColors.PreDiaStt,
                                            fontWeight: FontWeight.w700),
                                        // Hiển thị dấu chấm ba khi có tràn
                                        maxLines: 2,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text('${editTargetRange[index].min.toString()}' +
                                          '~' +
                                          '${editTargetRange[index].max.toString()}'),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.getTranslate('diabetes')}",
                                      style: AppTheme.hintText.copyWith(
                                          fontSize: 12,
                                          color: AppColors.DiabetesStt,
                                          fontWeight: FontWeight.w700),
                                      // Hiển thị dấu chấm ba khi có tràn
                                      maxLines: 2,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text('>=' +
                                        '${editTargetRange[index].max.toString()}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            Container(
              padding: const EdgeInsets.all(8),
              height: 72,
              width: double.infinity,
              color: AppColors.AppColor4,
              child: Text(
                "${AppLocalizations.of(context)!.getTranslate('notification')}",
                style: AppTheme.hintText
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
                textAlign: TextAlign.justify,
                maxLines: 3,
              ),
            )
          ],
        ));
  }
}

class EditTargetRange {
  final String name;
  final double max;
  final double min;

  EditTargetRange({
    required this.name,
    required this.max,
    required this.min,
  });
}
