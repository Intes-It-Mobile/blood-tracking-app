import 'package:mobx/mobx.dart';

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

    if (currentStatus != null) {
      setStatusLevel(currentStatus);
    }
  }

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
}
