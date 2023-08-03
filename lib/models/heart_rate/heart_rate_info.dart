import 'package:flutter/material.dart';

class ListHeartRate {
  List<HeartRateInfo>? listHeartRate;

  ListHeartRate({this.listHeartRate});

  factory ListHeartRate.fromJson(Map<String, dynamic> json) {
    return ListHeartRate(
      listHeartRate: json['list_heart_rate'] != null
          ? List<HeartRateInfo>.from(
              json['list_heart_rate'].map((x) => HeartRateInfo.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'list_heart_rate': listHeartRate != null
          ? listHeartRate!.map((x) => x.toJson()).toList()
          : [],
    };
  }
}

class HeartRateInfo{
  String? id;
  DateTime? date;
  int? indicator;
  HeartRateInfo({
    this.id,
    this.date,
    this.indicator
  });

  factory HeartRateInfo.fromJson(Map<String, dynamic> json) {
    return HeartRateInfo(
      id : json['id'],
      date : DateTime.parse(json['date']),
      indicator : json['indicator'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = (this.date ?? DateTime.now()).toIso8601String();
    data['indicator'] = this.indicator;
    return data;
  }

  @override
  bool operator == (Object other) =>
      other is HeartRateInfo &&
      other.runtimeType == runtimeType &&
      other.id == id &&
      other.date == date &&
      other.indicator == indicator;
}