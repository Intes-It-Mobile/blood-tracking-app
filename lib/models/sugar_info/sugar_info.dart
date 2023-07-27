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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.conditions != null) {
      data['conditions'] = this.conditions!.map((v) => v.toJson()).toList();
    }
    return data;
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
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.sugarAmount != null) {
      data['sugar_amount'] = this.sugarAmount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SugarAmount {
  int? id;
  String? status;
  double? minValue;
  double? maxValue;

  SugarAmount({this.status, this.minValue, this.maxValue, this.id});

  SugarAmount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    minValue = json['min_value'];
    maxValue = json['max_value'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['min_value'] = this.minValue;
    data['max_value'] = this.maxValue;
    return data;
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
  int? conditionId;
  int? id;
  String? status;
  double? sugarAmount;
  String? dayTime;
  String? hourTime;
  String? conditionName;

  SugarRecord(
      {this.status,
      this.sugarAmount,
      this.dayTime,
      this.hourTime,
      this.id,
      this.conditionId,
      this.conditionName});

  SugarRecord.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    sugarAmount = json['sugar_amount'];
    dayTime = json['day_time'];
    hourTime = json['hour_time'];
    id = json['id'];
    conditionId = json['condition_id'];
    conditionName = json['condition_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['sugar_amount'] = this.sugarAmount;
    data['day_time'] = this.dayTime;
    data['hour_time'] = this.hourTime;
    data['id'] = this.id;
    data['condition_id'] = this.conditionId;
    data['condition_name'] = this.conditionName;
    return data;
  }
}
