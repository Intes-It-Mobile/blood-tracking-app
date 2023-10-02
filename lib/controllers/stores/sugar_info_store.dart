import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../models/goal/goal_amount.dart';
import '../../models/information/information.dart';
import '../../models/information/information_provider.dart';
import '../../models/sugar_info/sugar_info.dart';
import '../../routes.dart';
import 'package:excel/excel.dart';

import '../../utils/ads/applovin_function.dart';
import '../../utils/ads_ios/ads.dart';
import '../../utils/locale/appLocalizations.dart';
import '../../widgets/goal_dialog/goal_far_dialog.dart';
import '../../widgets/goal_dialog/goal_nearly_dialog.dart';
import '../../widgets/goal_dialog/goal_reached_dialog.dart';
import '../../widgets/share_local.dart';
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

  Future<void> checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Đây là lần đầu tiên người dùng vào ứng dụng, hãy lưu giá trị false vào SharedPreferences.
    prefs.setBool('isFirstTime', false);
  }

  @action
  getRootSugarInfo(SugarInfo? fromSharepref) async {
    bool isFirstTime;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    isFirstTime = prefs.getBool('isFirstTime') ?? true;
    rootSugarInfo = fromSharepref;
    if (isSwapedToMol == false) {
      listRootConditions = fromSharepref!.conditions;
      setValueToListFilter(listRootConditions);
    }
    if (isSwapedToMol == true) {
      if (isFirstTime != false) {
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
      } else {
        listRootConditions = fromSharepref!.conditions;
        setValueToListFilter(listRootConditions);
      }
    }
    checkFirstTime();
  }

  @action
  setValueToListFilter(List<Conditions>? list) {
    listRootConditionsFilter = list;
  }

  @action
  setChooseCondition(int chooseId) {
    chooseCondition =
        listRootConditions!.where((e) => e.id == chooseId).toList().first;
    if (chooseCondition != null) {}
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
      if (inputAmount >= 18 || inputAmount <= 630) {
        if (inputAmount < 630) {
          currentStatus = chooseCondition!.sugarAmount!
              .where((e) =>
                  e.minValue! * 1.0 <= inputAmount &&
                  inputAmount < e.maxValue! * 1.0)
              .first
              .status;
        } else {
          currentStatus = "diabetes";
        }
      }
    } else if (isSwapedToMol == true) {
      if (inputAmount >= 1 || inputAmount <= 35) {
        if (inputAmount < 35) {
          currentStatus = chooseCondition!.sugarAmount!
              .where((e) =>
                  e.minValue! * 1.0 <= inputAmount &&
                  inputAmount < e.maxValue! * 1.0)
              .first
              .status;
        } else {
          currentStatus = "diabetes";
        }
      }
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
      // editRecord(id, sugarRecordEdit, context);
      showDiaLogChangeSimple(sugarRecordEdit, context, id);
    }
    print(hasExistedEditRecord);
  }

  showDiaLogChangeSimple(
      SugarRecord sugarRecordEdit, BuildContext context, int id) {
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
                              editRecord(id, sugarRecordEdit, context);
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

  @action
  replaceEditRecord(BuildContext context, SugarRecord sugarRecordEdit) {
    SugarRecord recordUpdate = listRecord!.firstWhere((record) =>
        record.dayTime == sugarRecordEdit.dayTime &&
        record.hourTime == sugarRecordEdit.hourTime);
    {
      recordUpdate.conditionId = sugarRecordEdit.conditionId;
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
        sugarAmount: currentSugarAmount,
        conditionId: chooseCondition!.id,
        status: findStatusForValueAndConditionId(rootSugarInfo!.conditions!,
            currentSugarAmount!, chooseCondition!.id!),
        conditionName: chooseCondition!.name,
        informed: false));
    listRecords = ListRecord(listRecord: listRecord);
    choosedDayTimeStr = null;
    choosedDayHourStr = null;
    listRecordArrangedByTime = listRecord;
    setErrorText("");
    saveListRecord(listRecords);
    if (listRecordArrangedByTime!.length > 0) {
      listRecordArrangedByTime!.sort((b, a) =>
          (DateFormat('yyyy/MM/dd HH:mm').parse("${a.dayTime!} ${a.hourTime!}"))
              .compareTo(DateFormat('yyyy/MM/dd HH:mm')
                  .parse("${b.dayTime!} ${b.hourTime!}")));
      getAverageNumber();
    }
    print('popup');

    // AppLovinFunction().showInterstitialAds();
        displayInterAds();

    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.home,
      (route) => false,
    );
    if (listRecordArrangedByTime!.length == 1) {
      sugarRecordGoal = listRecordArrangedByTime!.first;
      saveSugarRecordGoal(sugarRecordGoal!);
      Future.delayed(Duration(milliseconds: 2500), () {
        checkGoal(listRecordArrangedByTime!.first.sugarAmount!);
        print("Check Goal");
      });
    }
    checkAndReplaceRecord(listRecordArrangedByTime!, sugarRecordGoal!);
  }
  void displayInterAds(){
      ShowInterstitialAdsController showInterstitialAdsController = ShowInterstitialAdsController();
      showInterstitialAdsController.loadAd();
      Future.delayed(Duration(milliseconds: 1000),(){
showInterstitialAdsController.showAlert();
      });

  }

  String findStatusForValueAndConditionId(
      List<Conditions> listRootConditions, double value, int conditionId) {
    // Tìm điều kiện có id tương ứng
    Conditions? condition;
    for (var item in listRootConditions) {
      if (item.id == conditionId) {
        condition = item;
        break;
      }
    }

    if (condition != null && condition.sugarAmount != null) {
      // Tìm SugarAmount tương ứng với giá trị value
      for (var sugarAmount in condition.sugarAmount!) {
        if (sugarAmount.minValue != null && sugarAmount.maxValue != null) {
          if (isSwapedToMol == true) {
            if (value == 35) {
              return "diabetes";
            }
          } else {
            if (value == 630) {
              return "diabetes";
            }
          }
          if (value >= sugarAmount.minValue! && value < sugarAmount.maxValue!) {
            return sugarAmount.status ?? "Unknown";
          }
        }
      }
    }

    return "Not Found";
  }

  @action
  setListRecordArrangedByTime() {
    listRecordArrangedByTime = listRecord;
    listRecordArrangedByTime!.sort((b, a) =>
        (DateFormat('yyyy/MM/dd').parse(a.dayTime!))
            .compareTo(DateFormat('yyyy/MM/dd').parse(b.dayTime!)));
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
  checkValidateNewRecord(BuildContext context) {
    if (choosedDayTimeStr != null &&
        choosedDayHourStr != null &&
        currentStatus != null &&
        currentStatus != "" &&
        currentSugarAmount != null &&
        chooseCondition!.id != null) {
      if (isSwapedToMol == false) {
        if (currentSugarAmount! < 18 || currentSugarAmount! > 630) {
          setErrorText(
              "${AppLocalizations.of(context)!.getTranslate('errow_sugar_input_mg_text')}");
        } else {
          setErrorText("");
        }
      }
      if (isSwapedToMol == true) {
        if (currentSugarAmount! < 1 || currentSugarAmount! > 35) {
          setErrorText(
              "${AppLocalizations.of(context)!.getTranslate('errow_sugar_input_mmol_text')}");
        } else {
          setErrorText("");
        }
      }
    }
  }

  static Future<void> saveListRecord(ListRecord? listRecords) async {
    if (listRecords != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonString = json.encode(listRecords.toJson());
      prefs.setString('list_record', jsonString);

      print("Save to shprf: ${listRecords.listRecord!.length} ");
    }
  }

  Future<ListRecord?> getListRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('list_record');

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
    }
    return null;
  }

  Future deleteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('list_record'); // Xóa đối tượng theo khóa 'list_record'
    // Hoặc có thể sử dụng prefs.clear() để xóa tất cả dữ liệu trong SharedPreferences
  }

  Future<void> exportToExcel(BuildContext context) async {
    // Read data from the JSON file
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('list_record');
    List<dynamic> jsonData = json.decode(jsonString!)['list_record'];

    // Create an Excel workbook and worksheet
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];

    // Assign column names
    sheet.cell(CellIndex.indexByString("A1")).value =
        "${AppLocalizations.of(context).getTranslate('date')}";
    sheet.cell(CellIndex.indexByString("B1")).value =
        "${AppLocalizations.of(context).getTranslate('time')}";
    sheet.cell(CellIndex.indexByString("C1")).value = isSwapedToMol == true
        ? "${AppLocalizations.of(context).getTranslate('blood_tlt_excel_mol')}"
        : "${AppLocalizations.of(context).getTranslate('blood_tlt_excel_mg')}";

    sheet.setColWidth(2, 25);
    sheet.cell(CellIndex.indexByString("D1")).value =
        "${AppLocalizations.of(context).getTranslate('condition')}";
    sheet.cell(CellIndex.indexByString("E1")).value =
        "${AppLocalizations.of(context).getTranslate('type')}";

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
          "${AppLocalizations.of(context).getTranslate(record['condition_name'])}";

      sheet.cell(CellIndex.indexByString("E${i + 2}")).value =
          "${AppLocalizations.of(context).getTranslate(record['status'])}";
    }

    // Save the workbook as an Excel file
    var bytes = excel.encode();
    var directory = await getApplicationDocumentsDirectory();
    var file = "${directory.path}/blood_sugar_tracking_data.xlsx";
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
    saveRootConditionToSharedPreferences(rootSugarInfo!);
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

    if (listRecordArrangedByTime!.length > 0) {
      sugarRecordGoal = listRecordArrangedByTime!.first;
      saveGoalAmountToSharedPreferences();
    } else {
      sugarRecordGoal = null;
    }
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
    listRecord!.firstWhere((e) => e.id == editItemId).conditionName =
        editedRecord.conditionName;
    listRecordArrangedByTime = listRecord;
    if (listRecordArrangedByTime!.length > 0) {
      listRecordArrangedByTime!.sort((b, a) =>
          (DateFormat('yyyy/MM/dd HH:mm').parse("${a.dayTime!} ${a.hourTime!}"))
              .compareTo(DateFormat('yyyy/MM/dd HH:mm')
                  .parse("${b.dayTime!} ${b.hourTime!}")));
      getAverageNumber();
    }
    saveListRecord(listRecords);
    // AppLovinFunction().showInterstitialAds();
    displayInterAds();
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.home,
      (route) => false,
    );
    if (listRecordArrangedByTime!.length > 0) {
      sugarRecordGoal = listRecordArrangedByTime!.first;
      saveGoalAmountToSharedPreferences();
    }
    // checkGoal();
    checkAndReplaceRecord(listRecordArrangedByTime!, sugarRecordGoal!);
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
                  "${AppLocalizations.of(context).getTranslate('edit_duplicate_dialog')}",
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
                            "${AppLocalizations.of(context).getTranslate('replace')}",
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
                            "${AppLocalizations.of(context).getTranslate('keep')}",
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
      recentNumber = listRecordArrangedByTime!.first.sugarAmount;

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
        DateTime recordTime = DateFormat('yyyy/MM/dd').parse(e.dayTime!, true);
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
      listRecordArrangedByTime =
          listRecord!.where((e) => e.conditionId == filterConditionId).toList();
      listRecordArrangedByTime!.sort((b, a) =>
          (DateFormat('yyyy/MM/dd').parse(a.dayTime!))
              .compareTo(DateFormat('yyyy/MM/dd').parse(b.dayTime!)));
    } else {
      listRecordArrangedByTime = listRecord!;
      listRecordArrangedByTime!.sort((b, a) =>
          (DateFormat('yyyy/MM/dd').parse(a.dayTime!))
              .compareTo(DateFormat('yyyy/MM/dd').parse(b.dayTime!)));
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
      filterConditionTitle = "All";
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
            print("divisionnnnnnnnnnnnnnnnnnnnnnnnnn");
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
      getGoalAmountFromSharedPreferences();
    }
    if (isSwapedToMol == true) {
      divisionnUnitListRecord();
      divisionListRootCondition();
      saveIsSwapedToMol(isSwapedToMol!);
      saveListRecord(listRecords);
      getGoalAmountFromSharedPreferences();
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

  ////////////////////////////////////////////////////////////////

  @observable
  List<SugarAmount> tempCondition = [];
  @observable
  List<SugarAmount> tempConditionDisplay = [];
  List<SugarAmount> tempRootCondition = [];
  List<SugarAmount> cloneConditionList(List<SugarAmount> originalList) {
    return originalList
        .map((e) => SugarAmount(
            id: e.id,
            // Clone các thuộc tính khác của Condition tại đây
            maxValue: e.maxValue,
            minValue: e.minValue,
            status: e.status))
        .toList();
  }

  @observable
  int? tempConditionId;
  @action
  getTempCondition(int id) {
    tempCondition = rootSugarInfo!.conditions!
        .where((e) => e.id == id)
        .first
        .sugarAmount!
        .toList();
    tempConditionDisplay = cloneConditionList(tempCondition);
  }

  @action
  setMaxValue(String? value, int? id) {
    double doubleValue = double.parse(value!);
    tempConditionDisplay.where((e) => e.id == id).first.maxValue = doubleValue;
  }

  bool? canSave() {
    if (tempConditionDisplay == null || tempConditionDisplay.isEmpty) {
      return false;
    }

    for (int i = 0; i < tempConditionDisplay.length; i++) {
      double? minValue = tempConditionDisplay[i].minValue;
      double? maxValue = tempConditionDisplay[i].maxValue;
      for (int i = 1; i < tempConditionDisplay.length; i++) {
        tempConditionDisplay[i].minValue = tempConditionDisplay[i - 1].maxValue;
      }

      if (minValue == null || maxValue == null || minValue >= maxValue) {
        print("mg Error in 1: $i");
        return false;
      }

      if (isSwapedToMol == true) {
        if (minValue > 35 || maxValue > 35) {
          print("Mol Error in 2: $i");
          return false;
        }
      } else {
        if (minValue > 630 || maxValue > 630) {
          print("mg Error in 3: $i");
          return false;
        }
      }

      if (i > 0) {
        double? prevMaxValue = tempConditionDisplay[i - 1].maxValue;
        if (prevMaxValue == null || prevMaxValue > maxValue) {
          print("error compare");
          return false;
        }
      }
    }

    return true;
  }

  @action
  setNewRootCondition(int editConditionId, BuildContext context) {
    adjustMinMaxValues(tempConditionDisplay);
    if (canSave() == true) {
      rootSugarInfo!.conditions!
          .where((e) => e.id == editConditionId)
          .first
          .sugarAmount = tempConditionDisplay;
      // updateMaxValue(rootSugarInfo!.conditions!);
      saveRootConditionToSharedPreferences(rootSugarInfo!);
      hasChangedRoot = !hasChangedRoot!;
      print("id                      ${tempConditionDisplay.first.id}");
      Navigator.of(context).pop();
    } else {
      showSnackbarOverlay(context,
          "${AppLocalizations.of(context)!.getTranslate("err_correct_value")}");
    }
  }

  void showSnackbarOverlay(BuildContext context, String message) async {
    final overlay = Overlay.of(context);
    final opacityController = AnimationController(
      vsync: Navigator.of(context),
      duration: Duration(milliseconds: 200),
    );
    // Create an OverlayEntry for the Snackbar
    final overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: opacityController,
          builder: (context, child) {
            return Opacity(
              opacity: opacityController.value,
              child: snackbarContent(message),
            );
          },
        );
      },
    );

    overlay.insert(overlayEntry);

    await opacityController.forward();
    await Future.delayed(Duration(seconds: 2));
    await opacityController.reverse();

    overlayEntry.remove();
    opacityController.dispose();
  }

  Widget snackbarContent(String message) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Card(
        margin: EdgeInsets.only(bottom: 65),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Text(
            message,
            style: AppTheme.appBodyTextStyle.copyWith(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Future<void> saveRootConditionToSharedPreferences(SugarInfo sugarInfo) async {
    if (sugarInfo != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonString = json.encode(sugarInfo.toJson());
      prefs.setString('json_data', jsonString);
    }
  }

  void adjustMinMaxValues(List<SugarAmount> tempConditionDisplay) {
    for (int i = 1; i < tempConditionDisplay.length; i++) {
      tempConditionDisplay[i].minValue = tempConditionDisplay[i - 1].maxValue;
    }
  }

  @observable
  bool? hasChangedRoot = false;
  /////
  @observable
  Information? information = Information();

  @observable
  BuildContext? homeScreenContext;

  @observable
  GoalAmount? goalAmount = GoalAmount();

  @observable
  int? goalFirstMolValue;
  @observable
  int? goalSecondMolValue;
  @action
  setGoalMolAmount() {
    goalAmount!.amount = matchValueMol(goalFirstMolValue, goalSecondMolValue);
    goalAmount!.isMol = isSwapedToMol;
  }

  @observable
  String? errorGoalText = "";
  @action
  checkValidateGoalMolAmount(double goalAmount) {
    if (goalAmount > 35) {
      errorGoalText = "error_goal_value";
      print("Error goal: $errorGoalText");
    } else {
      errorGoalText = "";
    }
  }

  @action
  double matchValueMol(int? firstValue, int? seconValue) {
    String matchedValue = "${firstValue}.${seconValue}";
    return double.parse(matchedValue);
  }

  @action
  setGoalAmount(
    double? value,
  ) {
    goalAmount = GoalAmount(amount: value, isMol: isSwapedToMol);

    saveGoalAmountToSharedPreferences();
  }

  @action
  saveGoalAmountToSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Chuyển đổi đối tượng GoalAmount thành JSON (Map<String, dynamic>)
    final Map<String, dynamic> json = goalAmount!.toJson();

    // Lưu vào SharedPreferences dưới dạng JSON String
    await prefs.setString('goal_amount', jsonEncode(json));
  }

  @action
  Future<GoalAmount?> getGoalAmountFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Lấy chuỗi JSON từ SharedPreferences
    final String? jsonString = prefs.getString('goal_amount');

    if (jsonString != null) {
      // Nếu có dữ liệu, chuyển đổi JSON thành Map
      final Map<String, dynamic> json = jsonDecode(jsonString);
      goalAmount = GoalAmount.fromJson(json);
      if (goalAmount!.isMol != isSwapedToMol) {
        if (isSwapedToMol == true) {
          if (goalAmount!.amount! > 1) {
            goalAmount!.amount = goalAmount!.amount! / 18;
            goalAmount!.isMol = isSwapedToMol;
          }
          saveGoalAmountToSharedPreferences();
        } else if (isSwapedToMol == false) {
          goalAmount!.amount = goalAmount!.amount! * 18;
          goalAmount!.isMol = isSwapedToMol;
          saveGoalAmountToSharedPreferences();
        }
      }
      // Tạo đối tượng GoalAmount từ Map
      return GoalAmount.fromJson(json);
    } else {
      // Nếu không có dữ liệu, trả về null hoặc giá trị mặc định tùy trường hợp
      return null;
    }
  }

  @action
  Future<void> fetchGoalAmountFromSharedPreferences() async {
    goalAmount = await getGoalAmountFromSharedPreferences();
  }

  @action
  checkGoal(double sugarAmount) {
    double calculate(double? value) {
      return (value! - goalAmount!.amount!).abs();
    }

    if (isSwapedToMol == false) {
      switch (calculate(sugarAmount)) {
        case > 20:
          return showDiaLogFarGoal(homeScreenContext!);
        case <= 20 && > 1:
          return showDiaLogNearlyGoal(homeScreenContext!);
        case <= 1:
          return showDiaLogReachGoal(homeScreenContext!);

        default:
          return "";
      }
    } else {
      switch (calculate(sugarAmount)) {
        case > 20 / 18:
          return showDiaLogFarGoal(homeScreenContext!);
        case <= 20 / 18 && > 1 / 18:
          return showDiaLogNearlyGoal(homeScreenContext!);
        case <= 1 / 18:
          return showDiaLogReachGoal(homeScreenContext!);

        default:
          return "";
      }
    }
  }

  Future<String?> showDiaLogFarGoal(
    BuildContext context,
  ) {
    return showDialog<String>(
      context: context,
      builder: (
        BuildContext context,
      ) =>
          GoalFarDialog(),
    );
  }

  Future<String?> showDiaLogNearlyGoal(
    BuildContext context,
  ) {
    return showDialog<String>(
      context: context,
      builder: (
        BuildContext context,
      ) =>
          GoalNearlyDialog(),
    );
  }

  Future<String?> showDiaLogReachGoal(
    BuildContext context,
  ) {
    return showDialog<String>(
      context: context,
      builder: (
        BuildContext context,
      ) =>
          GoalReachedDialog(),
    );
  }

  @observable
  SugarRecord? sugarRecordGoal;

  // Future<void> saveSugarRecordGoal(SugarRecord sugarRecordGoal) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString('sugarRecordGoal', sugarRecordGoal.toJson().toString());
  // }

  Future<void> saveSugarRecordGoal(SugarRecord sugarRecordGoal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sugarRecordString = json.encode(sugarRecordGoal.toJson());
    await prefs.setString('sugarRecordGoal', sugarRecordString);
  }

  Future<SugarRecord?> getSugarRecordGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('sugarRecordGoal');
    if (jsonString != null) {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      sugarRecordGoal = SugarRecord.fromJson(json);

      return SugarRecord.fromJson(json);
    }
    return null; // Trả về null nếu không có dữ liệu trong Shared Preferences
  }

  void checkAndReplaceRecord(
      List<SugarRecord> listRecord, SugarRecord sugarRecordGoal) {
    bool found = false;

    // Chuyển đổi thời gian của sugarRecordGoal từ chuỗi thành đối tượng DateTime
    DateTime goalDateTime = DateFormat("yyyy/MM/dd HH:mm")
        .parse(sugarRecordGoal.dayTime! + " " + sugarRecordGoal.hourTime!);
    // DateTime.parse(
    //     sugarRecordGoal.dayTime! + " " + sugarRecordGoal.hourTime!);

    for (int i = 0; i < listRecord.length; i++) {
      // Chuyển đổi thời gian của mỗi record trong listRecord thành đối tượng DateTime
      DateTime recordDateTime = DateFormat("yyyy/MM/dd HH:mm")
          .parse(listRecord[i].dayTime! + " " + listRecord[i].hourTime!);

      // So sánh thời gian xảy ra của record với thời gian xảy ra của goal
      if (recordDateTime.isAfter(goalDateTime)) {
        checkGoal(listRecord[i].sugarAmount!);
        sugarRecordGoal =
            listRecord[i]; // Thay thế sugarRecordGoal bằng record tìm thấy
        saveSugarRecordGoal(listRecord[i]);
        found = true;
        break;
      }
    }

    if (found) {
      print("yes");
    } else {
      print("no");
    }
  }

  @observable
  bool? tempChooseUnitMol = false;
  @action
  setTempChooseUnitMol(bool value) {
    tempChooseUnitMol = value;
  }
}
