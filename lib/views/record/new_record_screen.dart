import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
import '../../widgets/sucess_dialog.dart';

class NewRecordScreen extends StatefulWidget {
  NewRecordScreen({
    super.key,
  });

  @override
  State<NewRecordScreen> createState() => _NewRecordScreenState();
}

class _NewRecordScreenState extends State<NewRecordScreen> {
  FocusNode focusNode = FocusNode();
  DateTime? selectedDateTime;
  DateTime timeNow = DateTime.now();
  SugarInfoStore? sugarInfoStore;

  bool? isFirst = true;
  String? type;
  DateTime? selectedDate;
  int? id = (DateTime.now()).millisecondsSinceEpoch;

  TextEditingController? _controller;

  void _showDatePickerDay() {
    DatePicker.showDatePicker(
      maxDateTime: DateTime.now(),
      initialDateTime: selectedDateTime ?? DateTime.now(),
      dateFormat: "yyyy/ MM/dd",
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
      maxDateTime: DateTime.now(),
      initialDateTime: sugarInfoStore!.choosedDayTimePicker ?? DateTime.now(),
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

  void showQuestionAdd() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16),
        elevation: 0,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  "${AppLocalizations.of(context)!.getTranslate('add_new_record')}",
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
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => SucessDialog());
                        Future.delayed(Duration(milliseconds:1500), () {
                          sugarInfoStore!.replaceRecord(context);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                            color: AppColors.AppColor3,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Center(
                          child: Text(
                            "${AppLocalizations.of(context)!.getTranslate('replace')}",
                            style: AppTheme.TextIntroline16Text.copyWith(
                                color: AppColors.AppColor2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 23),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        // margin: EdgeInsets.only(left: 23),
                        padding: EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                            color: AppColors.AppColor2,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Center(
                          child: Text(
                            "${AppLocalizations.of(context)!.getTranslate('keep')}",
                            style: AppTheme.TextIntroline16Text,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    print("isFirsttttttttttttttttttttt:     ${isFirst}  ");
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    sugarInfoStore!.successSaveRecord == true
        ? setState(() {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.home,
              (route) => false,
            );
          })
        : ();
    if (isFirst == true) {
      sugarInfoStore!.setchoosedDayHour(timeNow!);
      sugarInfoStore!.setchoosedDayTime(timeNow!);
      sugarInfoStore!.setStatusLevel("low");
      sugarInfoStore!.setChooseCondition(0);
      if (sugarInfoStore!.isSwapedToMol == false) {
        sugarInfoStore!.setInputSugarAmount(80);
        sugarInfoStore!.sugarAmountController.text = "80";
      } else if (sugarInfoStore!.isSwapedToMol == true) {
        sugarInfoStore!.setInputSugarAmount(4);
        sugarInfoStore!.sugarAmountController.text = "4";
      }
      ;
      setState(() {
        isFirst = false;
        print(" set isFirsttttttttttttttttttttt:     ${isFirst}  ");
      });
    }
  }

  @override
  void initState() {
    _controller = TextEditingController(text: '80');

    focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
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
        body: GestureDetector(
          onTap: () {
            // Truyền focusNode để tắt bàn phím khi người dùng nhấn ra ngoài
            FocusScope.of(context).requestFocus(FocusNode());
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
                  GestureDetector(
                    onTap: () {
                      _showDatePickerDay();
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 30),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 9),
                            decoration: BoxDecoration(
                                color: AppColors.AppColor3,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  child: Text(
                                    sugarInfoStore!.choosedDayTimeStr != null
                                        ? sugarInfoStore!.choosedDayTimeStr!
                                        : DateFormat('yyyy     MM     dd')
                                            .format(DateTime.now()),
                                    style: AppTheme.appBodyTextStyle.copyWith(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 9),
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
                                          : DateFormat('HH:mm')
                                              .format(DateTime.now()),
                                      style: AppTheme.appBodyTextStyle.copyWith(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
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
                                  Observer(builder: (_) {
                                    return Expanded(child: StatusWidget());
                                  }),
                                  // Text("${sugarInfoStore!.chooseCondition!.sugarAmount.}")
                                  Container(
                                    child: Row(children: [
                                      SvgPicture.asset(Assets.iconEditPen),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      // SvgPicture.asset(Assets.iconSwapUnit)
                                    ]),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              // margin: EdgeInsets.only(bottom: 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 165,
                                          child: TextField(
                                            cursorColor: AppColors.AppColor2,
                                            decoration: InputDecoration(
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
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(
                                                      r'^\d{0,3}\.?\d{0,2}')),
                                            ],
                                            controller: sugarInfoStore!
                                                .sugarAmountController,
                                            focusNode: focusNode,
                                            onEditingComplete: () {
                                              print(
                                                  "1111111111111111 onEditing 1111111111111111");
                                              sugarInfoStore!
                                                  .validateSugarAmount();
                                            },
                                            onChanged: (value) {
                                              print(
                                                  "1111111111111111 onChange 1111111111111111");
                                              sugarInfoStore!
                                                  .setInputSugarAmount(
                                                      double.parse(value));
                                              sugarInfoStore!
                                                  .checkValidateNewRecord();
                                              print("onchange: ${value}");
                                            },
                                            textAlign: TextAlign.center,
                                            onSubmitted: (value) {
                                              print(
                                                  "1111111111111111 submit 1111111111111111");
                                              sugarInfoStore!
                                                  .setInputSugarAmount(
                                                      double.tryParse(value)!);
                                              sugarInfoStore!
                                                  .checkValidateNewRecord();
                                              print(value);
                                              FocusScope.of(context).unfocus();
                                              // Navigator.of(context).pop();
                                            },
                                            keyboardType: TextInputType.number,
                                            style: AppTheme.sugarInputText,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 25,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showDiaLogUnit(context);
                                          },
                                          child: Text(
                                            "${sugarInfoStore!.isSwapedToMol == true ? AppLocalizations.of(context)!.getTranslate('mmol/L') : AppLocalizations.of(context)!.getTranslate('mg/dL')}",
                                            style: AppTheme.appBodyTextStyle
                                                .copyWith(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Center(
                        child: Observer(builder: (_) {
                          return Text(
                            "${sugarInfoStore!.errorText}",
                            style: AppTheme.errorText,
                          );
                        }),
                      ),
                      Center(
                        child: ButtonWidget(
                          enable: sugarInfoStore!.errorText == null ||
                                  sugarInfoStore!.errorText == ""
                              ? true
                              : false,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          mainAxisSizeMin: true,
                          onTap: () {
                            sugarInfoStore!.checkValidateNewRecord();
                            Future.delayed(Duration(milliseconds: 200), () {
                              if (sugarInfoStore!.errorText == null ||
                                  sugarInfoStore!.errorText == "") {
                                sugarInfoStore!.checkDuplicate();
                                Future.delayed(Duration(milliseconds: 300), () {
                                  if (sugarInfoStore!.hasExistedRecord ==
                                      true) {
                                    showQuestionAdd();
                                  } else {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            SucessDialog());
                                    Future.delayed(Duration(seconds: 1), () {
                                      sugarInfoStore!
                                          .saveNewRecord(id!, context);
                                    });
                                  }
                                });
                              }
                            });
                          },
                          btnColor: AppColors.AppColor4,
                          btnText: "save_record",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          sugarInfoStore!.deleteData();
                        },
                        child: Center(
                            child: Container(
                          width: 20,
                          height: 20,
                          color: Colors.white,
                        )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<String?> showDiaLogUnit(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      content: StatefulBuilder(builder: (context, setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.17,
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppLocalizations.of(context)!.getTranslate('change_unit')}',
                style: AppTheme.hintText.copyWith(
                    color: AppColors.AppColor4, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: AppColors.AppColor3,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          '${AppLocalizations.of(context)!.getTranslate('mg/dL')}',
                          style: AppTheme.unitText,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.AppColor3),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          '${AppLocalizations.of(context)!.getTranslate('mmol/L')}',
                          style: AppTheme.unitText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                height: 35,
                margin: const EdgeInsets.only(left: 50, right: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.AppColor2,
                ),
                child: Center(
                  child: Text(
                    '${AppLocalizations.of(context)!.getTranslate('choose_this_unit')}',
                    style: AppTheme.TextIntroline16Text,
                  ),
                ),
              )
            ],
          ),
        );
      }),
    ),
  );
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
    if (sugarInfoStore!.chooseCondition!.sugarAmount!
            .elementAt(level!)
            .maxValue ==
        630) {
      print(
          "abcd abcd abcd${sugarInfoStore!.chooseCondition!.sugarAmount!.elementAt(level!).minValue!.toString()}");
      return ">= ${cutString(sugarInfoStore!.chooseCondition!.sugarAmount!.elementAt(level!).minValue!)}";
    } else {
      print(
          "abcd abcd abcd${sugarInfoStore!.chooseCondition!.sugarAmount!.elementAt(level!).minValue!.toString()} ${cutString(sugarInfoStore!.chooseCondition!.sugarAmount!.elementAt(level!).maxValue!)}");
      return "${cutString(sugarInfoStore!.chooseCondition!.sugarAmount!.elementAt(level!).minValue!)} ~ ${cutString(sugarInfoStore!.chooseCondition!.sugarAmount!.elementAt(level!).maxValue!)}";
    }
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
          );
        }),
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
          );
        }),
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
          );
        }),
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
          );
        }),
        Observer(builder: (_) {
          return Container(child: getLevelText(sugarInfoStore!.statusLevel!));
        }),
        Expanded(
          child: Center(
            child: Observer(builder: (_) {
              return Text(
                "${getAmountValue(sugarInfoStore!.statusLevel)}",
                style: AppTheme.appBodyTextStyle.copyWith(color: Colors.black),
              );
            }),
          ),
        )
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                      fontWeight: FontWeight.w700, color: Colors.black,fontSize: 16),
                ),
                const SizedBox(
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
                              sugarInfoStore!.setChooseCondition(selectedId!);
                              // Future.delayed(const Duration(milliseconds: 200),
                              //     () {
                              //   sugarInfoStore!.setInputSugarAmount(
                              //       sugarInfoStore!.currentSugarAmount!);
                              // });
                            });
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: DropdownMenuItem<String>(
                              value: selectedTitle,
                              child: Text(
                                "${getTitle(condition.name)}",
                                style: AppTheme.appBodyTextStyle
                                    .copyWith(color: Colors.white,fontSize: 16),
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

class _DecimalLimitInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.contains('.') &&
        newValue.text.substring(newValue.text.indexOf('.') + 1).length > 1) {
      // Nếu có dấu chấm và có hơn 1 ký tự sau dấu chấm, hạn chế lại chỉ 1 ký tự
      return TextEditingValue(
        text: oldValue.text,
        selection: oldValue.selection,
      );
    }
    return newValue;
  }
}
