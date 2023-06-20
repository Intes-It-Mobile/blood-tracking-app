import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/sugar_info/sugar_info.dart';
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
  int? statusLevel = 0;

  @observable
  double? currentSugarAmount = 0.0;

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
    currentStatus = chooseCondition!.sugarAmount!
        .where((e) =>
            e.minValue! * 1.0 < inputAmount && inputAmount < e.maxValue! * 1.0)
        .first
        .status;
    currentSugarAmount = inputAmount;
    if (currentStatus != null) {
      setStatusLevel(currentStatus);
    }
  }

  @computed
  get btnStatus => currentSugarAmount != null && legalInput == true;

  @action
  setStatusLevel(String? currentStatus) {
    switch (currentStatus) {
      case 'low':
        return statusLevel = 0;
      case 'normal':
        return statusLevel = 1;
      case 'pre-diabetes':
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
  String? choosedDayTimeStr=DateFormat('yyyy/MM/dd').format(DateTime.now());

  @observable
  String? choosedDayHourStr = DateFormat('HH:mm').format(DateTime.now());
  @observable
  String? choosedDayTimeStrDisplay=DateFormat('yyyy/MM/dd').format(DateTime.now());

  @observable
  String? choosedDayHourStrDisplay= DateFormat('HH:mm').format(DateTime.now());

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
  ListRecord? listRecords;

  @observable
  bool? isListRecordsLoading = true;

  static final String ListRecordsKey = 'listRecord';
  @action
  saveRecord() {
    listRecord!.add(SugarRecord(
        dayTime: choosedDayTimeStr,
        hourTime: choosedDayHourStr,
        status: currentStatus,
        sugarAmount: currentSugarAmount));
    listRecords = ListRecord(listRecord: listRecord);
    saveListRecord(listRecords);
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
    }
  }
}
