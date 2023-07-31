import 'dart:convert';

import 'package:blood_sugar_tracking/models/heart_rate/heart_rate_info.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeartRateStore {
    List<HeartRateInfo>? listRecord = [];

  Future<void> saveNewRecord(HeartRateInfo heartRateInfo) async {
    await getListRecords();
    listRecord ??= [];
    listRecord!.add(heartRateInfo);
    await saveListRecord(ListHeartRate(listHeartRate: listRecord));
  }

  static Future<void> saveListRecord(ListHeartRate? listHeartRate) async{
    if (listHeartRate != null){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonString = json.encode(listHeartRate.toJson());
      prefs.setString("list_heart_rate", jsonString);
    }
  }

  Future<void> getListRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('list_heart_rate');
    if (jsonString != null){
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      ListHeartRate re = ListHeartRate.fromJson(jsonMap);
      if (re.listHeartRate!=null) {
        listRecord = re.listHeartRate;
      }
    }
  }

  Future<void> deleteRecord(HeartRateInfo heartRateInfo) async {
    await getListRecords();
    listRecord ??= [];
    listRecord!.removeWhere((item) => item.id == heartRateInfo.id);
    await saveListRecord(ListHeartRate(listHeartRate: listRecord));
  }

  Future<void> editRecord(HeartRateInfo heartRateInfo) async {
    await getListRecords();
    listRecord ??= [];
    List<HeartRateInfo> updated = [];
    listRecord!.forEach((item) {
      if (item.id == heartRateInfo.id){
        updated.add(heartRateInfo);
      } else {
        updated.add(item);
      }
    });
    await saveListRecord(ListHeartRate(listHeartRate: updated));
  }
}