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
import '../../controllers/stores/edit_record_store.dart';
import '../../controllers/stores/sugar_info_store.dart';
import '../../models/sugar_info/sugar_info.dart';
import '../../routes.dart';
import '../../utils/locale/appLocalizations.dart';
import '../../widgets/button_widget.dart';

class EditRecordScreen extends StatefulWidget {
  EditRecordScreen({
    super.key,
  });

  @override
  State<EditRecordScreen> createState() => _EditRecordScreenState();
}

class _EditRecordScreenState extends State<EditRecordScreen> {
  FocusNode focusNode = FocusNode();
  EditRecordStore? editRecordStore;
  DateTime selectedDateTime = DateTime.now();
  DateTime timeNow = DateTime.now();
  SugarInfoStore? sugarInfoStore;
  SugarRecord? editingRecord;
  bool? isFirst = true;
  String? type;
  DateTime? selectedDay;
  DateTime? selectedHour;
  int? recordId;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (editRecordStore == null) {
      editRecordStore = EditRecordStore();
    }
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    if (arguments != null) {
      if (isFirst = true) {
        recordId = arguments['record_id'];
        sugarInfoStore!.setEditingRecord(recordId);
        if (sugarInfoStore != null &&
            sugarInfoStore!.editingRecord != null &&
            editRecordStore != null) {
          editRecordStore!
              .getRootSugarInfo(sugarInfoStore!.listRootConditions!);
          editRecordStore!.recordId = sugarInfoStore!.editingRecord!.id;
          editRecordStore!.conditionId =
              sugarInfoStore!.editingRecord!.conditionId;
          editRecordStore!.editingDayTime = DateFormat('yyyy/MM/dd')
              .parse(sugarInfoStore!.editingRecord!.dayTime!);
          editRecordStore!.editingHourTime = DateFormat('HH:mm')
              .parse(sugarInfoStore!.editingRecord!.hourTime!);
          editRecordStore!.editingSugarAmount =
              sugarInfoStore!.editingRecord!.sugarAmount;
          editRecordStore!.setEditedDayTime(editRecordStore!.editingDayTime!);
          editRecordStore!.setEditedHourTime(editRecordStore!.editingHourTime!);
          editRecordStore!
              .setEditChooseCondition(editRecordStore!.conditionId!);
          editRecordStore!
              .setEditInputSugarAmount(editRecordStore!.editingSugarAmount!);
          controller.text = '${editRecordStore!.editingSugarAmount}';
        }
        setState(() {
          isFirst = false;
        });
      }
    }
  }

  void _showDatePickerDay() {
    DatePicker.showDatePicker(
      initialDateTime: editRecordStore!.editingDayTime!,
      dateFormat: "yyyy/MM/dd",
      context,
      onConfirm: (DateTime day, List<int> index) {
        setState(() {
          selectedDay = day;
          print("Date: ${selectedDay}");
          // sugarInfoStore!.setchoosedDayTime(day);
          editRecordStore!.setEditedDayTime(day);
        });
      },
      locale: DateTimePickerLocale.en_us,
    );
  }

  void _showDatePickerHour() {
    DatePicker.showDatePicker(
      initialDateTime: editRecordStore!.editingHourTime!,
      dateFormat: "HH:mm",
      context,
      onConfirm: (DateTime hour, List<int> index) {
        setState(() {
          selectedHour = hour;
          print("Date: ${selectedHour}");
          // sugarInfoStore!.setchoosedDayHour(hour);
          editRecordStore!.setEditedHourTime(hour);
        });
      },
      locale: DateTimePickerLocale.en_us,
    );
  }

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
                      print(sugarInfoStore!
                          .rootSugarInfo!.conditions!.first.name);
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
                      "${AppLocalizations.of(context)!.getTranslate('edit_record')}",
                      style: AppTheme.Headline20Text,
                      overflow: TextOverflow
                          .ellipsis, // Hiển thị dấu chấm ba khi có tràn
                      maxLines: 2,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showDiaLog(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.mainBgColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: SvgPicture.asset(Assets.iconDelete),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      body: editRecordStore != null
          ? Container(
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
                          sugarInfoStore!.editingRecord!.dayTime != null
                              ? GestureDetector(
                                  onTap: () {
                                    _showDatePickerDay();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 30),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 9),
                                    decoration: BoxDecoration(
                                        color: AppColors.AppColor3,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          child: Text(
                                            "${DateFormat('yyyy/MM/dd').format(editRecordStore!.editingDayTime!)}",
                                            style: AppTheme.appBodyTextStyle
                                                .copyWith(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          sugarInfoStore!.editingRecord!.hourTime != null
                              ? GestureDetector(
                                  onTap: () {
                                    _showDatePickerHour();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 9),
                                    decoration: BoxDecoration(
                                        color: AppColors.AppColor3,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          child: Text(
                                            "${DateFormat('HH:mm').format(editRecordStore!.editingHourTime!)}",
                                            style: AppTheme.appBodyTextStyle
                                                .copyWith(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
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
                        sugarInfoStore!.listRootConditions != null
                            ? DropDownWidget(
                                editRecordStore: editRecordStore,
                                listConditions:
                                    sugarInfoStore!.listRootConditions,
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
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    color: AppColors.mainBgColor),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: StatusWidget(
                                      editRecordStore: editRecordStore,
                                    )),
                                    Container(
                                      child:
                                          SvgPicture.asset(Assets.iconEditPen),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 165,
                                            child: TextField(
                                              controller: controller,
                                              focusNode: focusNode,
                                              onChanged: (value) {
                                                editRecordStore!
                                                    .setEditInputSugarAmount(
                                                        int.parse(value) * 1.0);

                                                sugarInfoStore!
                                                    .checkValidateSugarAmountInput(
                                                        int.parse(value) * 1.0);
                                                print(value);
                                              },
                                              textAlign: TextAlign.center,
                                              onSubmitted: (value) {
                                                editRecordStore!
                                                    .setEditInputSugarAmount(
                                                        int.parse(value) * 1.0);
                                                sugarInfoStore!
                                                    .checkValidateSugarAmountInput(
                                                        int.parse(value) * 1.0);
                                                print(value);
                                              },
                                              keyboardType:
                                                  TextInputType.number,
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
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                        child: SvgPicture.asset(
                                            Assets.iconSwapUnit))
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
                        Center(
                          child: ButtonWidget(
                            // enable: sugarInfoStore!.btnStatus,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            mainAxisSizeMin: true,
                            onTap: () {
                              sugarInfoStore!.editRecord(
                                  recordId!,
                                  SugarRecord(
                                      conditionId: editRecordStore!.conditionId,
                                      dayTime:
                                          editRecordStore!.editingDayTimeStr!,
                                      hourTime:
                                          editRecordStore!.editingHourTimeStr!,
                                      id: recordId,
                                      status:
                                          editRecordStore!.currentEditStatus,
                                      sugarAmount:
                                          editRecordStore!.editingSugarAmount));
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.home,
                                (route) => false,
                              );
                            },
                            btnColor: AppColors.AppColor4,
                            btnText: "save_record",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }

  _showDiaLog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 8),
              elevation: 0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 42),
                      child: Text(
                        "${AppLocalizations.of(context)!.getTranslate('delete_record_alert')}",
                        style: AppTheme.Headline16Text.copyWith(
                            fontWeight: FontWeight.w500, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              sugarInfoStore!.deleteRecord(recordId);
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.home,
                                (route) => false,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 9),
                              decoration: BoxDecoration(
                                  color: AppColors.AppColor3,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Center(
                                child: Text(
                                  "${AppLocalizations.of(context)!.getTranslate('delete')}",
                                  style: AppTheme.appBodyTextStyle.copyWith(
                                      fontSize: 14, color: AppColors.AppColor2),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 9),
                              // width: 144,
                              // height: 36,
                              decoration: BoxDecoration(
                                  color: AppColors.AppColor2,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Center(
                                child: Text(
                                    "${AppLocalizations.of(context)!.getTranslate('keep')}",
                                    style: AppTheme.appBodyTextStyle.copyWith(
                                        fontSize: 14,
                                        color: AppColors.mainBgColor)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }
}

class StatusWidget extends StatefulWidget {
  EditRecordStore? editRecordStore;
  StatusWidget({super.key, this.editRecordStore});

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

  String? getAmountValue(int? level) {
    return "${widget.editRecordStore!.editChooseCondition!.sugarAmount!.elementAt(level!).minValue} ~ ${widget.editRecordStore!.editChooseCondition!.sugarAmount!.elementAt(level!).maxValue}";
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
              widget.editRecordStore!.editStatusLevel == 0
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
              widget.editRecordStore!.editStatusLevel == 1
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
              widget.editRecordStore!.editStatusLevel == 2
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
              widget.editRecordStore!.editStatusLevel == 3
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
        getLevelText(widget.editRecordStore!.editStatusLevel!),
        Expanded(
          child: Center(
            child: Text(
              "${getAmountValue(widget.editRecordStore!.editStatusLevel!)}",
              style: AppTheme.appBodyTextStyle.copyWith(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }
}

class DropDownWidget extends StatefulWidget {
  List<Conditions>? listConditions;
  EditRecordStore? editRecordStore;

  DropDownWidget(
      {super.key, required this.listConditions, this.editRecordStore});

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
    setState(() {
      selectedTitle = sugarInfoStore!.rootSugarInfo!.conditions!
          .where((e) => e.id == widget.editRecordStore!.conditionId)
          .first
          .name;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${getTitle(selectedTitle)}",
                  style: AppTheme.appBodyTextStyle.copyWith(
                      fontWeight: FontWeight.w700, color: Colors.black),
                ),
                SizedBox(
                  width: 100,
                ),
                showDropdown
                    ? SvgPicture.asset(Assets.iconUpArrow)
                    : SvgPicture.asset(Assets.iconDownArrow),
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
                              widget.editRecordStore!
                                  .setEditChooseCondition(selectedId!);
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
