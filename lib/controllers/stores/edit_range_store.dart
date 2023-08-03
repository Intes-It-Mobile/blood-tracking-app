import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/sugar_info/sugar_info.dart';
part 'edit_range_store.g.dart';

class EditRangeStore = _EditRangeStoreBase with _$EditRangeStore;

abstract class _EditRangeStoreBase with Store {
  @observable
  List<SugarAmount>? tempConditionDisplay;

  @observable
  String? errorText = "";
  @observable
  bool? canChange = false;
  @action
  setMaxValue(String? value, int? id) {
    checkValidate(value!, id!);
    if (canChange == true) {
      double doubleValue = double.parse(value);
      tempConditionDisplay!.where((e) => e.id == id).first.maxValue =
          doubleValue;
    }
    print("Validate: $canChange");
  }

  @action
  checkValidate(String value, int id) {
    if (tempConditionDisplay!.where((e) => e.id == id).first.maxValue! >=
        tempConditionDisplay!.where((e) => e.id == id + 1).first.maxValue!) {
      errorText = "Please enter the correct value";
      return canChange = false;
    } else {
      errorText = "";
      return canChange = true;
    }
  }
}
