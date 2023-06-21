import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../controllers/stores/sugar_info_store.dart';
import '../../models/sugar_info/sugar_info.dart';
import '../../routes.dart';
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
  FocusNode focusNode = FocusNode();
  DateTime selectedDateTime = DateTime.now();
  DateTime timeNow = DateTime.now();
  SugarInfoStore? sugarInfoStore;
  bool? isFirst = true;
  String? type;
  DateTime? selectedDate;
  int? id = (DateTime.now()).millisecondsSinceEpoch;
  void _showDatePickerDay() {
    DatePicker.showDatePicker(
      initialDateTime: selectedDateTime ?? DateTime.now(),
      dateFormat: "yyyy/MM/dd",
      context,
      onConfirm: (DateTime day, List<int> index) {
        setState(() {
          selectedDate = day;
          print("Date: ${selectedDate}");
          sugarInfoStore!.setchoosedDayTime(day);
        });
      },
      locale: DateTimePickerLocale.en_us,
    );
  }

  void _showDatePickerHour() {
    DatePicker.showDatePicker(
      initialDateTime: selectedDateTime ?? DateTime.now(),
      dateFormat: "HH:mm",
      context,
      onConfirm: (DateTime hour, List<int> index) {
        setState(() {
          selectedDate = hour;
          print("Date: ${selectedDate}");
          sugarInfoStore!.setchoosedDayHour(hour);
        });
      },
      locale: DateTimePickerLocale.en_us,
    );
  }

  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    if (isFirst == true) {
      sugarInfoStore!.setChooseCondition(0);
      sugarInfoStore!.setStatusLevel("low");
      isFirst == false;
    }
  }

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        backgroundColor: AppColors.AppColor2,
        title: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    print(sugarInfoStore!
                        .rootSugarInfo!.conditions!.first.name);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
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
              GestureDetector(
                onTap: () {
                  _showDatePickerDay();
                },
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 30),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                        decoration: BoxDecoration(
                            color: AppColors.AppColor3,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              child: Text(
                                sugarInfoStore!.choosedDayTimeStr != null
                                    ? sugarInfoStore!.choosedDayTimeStr!
                                    : DateFormat('yyyy     MM     dd').format(DateTime.now()),
                                style: AppTheme.appBodyTextStyle
                                    .copyWith(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showDatePickerHour();
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                          decoration: BoxDecoration(
                              color: AppColors.AppColor3,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                child: Text(
                                  sugarInfoStore!.choosedDayHourStr != null
                                      ? sugarInfoStore!.choosedDayHourStr!
                                      : DateFormat('HH:mm').format(DateTime.now()),
                                  style: AppTheme.appBodyTextStyle
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                  sugarInfoStore!.listRootConditions != null
                      ? DropDownWidget(
                          listConditions: sugarInfoStore!.listRootConditions,
                        )
                      : Container(),
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
                                  focusNode: focusNode,
                                  onChanged: (value) {
                                    sugarInfoStore!.setInputSugarAmount(
                                        int.parse(value) * 1.0);
                                    sugarInfoStore!
                                        .checkValidateSugarAmountInput(
                                            int.parse(value) * 1.0);
                                    print(value);
                                  },
                                  textAlign: TextAlign.center,
                                  onSubmitted: (value) {
                                    sugarInfoStore!.setInputSugarAmount(
                                        int.parse(value) * 1.0);
                                    sugarInfoStore!
                                        .checkValidateSugarAmountInput(
                                            int.parse(value) * 1.0);
                                    print(value);
                                  },
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
                  sugarInfoStore!.legalInput == false
                      ? Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 11),
                            child: Text(
                              "${AppLocalizations.of(context)!.getTranslate('errow_sugar_input_text')}",
                              style: AppTheme.errorText,
                            ),
                          ),
                        )
                      : SizedBox(),
                  GestureDetector(
                    onLongPress: () {
                      sugarInfoStore!.deleteData();
                    },
                    child: Center(
                      child: ButtonWidget(
                        enable: sugarInfoStore!.btnStatus,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        mainAxisSizeMin: true,
                        onTap: () {
                          sugarInfoStore!.saveNewRecord(id!);
                          setState(() {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.home,
                              (route) => false,
                            );
                          });
                        },
                        btnColor: AppColors.AppColor4,
                        btnText: "save_record",
                      ),
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
  StatusWidget({
    super.key,
  });

  @override
  State<StatusWidget> createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  SugarInfoStore? sugarInfoStore;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);

    super.didChangeDependencies();
  }

  Widget getLevelText(int level) {
    switch (level) {
      case 0:
        return Text(
          "${AppLocalizations.of(context)!.getTranslate('low')}",
          style: AppTheme.appBodyTextStyle
              .copyWith(color: getLevelTextColor(level)),
        );
      case 1:
        return Text(
          "${AppLocalizations.of(context)!.getTranslate('normal')}",
          style: AppTheme.appBodyTextStyle
              .copyWith(color: getLevelTextColor(level)),
        );
      case 2:
        return Text(
          "${AppLocalizations.of(context)!.getTranslate('pre_diabetes')}",
          style: AppTheme.appBodyTextStyle
              .copyWith(color: getLevelTextColor(level)),
        );
      case 3:
        return Text(
          "${AppLocalizations.of(context)!.getTranslate('diabetes')}",
          style: AppTheme.appBodyTextStyle
              .copyWith(color: getLevelTextColor(level)),
        );

      default:
        throw RangeError("");
    }
  }

  Color getLevelTextColor(int level) {
    switch (level) {
      case 0:
        return AppColors.LowStt;
      case 1:
        return AppColors.NormalStt;
      case 2:
        return AppColors.PreDiaStt;
      case 3:
        return AppColors.DiabetesStt;

      default:
        throw RangeError("");
    }
  }

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
              sugarInfoStore!.statusLevel == 0
                  ? Container(
                      child: SvgPicture.asset(
                        Assets.iconUpArrow,
                        // height: 6,
                      ),
                    )
                  : Container()
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
              sugarInfoStore!.statusLevel == 1
                  ? Container(
                      child: SvgPicture.asset(
                        Assets.iconUpArrow,
                        // height: 6,
                      ),
                    )
                  : Container()
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
              sugarInfoStore!.statusLevel == 2
                  ? Container(
                      child: SvgPicture.asset(
                        Assets.iconUpArrow,
                        // height: 6,
                      ),
                    )
                  : Container()
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
              sugarInfoStore!.statusLevel == 3
                  ? Container(
                      child: SvgPicture.asset(
                        Assets.iconUpArrow,
                        // height: 6,
                      ),
                    )
                  : Container()
            ],
          ),
        ),
        getLevelText(sugarInfoStore!.statusLevel!),
      ],
    );
  }
}

class DropDownWidget extends StatefulWidget {
  List<Conditions>? listConditions;

  DropDownWidget({super.key, required this.listConditions});

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  SugarInfoStore? sugarInfoStore;
  String? selectedTitle = 'default_txt';
  int? selectedId = 0;
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
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    super.didChangeDependencies();
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
                    "${getTitle(selectedTitle)}",
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
                        children:
                            widget.listConditions!.map((Conditions condition) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTitle = condition.name;
                                selectedId = condition.id;
                                showDropdown = false;
                                sugarInfoStore!.setChooseCondition(selectedId!);
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: DropdownMenuItem<String>(
                                value: selectedTitle,
                                child: Text(
                                  "${getTitle(condition.name)}",
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

class MyDateTimePicker extends StatefulWidget {
  @override
  _MyDateTimePickerState createState() => _MyDateTimePickerState();
}

class _MyDateTimePickerState extends State<MyDateTimePicker> {
  DateTime? selectedDateTime;

  void _showDateTimePicker() {
    DatePicker.showDatePicker(
      context,
      pickerMode: DateTimePickerMode.datetime,
      initialDateTime: selectedDateTime ?? DateTime.now(),
      onConfirm: (dateTime, List<int> selectedIndex) {
        setState(() {
          selectedDateTime = dateTime;
          print("DateTime:${dateTime}");
        });
      },
      dateFormat: 'yyyy/MM/dd HH:mm',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _showDateTimePicker,
          child: Container(
            child: Text('Chọn ngày giờ'),
          ),
        ),
        SizedBox(height: 16),
        Text(
          selectedDateTime != null
              ? 'Ngày giờ đã chọn: ${DateFormat('yyyy/MM/dd HH:mm').format(selectedDateTime!)}'
              : 'Chưa chọn ngày giờ',
        ),
      ],
    );
  }
}
