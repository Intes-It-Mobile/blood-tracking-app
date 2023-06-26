import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/sugar_info/sugar_info.dart';
import '../../routes.dart';
part 'sugar_info_store.g.dart';

class SugarInfoStore = _SugarInfoStoreBase with _$SugarInfoStore;

abstract class _SugarInfoStoreBase with Store {
  @observable
  int abc = 0;

  @observable
  SugarInfo? rootSugarInfo;

  @observable
  List<Conditions>? listRootConditions;

  @observable
  String? currentStatus;

  @observable
  Conditions? chooseCondition;

  @observable
  double? currentSugarAmount = 0.0;

  @observable
  int? statusLevel = 0;
  @action
  getRootSugarInfo(SugarInfo? fromSharepref) {
    rootSugarInfo = fromSharepref;
    listRootConditions = fromSharepref!.conditions;
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
    if (inputAmount != null && inputAmount >= 18 || inputAmount <= 630) {
      currentStatus = chooseCondition!.sugarAmount!
          .where((e) =>
              e.minValue! * 1.0 <= inputAmount &&
              inputAmount < e.maxValue! * 1.0)
          .first
          .status;
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

  @action
  setchoosedDayTime(DateTime choosedDayTime) {
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
  bool? successSaveRecord = false;

  static final String ListRecordsKey = 'listRecord';

  @observable
  bool? hasExistedRecord = false;

  @action
  checkDuplicate() {
    hasExistedRecord = listRecord!.any((record) =>
        record.dayTime == choosedDayTimeStr &&
        record.hourTime == choosedDayHourStr &&
        record.conditionId == chooseCondition!.id &&
        record.status == currentStatus &&
        record.sugarAmount == currentSugarAmount);
    print(hasExistedRecord);
  }

  @action
  replaceRecord(BuildContext context) {
    SugarRecord recordUpdate = listRecord!.firstWhere((record) =>
        record.dayTime == choosedDayTimeStr &&
        record.hourTime == choosedDayHourStr &&
        record.conditionId == chooseCondition!.id &&
        record.status == currentStatus &&
        record.sugarAmount == currentSugarAmount);
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
  saveNewRecord(int id, BuildContext context) {
    listRecord!.add(SugarRecord(
        id: id,
        dayTime: choosedDayTimeStr,
        hourTime: choosedDayHourStr,
        status: currentStatus,
        sugarAmount: currentSugarAmount,
        conditionId: chooseCondition!.id));
    listRecords = ListRecord(listRecord: listRecord);
    choosedDayTimeStr = null;
    choosedDayHourStr = null;
    listRecordArrangedByTime = listRecord;
    setErrorText("");
    saveListRecord(listRecords);
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.home,
      (route) => false,
    );
    successSaveRecord = true;

    if (listRecordArrangedByTime!.length > 0) {
      listRecordArrangedByTime!.sort((b, a) =>
          (DateFormat('yyyy/MM/dd HH:mm').parse("${a!.dayTime!} ${a!.hourTime!}"))
              .compareTo(DateFormat('yyyy/MM/dd HH:mm').parse("${b!.dayTime!} ${b!.hourTime!}")));
      getAverageNumber();
    }

    successSaveRecord = false;
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
      if (currentSugarAmount! < 18 || currentSugarAmount! > 630) {
        setErrorText("Please enter correct value between 18-630 mg/dL");
      } else {
        setErrorText("");
      }
    }
  }

  static Future<void> saveListRecord(ListRecord? listRecords) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(listRecords!.toJson());
    prefs.setString('myObjectKey', jsonString);
    print("Save to shprf: ${listRecords.listRecord!.length} ");
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
  editRecord(int editItemId, SugarRecord editedRecord) {
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
    saveListRecord(listRecords);
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
                  .isAfter(now.subtract(Duration(days: 3))) &&
              DateFormat('yyyy/MM/dd')
                  .parse(e.dayTime!)
                  .isBefore(now.add(Duration(days: 1))))
          .toList();
      List<SugarRecord>? listweekNumber = listRecordArrangedByTime!
          .where((e) =>
              DateFormat('yyyy/MM/dd')
                  .parse(e.dayTime!)
                  .isAfter(now.subtract(Duration(days: 7))) &&
              DateFormat('yyyy/MM/dd')
                  .parse(e.dayTime!)
                  .isBefore(now.add(Duration(days: 1))))
          .toList();
      List<SugarRecord>? listMonthNumber = listRecordArrangedByTime!
          .where((e) =>
              DateFormat('yyyy/MM/dd')
                  .parse(e.dayTime!)
                  .isAfter(now.subtract(Duration(days: 30))) &&
              DateFormat('yyyy/MM/dd')
                  .parse(e.dayTime!)
                  .isBefore(now.add(Duration(days: 1))))
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
      threeDaysNumber = roundedResult(listThreeDaysNumber);
      weekNumber = roundedResult(listweekNumber);
      monthNumber = roundedResult(listMonthNumber);
      yearNumber = roundedResult(listYearNumber);
      allNumber = roundedResult(listRecordArrangedByTime);
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
        .toStringAsFixed(1));
  }

  @observable
  int? filterConditionId = 0;
  @observable
  String? filterConditionTitle = "default_txt";

  @action
  filterListRecord() {
    listRecordArrangedByTime =
        listRecord!.where((e) => e.conditionId == filterConditionId)!.toList();
    listRecordArrangedByTime!.sort((b, a) =>
        (DateFormat('yyyy/MM/dd').parse(a!.dayTime!))
            .compareTo(DateFormat('yyyy/MM/dd').parse(b!.dayTime!)));
  }

  @action
  setConditionFilterId(String? value) {
    filterConditionId =
        listRootConditions!.where((e) => e.name == value).first.id;
    filterConditionTitle =
        listRootConditions!.where((e) => e.name == value).first.name;
    filterListRecord();
    getAverageNumber();
    print("filterConditionId: ${filterConditionId}");
    print("filterConditionTitle: ${filterConditionTitle}");
  }
}
