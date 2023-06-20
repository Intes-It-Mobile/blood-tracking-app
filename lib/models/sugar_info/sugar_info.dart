
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