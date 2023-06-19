import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../utils/locale/appLocalizations.dart';
import '../../widgets/button_widget.dart';

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
        child: SingleChildScrollView(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "${AppLocalizations.of(context)!.getTranslate('condition')}",
                      style: AppTheme.Headline16Text.copyWith(
                          color: AppColors.AppColor4),
                    ),
                  ),
                  DropDownWidget(),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "${AppLocalizations.of(context)!.getTranslate('sugar_amount')}",
                      style: AppTheme.Headline16Text.copyWith(
                          color: AppColors.AppColor4),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.AppColor3,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: StatusWidget()),
                            Container(
                              child: Row(children: [
                                SvgPicture.asset(Assets.iconEditPen),
                                SizedBox(
                                  width: 10,
                                ),
                                SvgPicture.asset(Assets.iconSwapUnit)
                              ]),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: 165,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  style: AppTheme.sugarInputText,
                                ),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Text(
                                "mg/dL",
                                style: AppTheme.appBodyTextStyle
                                    .copyWith(color: Colors.black),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 11),
                      child: Text(
                        "${AppLocalizations.of(context)!.getTranslate('errow_sugar_input_text')}",
                        style: AppTheme.errorText,
                      ),
                    ),
                  ),
                  Center(
                    child: ButtonWidget(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      mainAxisSizeMin: true,
                      onTap: () {},
                      btnColor: AppColors.AppColor4,
                      btnText: "save_record",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusWidget extends StatefulWidget {
  const StatusWidget({super.key});

  @override
  State<StatusWidget> createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(right: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: 28,
                decoration: BoxDecoration(
                  color: AppColors.LowStt,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                child: SvgPicture.asset(
                  Assets.iconUpArrow,
                  // height: 6,
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: 28,
                decoration: BoxDecoration(
                  color: AppColors.NormalStt,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                child: SvgPicture.asset(
                  Assets.iconUpArrow,
                  // height: 6,
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: 28,
                decoration: BoxDecoration(
                  color: AppColors.PreDiaStt,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                child: SvgPicture.asset(
                  Assets.iconUpArrow,
                  // height: 6,
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: 28,
                decoration: BoxDecoration(
                  color: AppColors.DiabetesStt,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                child: SvgPicture.asset(
                  Assets.iconUpArrow,
                  // height: 6,
                ),
              )
            ],
          ),
        ),
        Text(
          "${AppLocalizations.of(context)!.getTranslate('pre_diabetes')}",
          style: AppTheme.appBodyTextStyle.copyWith(color: AppColors.PreDiaStt),
        ),
      ],
    );
  }
}

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({super.key});

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String selectedType = 'default_txt';
  List<String> types = [
    'default_txt',
    'before_exercise',
    'before_meal',
    'fasting',
    'after_meal_1h',
    "after_meal_2h",
    "after_exercise",
    "asleep"
  ];
  bool showDropdown = false;
  String? getTitle(String? value) {
    return AppLocalizations.of(context)!.getTranslate('${value}');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                showDropdown = !showDropdown;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                  color: AppColors.AppColor3,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${getTitle(selectedType)}",
                    style: AppTheme.appBodyTextStyle.copyWith(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                  Icon(showDropdown
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
          if (showDropdown)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 4),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.AppColor2,
                // border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: Container(
                  height: 220, // Chiều cao tối đa của danh sách
                  child: Container(
                    color: AppColors.AppColor2,
                    child: Scrollbar(
                      isAlwaysShown: true,
                      child: ListView(
                        // physics: BouncingScrollPhysics(),
                        children: types.map((String type) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedType = type;
                                showDropdown = false;
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: DropdownMenuItem<String>(
                                value: type,
                                child: Text(
                                  "${getTitle(type)}",
                                  style: AppTheme.appBodyTextStyle
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
