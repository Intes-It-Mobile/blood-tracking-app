import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../models/sugar_info/sugar_info.dart';
import '../../routes.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../utils/locale/appLocalizations.dart';
import '../../widgets/sucess_dialog.dart';
part 'sugar_info_store.g.dart';

class SugarInfoStore = _SugarInfoStoreBase with _$SugarInfoStore;

abstract class _SugarInfoStoreBase with Store {
  @observable
  int abc = 0;

  @observable
  SugarInfo? rootSugarInfo;

  @observable
  String? currentStatus;

  @observable
  Conditions? chooseCondition;

  @observable
  double? currentSugarAmount = 0.0;

  @observable
  int? statusLevel = 0;

  List<Conditions>? listRootConditions;

  @observable
  List<Conditions>? listRootConditionsFilter;

  get sugarInfoStore => null;

  @action
  getRootSugarInfo(SugarInfo? fromSharepref) {
    rootSugarInfo = fromSharepref;
    if (isSwapedToMol == false) {
      listRootConditions = fromSharepref!.conditions;
      setValueToListFilter(listRootConditions);
    }
    if (isSwapedToMol == true) {
      listRootConditions = fromSharepref!.conditions;
      for (var condition in listRootConditions!) {
        if (condition.sugarAmount != null) {
          for (var sugarAmount in condition.sugarAmount!) {
            if (sugarAmount.minValue != null) {
              sugarAmount.minValue = sugarAmount.minValue! / 18;
            }
            if (sugarAmount.maxValue != null) {
              sugarAmount.maxValue = sugarAmount.maxValue! / 18;
            }
          }
        }
      }
      setValueToListFilter(listRootConditions);
    }
  }

  @action
  setValueToListFilter(List<Conditions>? list) {
    listRootConditionsFilter = list;
  }

  @action
  setChooseCondition(int chooseId) {
    chooseCondition =
        listRootConditions!.where((e) => e.id == chooseId).toList().first;
    if (chooseCondition != null) {
      print(chooseCondition!.name);
    }
  }

  @action
  setInputSugarAmount(double inputAmount) {
    // currentStatus = chooseCondition!.sugarAmount!
    //     .where((e) =>
    //         e.minValue! * 1.0 <= inputAmount && inputAmount < e.maxValue! * 1.0)
    //     .first
    // .status;
    setCurrentAmount(inputAmount);
    setCurrentStatus(inputAmount);
    if (currentStatus != null) {
      setStatusLevel(currentStatus);
    }
  }

  @action
  setCurrentAmount(double inputAmount) {
    currentSugarAmount = inputAmount;
  }

  @action
  setCurrentStatus(double inputAmount) {
    //  Lớn hơn >= min, nhỏ hơn max
    if (isSwapedToMol == false) {
      if (inputAmount != null && inputAmount >= 18 || inputAmount <= 630) {
        currentStatus = chooseCondition!.sugarAmount!
            .where((e) =>
                e.minValue! * 1.0 <= inputAmount &&
                inputAmount < e.maxValue! * 1.0)
            .first
            .status;
      }
      print("Status: ${currentStatus}");
    } else if (isSwapedToMol == true) {
      if (inputAmount != null && inputAmount >= 1 || inputAmount <= 35) {
        currentStatus = chooseCondition!.sugarAmount!
            .where((e) =>
                e.minValue! * 1.0 <= inputAmount &&
                inputAmount < e.maxValue! * 1.0)
            .first
            .status;
      }
      print("Status: ${currentStatus}");
    }
  }

  @action
  setStatusLevel(String? currentStatus) {
    switch (currentStatus) {
      case 'low':
        return statusLevel = 0;
      case 'normal':
        return statusLevel = 1;
      case 'pre_diabetes':
        return statusLevel = 2;
      case 'diabetes':
        return statusLevel = 3;
      default:
        throw RangeError("");
    }
  }

  @observable
  bool? legalInput = false;

  @action
  checkValidateSugarAmountInput(double value) {
    if (value >= 18 && value <= 630) {
      legalInput = true;
    } else {
      legalInput = false;
    }
    print("legalInput: ${legalInput}");
  }

  @observable
  String? choosedDayTimeStr = DateFormat('yyyy/MM/dd').format(DateTime.now());

  @observable
  String? choosedDayHourStr = DateFormat('HH:mm').format(DateTime.now());
  @observable
  String? choosedDayTimeStrDisplay =
      DateFormat('yyyy/MM/dd').format(DateTime.now());

  @observable
  String? choosedDayHourStrDisplay = DateFormat('HH:mm').format(DateTime.now());

  @observable
  bool? isChoosedDayHourStrDisplay = false;

  @observable
  bool? isChoosedDayTimeStrDisplay = false;

  @observable
  DateTime? choosedDayTimePicker;

  @action
  setchoosedDayTime(DateTime choosedDayTime) {
    choosedDayTimePicker = choosedDayTime;
    (choosedDayTimeStrDisplay =
        DateFormat('yyyy     MM     dd').format(choosedDayTime));
    choosedDayTimeStr = DateFormat('yyyy/MM/dd').format(choosedDayTime);
    print(choosedDayTimeStr);
  }

  @action
  setchoosedDayHour(DateTime choosedDayHour) {
    choosedDayHourStrDisplay = DateFormat('HH : mm').format(choosedDayHour);
    choosedDayHourStr = DateFormat('HH:mm').format(choosedDayHour);
    print(choosedDayHourStr);
  }

  @observable
  DateTime dateTimeNow = DateTime.now();

  @observable
  String stringTimeDayNow =
      DateFormat('yyyy     MM     dd').format(DateTime.now());
  @observable
  String stringTimeHourNow = DateFormat('HH   :   mm').format(DateTime.now());

  @observable
  List<SugarRecord>? listRecord = [];

  @observable
  List<SugarRecord>? listRecordArrangedByTime = [];

  @observable
  ListRecord? listRecords;

  DateTime now = DateTime.now();

  @observable
  bool? isListRecordsLoading = true;

  @observable
  bool? isSaving = false;

  static final String ListRecordsKey = 'listRecord';

  @observable
  bool? hasExistedRecord = false;
  @observable
  bool? hasExistedEditRecord = false;

  @action
  checkDuplicate() {
    hasExistedRecord = listRecord!.any((record) =>
        record.dayTime == choosedDayTimeStr &&
        record.hourTime == choosedDayHourStr);
    print(hasExistedRecord);
  }

  @action
  checkDuplicateInEdit(
      SugarRecord sugarRecordEdit, BuildContext context, int id) {
    hasExistedEditRecord = listRecord!.any((record) =>
        record.dayTime == sugarRecordEdit.dayTime &&
        record.hourTime == sugarRecordEdit.hourTime &&
        record.id != sugarRecordEdit.id);
    if (hasExistedEditRecord == true) {
      showDiaLogChange(context, sugarRecordEdit);
    } else if (hasExistedEditRecord == false) {
      editRecord(id, sugarRecordEdit, context);
    }
    print(hasExistedEditRecord);
  }

  @action
  replaceEditRecord(BuildContext context, SugarRecord sugarRecordEdit) {
    SugarRecord recordUpdate = listRecord!.firstWhere((record) =>
        record.dayTime == sugarRecordEdit.dayTime &&
        record.hourTime == sugarRecordEdit.hourTime);
    {
      recordUpdate.conditionId = sugarRecordEdit!.conditionId;
      recordUpdate.dayTime = sugarRecordEdit.dayTime;
      recordUpdate.hourTime = sugarRecordEdit.hourTime;
      recordUpdate.status = sugarRecordEdit.status;
      recordUpdate.sugarAmount = sugarRecordEdit.sugarAmount;
      recordUpdate.conditionName = sugarRecordEdit.conditionName;
    }

    saveListRecord(listRecords);
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.home,
      (route) => false,
    );
  }

  @action
  replaceRecord(BuildContext context) {
    SugarRecord recordUpdate = listRecord!.firstWhere((record) =>
        record.dayTime == choosedDayTimeStr &&
        record.hourTime == choosedDayHourStr);
    {
      recordUpdate.conditionId = chooseCondition!.id;
      recordUpdate.dayTime = choosedDayTimeStr;
      recordUpdate.hourTime = choosedDayHourStr;
      recordUpdate.status = currentStatus;
      recordUpdate.sugarAmount = currentSugarAmount;
    }

    saveListRecord(listRecords);
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.home,
      (route) => false,
    );
  }

  @observable
  bool? userAgreeAddNew = false;
  @action
  setAgreeAddNew(bool? value) {
    userAgreeAddNew = true;
  }

  @observable
  bool? userAgreeReplace = false;
  @action
  setAgreeReplace(bool? value) {
    userAgreeReplace = true;
  }

  @action
  Future<void> saveNewRecord(int id, BuildContext context) async {
    listRecord!.add(SugarRecord(
        id: id,
        dayTime: choosedDayTimeStr,
        hourTime: choosedDayHourStr,
        status: currentStatus,
        sugarAmount: currentSugarAmount,
        conditionId: chooseCondition!.id,
        conditionName: chooseCondition!.name));
    listRecords = ListRecord(listRecord: listRecord);
    choosedDayTimeStr = null;
    choosedDayHourStr = null;
    listRecordArrangedByTime = listRecord;
    setErrorText("");
    saveListRecord(listRecords);

    if (listRecordArrangedByTime!.length > 0) {
      listRecordArrangedByTime!.sort((b, a) => (DateFormat('yyyy/MM/dd HH:mm')
              .parse("${a!.dayTime!} ${a!.hourTime!}"))
          .compareTo(DateFormat('yyyy/MM/dd HH:mm')
              .parse("${b!.dayTime!} ${b!.hourTime!}")));
      getAverageNumber();
    }
    await Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.home,
      (route) => false,
    );
  }

  @action
  setListRecordArrangedByTime() {
    listRecordArrangedByTime = listRecord;
    listRecordArrangedByTime!.sort((b, a) =>
        (DateFormat('yyyy/MM/dd').parse(a!.dayTime!))
            .compareTo(DateFormat('yyyy/MM/dd').parse(b!.dayTime!)));
  }

  @observable
  bool? canSaveNewRecord = false;
  @observable
  String? errorText = "";
  @action
  setErrorText(String errorMessage) {
    errorText = errorMessage;
    print("Erorrrrrrrrrrrrrrrr:${errorText}");
  }

  @action
  checkValidateNewRecord() {
    if (choosedDayTimeStr != null &&
        choosedDayHourStr != null &&
        currentStatus != null &&
        currentStatus != "" &&
        currentSugarAmount != null &&
        chooseCondition!.id != null) {
      if (isSwapedToMol == false) {
        if (currentSugarAmount! < 18 || currentSugarAmount! > 630) {
          setErrorText("Please enter correct value between 18-630 mg/dL");
        } else {
          setErrorText("");
        }
      }
      if (isSwapedToMol == true) {
        if (currentSugarAmount! < 1 || currentSugarAmount! > 35) {
          setErrorText("Please enter correct value between 1-35 mmol/L");
        } else {
          setErrorText("");
        }
      }
    }
  }

  static Future<void> saveListRecord(ListRecord? listRecords) async {
    if (listRecords != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonString = json.encode(listRecords!.toJson());
      prefs.setString('myObjectKey', jsonString);

      print("Save to shprf: ${listRecords.listRecord!.length} ");
    }
  }

  Future<ListRecord?> getListRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('myObjectKey');

    if (jsonString != null) {
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      listRecords = ListRecord.fromJson(jsonMap);
      if (listRecords != null) {
        listRecord = listRecords!.listRecord;
      }
      isListRecordsLoading = false;
      print("Load from sharedpref: ${listRecords!.listRecord!.first.dayTime}");
    } else {
      isListRecordsLoading = false;
      print("abcd");
    }
  }

  Future deleteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('myObjectKey'); // Xóa đối tượng theo khóa 'myObjectKey'
    // Hoặc có thể sử dụng prefs.clear() để xóa tất cả dữ liệu trong SharedPreferences
  }

  Future<void> exportToExcel(BuildContext context) async {
    // Read data from the JSON file
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('myObjectKey');
    List<dynamic> jsonData = json.decode(jsonString!)['list_record'];

    // Create an Excel workbook and worksheet
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];

    // Assign column names
    sheet.cell(CellIndex.indexByString("A1")).value = "Date";
    sheet.cell(CellIndex.indexByString("B1")).value = "Time";
    sheet.cell(CellIndex.indexByString("C1")).value =
        isSwapedToMol == true ? "Blood Sugar(mmol/L)" : "Blood Sugar(mg/dL)";

    sheet.setColWidth(2, 25);
    sheet.cell(CellIndex.indexByString("D1")).value = "Condition";
    sheet.cell(CellIndex.indexByString("E1")).value = "Type";

    // Write data to each column
    for (int i = 0; i < jsonData.length; i++) {
      var record = jsonData[i];
      sheet.cell(CellIndex.indexByString("A${i + 2}")).value =
          record['day_time'];
      sheet.cell(CellIndex.indexByString("B${i + 2}")).value =
          record['hour_time'];
      sheet.cell(CellIndex.indexByString("C${i + 2}")).value =
          "${record['sugar_amount']}";
      sheet.cell(CellIndex.indexByString("D${i + 2}")).value =
          "${AppLocalizations.of(context)!.getTranslate(record['condition_name'])}";

      sheet.cell(CellIndex.indexByString("E${i + 2}")).value =
          "${AppLocalizations.of(context)!.getTranslate(record['status'])}";
    }

    // Save the workbook as an Excel file
    var bytes = excel.encode();
    var directory = await getApplicationDocumentsDirectory();
    var file = "${directory.path}/data.xlsx";
    await File(file).writeAsBytes(bytes!);

    // Share the Excel file
    await Share.shareFiles([file], text: 'Sharing the Excel file');

    print("File exported and shared: $file");
    bool fileExists = await File(file).exists();
    if (fileExists) {
      print("File exported successfully: $file");
    } else {
      print("Failed to export file");
    }
  }

  Future<void> saveIsSwapedToMol(bool isSwapedToMol) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSwapedToMol', isSwapedToMol);
    saveListRecord(listRecords);
  }

  Future<void> getIsSwapedToMol() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isSwapedToMol') == null) {
      isSwapedToMol = false;
    } else {
      isSwapedToMol = prefs.getBool('isSwapedToMol');
    }
  }

  @observable
  SugarRecord? editingRecord;

  @action
  setEditingRecord(int? id) {
    editingRecord = listRecord!.where((e) => e.id == id).toList().first;
  }

  @action
  deleteRecord(int? id) {
    listRecord!.removeWhere((e) => e.id == id);
    saveListRecord(ListRecord(listRecord: listRecord));
  }

  @observable
  String? editedDayTime;
  @observable
  String? editedHourTime;
  @observable
  String? editedStatus;
  @observable
  double? editedSugarAmount;

  @action
  setEditedDayTime(DateTime dayTime) {
    editedDayTime = DateFormat('yyyy/MM/dd').format(dayTime);
  }

  @action
  setEditedHourTime(DateTime hourTime) {
    editedHourTime = DateFormat('HH:mm').format(hourTime);
  }

  @action
  setEditedStatus(String editedStatus) {
    editedStatus = editedStatus;
  }

  @action
  setEditedSugarAmount(double editedSugarAmount) {
    editedSugarAmount = editedSugarAmount;
  }

  @action
  editRecord(int editItemId, SugarRecord editedRecord, BuildContext context) {
    // _showDiaLogChange
    listRecord!.firstWhere((e) => e.id == editItemId).dayTime =
        editedRecord.dayTime;
    listRecord!.firstWhere((e) => e.id == editItemId).hourTime =
        editedRecord.hourTime;
    listRecord!.firstWhere((e) => e.id == editItemId).conditionId =
        editedRecord.conditionId;
    listRecord!.firstWhere((e) => e.id == editItemId).id = editedRecord.id;
    listRecord!.firstWhere((e) => e.id == editItemId).sugarAmount =
        editedRecord.sugarAmount;
    listRecord!.firstWhere((e) => e.id == editItemId).status =
        editedRecord.status;
    listRecordArrangedByTime = listRecord;
    if (listRecordArrangedByTime!.length > 0) {
      listRecordArrangedByTime!.sort((b, a) => (DateFormat('yyyy/MM/dd HH:mm')
              .parse("${a!.dayTime!} ${a!.hourTime!}"))
          .compareTo(DateFormat('yyyy/MM/dd HH:mm')
              .parse("${b!.dayTime!} ${b!.hourTime!}")));
      getAverageNumber();
    }
    saveListRecord(listRecords);
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.home,
      (route) => false,
    );
  }

  @action
  showDiaLogChange(BuildContext context, SugarRecord record) {
    return showDialog(
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
                  "${AppLocalizations.of(context)!.getTranslate('edit_duplicate_dialog')}",
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
                        replaceEditRecord(context, record);
                        deleteRecord(record.id);
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

  @observable
  double? recentNumber = 0;
  @observable
  double? threeDaysNumber = 0;
  @observable
  double? weekNumber = 0;
  @observable
  double? monthNumber = 0;
  @observable
  double? yearNumber = 0;
  @observable
  double? allNumber = 0;

  @action
  getAverageNumber() {
    if (listRecordArrangedByTime != null &&
        listRecordArrangedByTime!.isNotEmpty) {
      recentNumber = listRecordArrangedByTime!.first!.sugarAmount;

      // print("Check Date: ${DateFormat('yyyy/MM/dd').parse(choosedDayTimeStr!)}");
      List<SugarRecord>? listThreeDaysNumber = listRecordArrangedByTime!
          .where((e) =>
              DateFormat('yyyy/MM/dd')
                  .parse(e.dayTime!)
                  .isAfter(now.subtract(Duration(days: 4))) &&
              DateFormat('yyyy/MM/dd')
                  .parse(e.dayTime!)
                  .isBefore(now.add(Duration(days: 1))))
          .toList();

      List<SugarRecord>? listweekNumber = listRecordArrangedByTime!
          .where(
              (e) => DateFormat('yyyy/MM/dd').parse(e.dayTime!, true) != null)
          .where((e) {
        DateTime recordTime = DateFormat('yyyy/MM/dd').parse(e.dayTime!, true)!;
        return recordTime.isAfter(now.subtract(Duration(days: now.weekday))) &&
            recordTime.isBefore(now.add(Duration(days: 7 - now.weekday)));
      }).toList();

      List<SugarRecord>? listMonthNumber = listRecordArrangedByTime!
          .where((e) =>
              DateFormat('yyyy/MM/dd')
                  .parse(e.dayTime!)
                  .isAfter(now.subtract(Duration(days: now.month))) &&
              DateFormat('yyyy/MM/dd')
                  .parse(e.dayTime!)
                  .isBefore(now.add(Duration(days: 30 - now.month))))
          .toList();

      List<SugarRecord>? listYearNumber = listRecordArrangedByTime!
          .where((e) =>
              DateFormat('yyyy/MM/dd')
                  .parse(e.dayTime!)
                  .isAfter(now.subtract(Duration(days: 365))) &&
              DateFormat('yyyy/MM/dd')
                  .parse(e.dayTime!)
                  .isBefore(now.add(Duration(days: 1))))
          .toList();

      threeDaysNumber = roundedResult(listThreeDaysNumber).isNaN
          ? 0.0
          : roundedResult(listThreeDaysNumber);
      weekNumber = roundedResult(listweekNumber).isNaN
          ? 0.0
          : roundedResult(listweekNumber);
      monthNumber = roundedResult(listMonthNumber).isNaN
          ? 0.0
          : roundedResult(listMonthNumber);
      yearNumber = roundedResult(listYearNumber).isNaN
          ? 0.0
          : roundedResult(listYearNumber);
      allNumber = roundedResult(listRecordArrangedByTime).isNaN
          ? 0.0
          : roundedResult(listRecordArrangedByTime);
    } else {
      recentNumber = 0.0;
      threeDaysNumber = 0.0;
      weekNumber = 0.0;
      monthNumber = 0.0;
      yearNumber = 0.0;
      allNumber = 0.0;
    }

    // threeDaysNumber = listThreeDaysNumber.fold(
    //         0.0, (previousValue, item) => previousValue + item.sugarAmount!) /
    //     listThreeDaysNumber.length;

    print("recentNumber:${recentNumber}");
    print("threeDaysNumber:${threeDaysNumber}");
    print("weekNumber:${weekNumber}");
    print("monthNumber:${monthNumber}");
    print("yearNumber:${yearNumber}");
    print("allNumber:${allNumber}");
  }

  @action
  double roundedResult(List<SugarRecord>? listNumber) {
    return double.parse((listNumber!.fold(0.0,
                (previousValue, item) => previousValue + item.sugarAmount!) /
            listNumber.length)
        .toStringAsFixed(2));
  }

  @observable
  int? filterConditionId = 0;
  @observable
  String? filterConditionTitle = "default_txt";

  @action
  filterListRecord() {
    listRecordArrangedByTime = [];
    if (filterConditionId != -1) {
      listRecordArrangedByTime = listRecord!
          .where((e) => e.conditionId == filterConditionId)!
          .toList();
      listRecordArrangedByTime!.sort((b, a) =>
          (DateFormat('yyyy/MM/dd').parse(a!.dayTime!))
              .compareTo(DateFormat('yyyy/MM/dd').parse(b!.dayTime!)));
    } else {
      listRecordArrangedByTime = listRecord!;
      listRecordArrangedByTime!.sort((b, a) =>
          (DateFormat('yyyy/MM/dd').parse(a!.dayTime!))
              .compareTo(DateFormat('yyyy/MM/dd').parse(b!.dayTime!)));
    }
    isChartLoading = true;
    Future.delayed(Duration(milliseconds: 500), () {
      isChartLoading = false;
      print(isChartLoading);
    });
  }

  @action
  setConditionFilterId(String? value) {
    if (value != "all") {
      filterConditionId =
          listRootConditions!.where((e) => e.name == value).first.id;
      filterConditionTitle =
          listRootConditions!.where((e) => e.name == value).first.name;
      filterListRecord();
      isShouldRender = !isShouldRender!;
      getAverageNumber();
    } else {
      filterConditionId = -1;
      filterConditionTitle = "all";
      filterListRecord();
      isShouldRender = !isShouldRender!;
      getAverageNumber();
    }

    print("filterConditionId: ${filterConditionId}");
    print("filterConditionTitle: ${filterConditionTitle}");
  }

  @observable
  bool? isSwapedToMol = false;
  @action
  @action
  setSwapStatusToMol(bool? status) {
    isSwapedToMol = status;
  }

  @action
  multiplicationUnitListRecord() {
    for (int i = 0; i < listRecord!.length; i++) {
      if (listRecord![i].sugarAmount != null) {
        listRecord![i].sugarAmount = listRecord![i].sugarAmount! * 18;
      }
    }
  }

  @action
  multiplicationUnitListRootCondition() {
    for (var condition in listRootConditions!) {
      if (condition.sugarAmount != null) {
        for (var sugarAmount in condition.sugarAmount!) {
          if (sugarAmount.minValue != null) {
            sugarAmount.minValue = sugarAmount.minValue! * 18;
          }
          if (sugarAmount.maxValue != null) {
            sugarAmount.maxValue = sugarAmount.maxValue! * 18;
          }
        }
      }
    }
  }

  @action
  divisionnUnitListRecord() {
    for (int i = 0; i < listRecord!.length; i++) {
      if (listRecord![i].sugarAmount != null) {
        listRecord![i].sugarAmount = listRecord![i].sugarAmount! / 18;
      }
    }
  }

  @action
  divisionListRootCondition() {
    for (var condition in listRootConditions!) {
      if (condition.sugarAmount != null) {
        for (var sugarAmount in condition.sugarAmount!) {
          if (sugarAmount.minValue != null) {
            sugarAmount.minValue = sugarAmount.minValue! / 18;
          }
          if (sugarAmount.maxValue != null) {
            sugarAmount.maxValue = sugarAmount.maxValue! / 18;
          }
        }
      }
    }
  }

  @action
  swapUnit() {
    if (isSwapedToMol == false) {
      multiplicationUnitListRecord();
      multiplicationUnitListRootCondition();
      saveIsSwapedToMol(isSwapedToMol!);
      saveListRecord(listRecords);
    }
    if (isSwapedToMol == true) {
      divisionnUnitListRecord();
      divisionListRootCondition();
      saveIsSwapedToMol(isSwapedToMol!);
      saveListRecord(listRecords);
    }
  }

  @observable
  bool? optionUnitIsMol;

  @action
  chooseUnitIsMol(bool isMol) {
    optionUnitIsMol = isMol;
  }
////////////////////////////////////////////////////////////////

  final TextEditingController sugarAmountController = TextEditingController();
  final TextEditingController sugarAmountEditController =
      TextEditingController();

  @observable
  String sugarAmount = '80';

  @observable
  String? tempSugarAmount;

  @computed
  bool get isButtonEnabled =>
      double.tryParse(sugarAmount) != null &&
      double.parse(sugarAmount) >= 18 &&
      double.parse(sugarAmount) <= 630;

  @action
  void setSugarAmount(String value) {
    tempSugarAmount = value;
  }

  @action
  void validateSugarAmount() {
    if (tempSugarAmount != null) {
      sugarAmount = tempSugarAmount!;
    }
  }

  @action
  void resetSugarAmount() {
    sugarAmount = '80';
  }

  @observable
  String sugarAmountEdit = '80';

  @observable
  String? tempSugarAmountEdit;

  @computed
  bool get isButtonEnabledEdit =>
      double.tryParse(sugarAmountEdit) != null &&
      double.parse(sugarAmountEdit) >= 18 &&
      double.parse(sugarAmountEdit) <= 630;

  @action
  void setSugarAmountEdit(String value) {
    tempSugarAmountEdit = value;
  }

  @action
  void validateSugarAmountEdit() {
    if (tempSugarAmountEdit != null) {
      sugarAmountEdit = tempSugarAmountEdit!;
    }
  }

  @action
  void resetSugarAmountEdit() {
    sugarAmountEdit = '80';
  }

  ////////////////////////////////////////////////////////////

  @observable
  bool? isChartLoading = false;

  @observable
  bool? isShouldRender = false;
}
