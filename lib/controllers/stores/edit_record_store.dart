import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

import '../../models/sugar_info/sugar_info.dart';
part 'edit_record_store.g.dart';

class EditRecordStore = _EditRecordStoreBase with _$EditRecordStore;

abstract class _EditRecordStoreBase with Store {
  @observable
  DateTime? editingDayTime;

  @observable
  DateTime? editingHourTime;

  @observable
  String? editingDayTimeStr;

  @observable
  String? editingHourTimeStr;

  @observable
  double? editingSugarAmount = 0;

  @observable
  int? conditionId = 0;

  @observable
  int? recordId = 0;

  @observable
  String? currentEditStatus;

  @observable
  String? editStatus;

  @observable
  Conditions? editChooseCondition;
  @observable
  List<Conditions>? listRootConditions;
  @observable
  SugarInfo? rootSugarInfo;
  @observable
  int? editStatusLevel;
  @action
  getRootSugarInfo(List<Conditions> editChooseCondition) {
    //  Lớn hơn >= min, nhỏ hơn max
    listRootConditions = editChooseCondition;
  }

  @action
  setEditChooseCondition(int eDitchooseId) {
    editChooseCondition =
        listRootConditions!.where((e) => e.id == eDitchooseId).toList().first;
    if (editChooseCondition != null) {}
  }

  @action
  setEditInputSugarAmount(double inputAmount) {
    setCurrentEditAmount(inputAmount);
    setCurrentEditStatus(inputAmount);
    if (currentEditStatus != null) {
      setEditStatusLevel(currentEditStatus);
    }
  }

  @action
  setCurrentEditAmount(double inputAmount) {
    editingSugarAmount = inputAmount;
  }

  @action
  setCurrentEditStatus(double inputAmount) {
    //  Lớn hơn >= min, nhỏ hơn max
    if (inputAmount >= 18 || inputAmount <= 630) {
      if ((inputAmount == 35 && isSwapedToMol == true) ||
          (inputAmount == 630 && isSwapedToMol == false)) {
        if (isSwapedToMol == true) {
          if (inputAmount == 35) {
            currentEditStatus = "diabetes";
          }
        } else {
          if (inputAmount == 630) {
            currentEditStatus = "diabetes";
          }
        }
      } else {
        currentEditStatus = editChooseCondition!.sugarAmount!
            .where((e) =>
                e.minValue! * 1.0 <= inputAmount &&
                inputAmount < e.maxValue! * 1.0)
            .first
            .status;
      }
    }
  }

  @action
  setEditStatusLevel(String? currentEditStatus) {
    switch (currentEditStatus) {
      case 'low':
        return editStatusLevel = 0;
      case 'normal':
        return editStatusLevel = 1;
      case 'pre_diabetes':
        return editStatusLevel = 2;
      case 'diabetes':
        return editStatusLevel = 3;
      default:
        throw RangeError("");
    }
  }

  @action
  setEditedDayTime(DateTime dayTime) {
    editingDayTime = dayTime;
    editingDayTimeStr = DateFormat('yyyy/MM/dd').format(dayTime);
  }

  @action
  setEditedHourTime(DateTime hourTime) {
    editingHourTime = hourTime;
    editingHourTimeStr = DateFormat('HH:mm').format(hourTime);
  }

  String? errorText = "";
  @action
  setErrorText(String errorMessage) {
    errorText = errorMessage;
  }

  @observable
  bool? isSwapedToMol;
  @action
  checkValidateEditRecord(double value) {
    if (editingDayTimeStr != null &&
        editingHourTimeStr != null &&
        currentEditStatus != null &&
        currentEditStatus != "" &&
        editingSugarAmount != null &&
        editChooseCondition!.id != null) {
      if (isSwapedToMol == false) {
        if (editingSugarAmount! < 18 || editingSugarAmount! > 630) {
          setErrorText("Please enter correct value between 18-630 mg/dL");
        } else {
          setErrorText("");
        }
      }
      if (isSwapedToMol == true) {
        if (editingSugarAmount! < 1 || editingSugarAmount! > 35) {
          setErrorText("Please enter correct value between 1-35 mmol/L");
        } else {
          setErrorText("");
        }
      }
    }
  }
/////////////////////////////////////////////////////////////////

  final TextEditingController sugarAmountEditControllerEdit =
      TextEditingController();

  @computed
  bool get isButtonEnabled =>
      editingSugarAmount != null &&
      editingSugarAmount! >= 18 &&
      editingSugarAmount! <= 630;

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

  @observable
  bool? setCondition = true;
  @action
  activeNewCondition() {
    setCondition = !setCondition!;
  }
}
