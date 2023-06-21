class SugarInfo {
  List<Conditions>? conditions;

  SugarInfo({this.conditions});

  SugarInfo.fromJson(Map<String, dynamic> json) {
    if (json['conditions'] != null) {
      conditions = <Conditions>[];
      json['conditions'].forEach((v) {
        conditions!.add(new Conditions.fromJson(v));
      });
    }
  }
}

class Conditions {
  int? id;
  String? name;
  List<SugarAmount>? sugarAmount;

  Conditions({this.id, this.name, this.sugarAmount});

  Conditions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['sugar_amount'] != null) {
      sugarAmount = <SugarAmount>[];
      json['sugar_amount'].forEach((v) {
        sugarAmount!.add(new SugarAmount.fromJson(v));
      });
    }
  }
}

class SugarAmount {
  String? status;
  int? minValue;
  int? maxValue;

  SugarAmount({this.status, this.minValue, this.maxValue});

  SugarAmount.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    minValue = json['min_value'];
    maxValue = json['max_value'];
  }
}

class ListRecord {
 List<SugarRecord>? listRecord;

  ListRecord({this.listRecord});

  factory ListRecord.fromJson(Map<String, dynamic> json) {
    return ListRecord(
      listRecord: json['list_record'] != null
          ? List<SugarRecord>.from(
              json['list_record'].map((x) => SugarRecord.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'list_record': listRecord != null
          ? listRecord!.map((x) => x.toJson()).toList()
          : null,
    };
  }
}

class SugarRecord {
  int? id;
  String? status;
  double? sugarAmount;
  String? dayTime;
  String? hourTime;

  SugarRecord({this.status, this.sugarAmount, this.dayTime, this.hourTime,this.id});

  SugarRecord.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    sugarAmount = json['sugar_amount'];
    dayTime = json['day_time'];
    hourTime = json['hour_time'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['sugar_amount'] = this.sugarAmount;
    data['day_time'] = this.dayTime;
    data['hour_time'] = this.hourTime;
    data['id'] = this.id;
    return data;
  }
}