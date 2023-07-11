import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
import '../../widgets/sucess_dialog.dart';

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
  String? errorText = "";
  bool? canTap = true;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    isFirst = true;
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
      if (isFirst == true) {
        recordId = arguments['record_id'];
        sugarInfoStore!.setEditingRecord(recordId);
        if (sugarInfoStore != null &&
            sugarInfoStore!.editingRecord != null &&
            editRecordStore != null) {
          editRecordStore!.isSwapedToMol = sugarInfoStore!.isSwapedToMol;
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
          _controller.text = '${editRecordStore!.editingSugarAmount}';
          editRecordStore!.sugarAmountEditControllerEdit.text =
              '${editRecordStore!.editingSugarAmount}';
        }
        setState(() {
          isFirst = false;
          print(" set isFirsttttttttttttttttttttt:     ${isFirst}  ");
        });
      }
    }
  }

  void _showDatePickerDay() {
    DatePicker.showDatePicker(
      maxDateTime: DateTime.now(),
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
      maxDateTime: DateTime.now(),
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

  void setErrorText(String text) {
    setState(() {
      errorText = text;
    });
  }

  addZeroToDecimal() {
    String? value = editRecordStore!.sugarAmountEditControllerEdit.text;
    List<String> parts = value.split(".");
    if (value.split('.')[1].length < 1) {
      // Không có phần thập phân, thêm số 0 vào cuối chuỗi
      editRecordStore!.sugarAmountEditControllerEdit.text = value + "0";
    } else {
      // Chuỗi đã có phần thập phân
      editRecordStore!.sugarAmountEditControllerEdit.text = value;
    }
    print("1111111111111111 addZero");
  }

  @override
  Widget build(BuildContext context) {
    editRecordStore!.errorText != null && editRecordStore!.errorText != ""
        ? setErrorText(editRecordStore!.errorText!)
        : setErrorText("");
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
                      _showDiaLogDelete(context);
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
          ? GestureDetector(
              onTap: () {
                // Truyền focusNode để tắt bàn phím khi người dùng nhấn ra ngoài
                FocusScope.of(context).requestFocus(FocusNode());
                addZeroToDecimal();
              },
              child: Container(
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
                                      margin: const EdgeInsets.only(right: 30),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 9),
                                      decoration: const BoxDecoration(
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
                                                  .copyWith(
                                                      color: Colors.black),
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
                                          horizontal: 25, vertical: 9),
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
                                                  .copyWith(
                                                      color: Colors.black),
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
                            margin: const EdgeInsets.symmetric(vertical: 8),
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
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "${AppLocalizations.of(context)!.getTranslate('sugar_amount')}",
                              style: AppTheme.Headline16Text.copyWith(
                                  color: AppColors.AppColor4),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.AppColor3,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: AppColors.mainBgColor),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: Observer(builder: (_) {
                                        return StatusWidget(
                                          editRecordStore: editRecordStore,
                                        );
                                      })),
                                      Container(
                                        child: SvgPicture.asset(
                                            Assets.iconEditPen),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: 165,
                                              child: TextField(
                                                cursorColor:
                                                    AppColors.AppColor2,
                                                decoration:
                                                    const InputDecoration(
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: AppColors
                                                                  .AppColor2)),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: AppColors
                                                            .AppColor2), //<-- SEE HERE
                                                  ),
                                                ),
                                                inputFormatters: [
                                                  // Allow Decimal Number With Precision of 2 Only
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(
                                                          r'^\d{0,3}\.?\d{0,2}')),
                                                ],
                                                controller: editRecordStore!
                                                    .sugarAmountEditControllerEdit,
                                                focusNode: focusNode,
                                                onEditingComplete: () {
                                                  print(
                                                      "1111111111111111 onEditing 1111111111111111");
                                                },
                                                onChanged: (value) {
                                                  print(
                                                      "1111111111111111 change $value 111111111111111111");
                                                  editRecordStore!
                                                      .setEditInputSugarAmount(
                                                          double.parse(value));
                                                  editRecordStore!
                                                      .checkValidateEditRecord(
                                                          double.parse(value));
                                                },
                                                textAlign: TextAlign.center,
                                                onSubmitted: (value) {
                                                  print(
                                                      "1111111111111111 submit 111111111111111111");
                                                  editRecordStore!
                                                      .setEditInputSugarAmount(
                                                          double.tryParse(
                                                              value)!);
                                                  editRecordStore!
                                                      .checkValidateEditRecord(
                                                          double.tryParse(
                                                              value)!);
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  print("onsubmit: ${value}");
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
                                              "${sugarInfoStore!.isSwapedToMol == true ? AppLocalizations.of(context)!.getTranslate('mmol/L') : AppLocalizations.of(context)!.getTranslate('mg/dL')}",
                                              style: AppTheme.appBodyTextStyle
                                                  .copyWith(
                                                      color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      // Container(
                                      //     child: SvgPicture.asset(
                                      //         Assets.iconSwapUnit))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Observer(builder: (_) {
                            return Center(
                              child: Text(
                                "${errorText}",
                                style: AppTheme.errorText,
                              ),
                            );
                          }),
                          Center(
                            child: ButtonWidget(
                              enable: editRecordStore!.errorText == null ||
                                      editRecordStore!.errorText == ""
                                  ? true
                                  : false,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              mainAxisSizeMin: true,
                              onTap: () {
                                editRecordStore!.checkValidateEditRecord(0);
                                if (editRecordStore!.errorText == null ||
                                    editRecordStore!.errorText == "") {
                                  sugarInfoStore!.checkDuplicateInEdit(
                                      SugarRecord(
                                          conditionName: editRecordStore!
                                              .editChooseCondition!.name,
                                          conditionId: editRecordStore!
                                              .editChooseCondition!.id,
                                          dayTime: editRecordStore!
                                              .editingDayTimeStr!,
                                          hourTime: editRecordStore!
                                              .editingHourTimeStr!,
                                          id: recordId,
                                          status: editRecordStore!
                                              .currentEditStatus,
                                          sugarAmount: editRecordStore!
                                              .editingSugarAmount),
                                      context,
                                      recordId!);
                                } else {
                                  setState(() {
                                    errorText = sugarInfoStore!.errorText;
                                  });
                                }
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
              ),
            )
          : Container(),
    );
  }

  _showDiaLogDelete(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 8),
              elevation: 0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 42),
                      child: Text(
                        "${AppLocalizations.of(context)!.getTranslate('delete_record_alert')}",
                        style: AppTheme.Headline16Text.copyWith(
                            fontWeight: FontWeight.w500, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 9),
                              decoration: const BoxDecoration(
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

  _showDiaLogChange(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 8),
              elevation: 0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 42),
                      child: Text(
                        "${AppLocalizations.of(context)!.getTranslate('save_edit_dialog_content')}",
                        style: AppTheme.Headline16Text.copyWith(
                            fontWeight: FontWeight.w500, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 9),
                              decoration: const BoxDecoration(
                                  color: AppColors.AppColor3,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Center(
                                child: Text(
                                  "${AppLocalizations.of(context)!.getTranslate('keep')}",
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
                              if (canTap == true) {
                                canTap = false;
                                editRecordStore!.checkValidateEditRecord(0);
                                if (editRecordStore!.errorText == null ||
                                    editRecordStore!.errorText == "") {
                                  Future.delayed(Duration(milliseconds: 0), () {
                                    sugarInfoStore!.checkDuplicateInEdit(
                                        SugarRecord(
                                            conditionName: editRecordStore!
                                                .editChooseCondition!.name,
                                            conditionId: editRecordStore!
                                                .editChooseCondition!.id,
                                            dayTime: editRecordStore!
                                                .editingDayTimeStr!,
                                            hourTime: editRecordStore!
                                                .editingHourTimeStr!,
                                            id: recordId,
                                            status: editRecordStore!
                                                .currentEditStatus,
                                            sugarAmount: editRecordStore!
                                                .editingSugarAmount),
                                        context,
                                        recordId!);

                                    canTap = true;
                                  });
                                }
                              }
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
                                    "${AppLocalizations.of(context)!.getTranslate('change_btn')}",
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

  String getLevelText(int level) {
    switch (level) {
      case 0:
        return "${AppLocalizations.of(context)!.getTranslate('low')}";
      case 1:
        return "${AppLocalizations.of(context)!.getTranslate('normal')}";
      case 2:
        return "${AppLocalizations.of(context)!.getTranslate('pre_diabetes')}";
      case 3:
        return "${AppLocalizations.of(context)!.getTranslate('diabetes')}";

      default:
        throw RangeError("");
    }
  }

  String cutString(double number) {
    if (number.toString().length > 6) {
      String numberString = number.toString();
      String before = numberString.split('.').first;
      String after = numberString.split('.').last.substring(0, 2);
      return "${before}.${after}";
    } else {
      return "${number.toString()}";
    }
  }

  String? getAmountValue(int? level) {
    if (widget.editRecordStore!.editChooseCondition!.sugarAmount!
            .elementAt(level!)
            .maxValue ==
        630) {
      print(
          "abcd abcd abcd${widget.editRecordStore!.editChooseCondition!.sugarAmount!.elementAt(level!).minValue!.toString()}");
      return ">= ${cutString(widget.editRecordStore!.editChooseCondition!.sugarAmount!.elementAt(level!).minValue!)}";
    } else {
      print(
          "abcd abcd abcd${widget.editRecordStore!.editChooseCondition!.sugarAmount!.elementAt(level!).minValue!.toString()} ${cutString(widget.editRecordStore!.editChooseCondition!.sugarAmount!.elementAt(level!).maxValue!)}");
      return "${cutString(widget.editRecordStore!.editChooseCondition!.sugarAmount!.elementAt(level!).minValue!)} ~ ${cutString(widget.editRecordStore!.editChooseCondition!.sugarAmount!.elementAt(level!).maxValue!)}";
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
          child: Observer(builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Observer(builder: (_) {
                  return Container(
                    height: 20,
                    width: 28,
                    decoration: BoxDecoration(
                      color: AppColors.LowStt,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }),
                widget.editRecordStore!.editStatusLevel == 0
                    ? Container(
                        child: SvgPicture.asset(
                          Assets.iconUpArrow,
                          // height: 6,
                        ),
                      )
                    : Container()
              ],
            );
          }),
        ),
        Observer(builder: (_) {
          return Container(
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
          );
        }),
        Observer(builder: (_) {
          return Container(
            margin: const EdgeInsets.only(right: 4),
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
          );
        }),
        Observer(builder: (_) {
          return Container(
            margin: const EdgeInsets.only(right: 4),
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
          );
        }),
        Observer(builder: (_) {
          return Text(getLevelText(widget.editRecordStore!.editStatusLevel!),
              style: AppTheme.appBodyTextStyle.copyWith(
                  color: getLevelTextColor(
                      widget.editRecordStore!.editStatusLevel!)));
        }),
        Expanded(
          child: Observer(builder: (_) {
            return Observer(builder: (_) {
              return Center(
                child: widget.editRecordStore!.editStatusLevel == 1
                    ? Text(
                        "${getAmountValue(widget.editRecordStore!.editStatusLevel!)}",
                        style: AppTheme.appBodyTextStyle
                            .copyWith(color: Colors.black),
                      )
                    : Text(
                        "${getAmountValue(widget.editRecordStore!.editStatusLevel!)}",
                        style: AppTheme.appBodyTextStyle
                            .copyWith(color: Colors.black),
                      ),
              );
            });
          }),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              showDropdown = !showDropdown;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: const BoxDecoration(
                color: AppColors.AppColor3,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${getTitle(selectedTitle)}",
                  style: AppTheme.appBodyTextStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 16),
                ),
                const SizedBox(
                  width: 100,
                ),
                showDropdown
                    ? SvgPicture.asset(Assets.iconDropdownDownArrow,
                        color: AppColors.AppColor2)
                    : SvgPicture.asset(Assets.iconDropdownUpArrow,
                        color: AppColors.AppColor2),
              ],
            ),
          ),
        ),
        if (showDropdown)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              widget.editRecordStore!.setEditInputSugarAmount(
                                  widget!.editRecordStore!.editingSugarAmount!);
                            });
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: DropdownMenuItem<String>(
                              value: selectedTitle,
                              child: Text(
                                "${getTitle(condition.name)}",
                                style: AppTheme.appBodyTextStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
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
      dateFormat: 'yyyy MM dd HH mm',
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
        const SizedBox(height: 16),
        Text(
          selectedDateTime != null
              ? 'Ngày giờ đã chọn: ${DateFormat('yyyy/MM/dd HH:mm').format(selectedDateTime!)}'
              : 'Chưa chọn ngày giờ',
        ),
      ],
    );
  }
}
