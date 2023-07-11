// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_record_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EditRecordStore on _EditRecordStoreBase, Store {
  Computed<bool>? _$isButtonEnabledComputed;

  @override
  bool get isButtonEnabled =>
      (_$isButtonEnabledComputed ??= Computed<bool>(() => super.isButtonEnabled,
              name: '_EditRecordStoreBase.isButtonEnabled'))
          .value;
  Computed<bool>? _$isButtonEnabledEditComputed;

  @override
  bool get isButtonEnabledEdit => (_$isButtonEnabledEditComputed ??=
          Computed<bool>(() => super.isButtonEnabledEdit,
              name: '_EditRecordStoreBase.isButtonEnabledEdit'))
      .value;

  late final _$editingDayTimeAtom =
      Atom(name: '_EditRecordStoreBase.editingDayTime', context: context);

  @override
  DateTime? get editingDayTime {
    _$editingDayTimeAtom.reportRead();
    return super.editingDayTime;
  }

  @override
  set editingDayTime(DateTime? value) {
    _$editingDayTimeAtom.reportWrite(value, super.editingDayTime, () {
      super.editingDayTime = value;
    });
  }

  late final _$editingHourTimeAtom =
      Atom(name: '_EditRecordStoreBase.editingHourTime', context: context);

  @override
  DateTime? get editingHourTime {
    _$editingHourTimeAtom.reportRead();
    return super.editingHourTime;
  }

  @override
  set editingHourTime(DateTime? value) {
    _$editingHourTimeAtom.reportWrite(value, super.editingHourTime, () {
      super.editingHourTime = value;
    });
  }

  late final _$editingDayTimeStrAtom =
      Atom(name: '_EditRecordStoreBase.editingDayTimeStr', context: context);

  @override
  String? get editingDayTimeStr {
    _$editingDayTimeStrAtom.reportRead();
    return super.editingDayTimeStr;
  }

  @override
  set editingDayTimeStr(String? value) {
    _$editingDayTimeStrAtom.reportWrite(value, super.editingDayTimeStr, () {
      super.editingDayTimeStr = value;
    });
  }

  late final _$editingHourTimeStrAtom =
      Atom(name: '_EditRecordStoreBase.editingHourTimeStr', context: context);

  @override
  String? get editingHourTimeStr {
    _$editingHourTimeStrAtom.reportRead();
    return super.editingHourTimeStr;
  }

  @override
  set editingHourTimeStr(String? value) {
    _$editingHourTimeStrAtom.reportWrite(value, super.editingHourTimeStr, () {
      super.editingHourTimeStr = value;
    });
  }

  late final _$editingSugarAmountAtom =
      Atom(name: '_EditRecordStoreBase.editingSugarAmount', context: context);

  @override
  double? get editingSugarAmount {
    _$editingSugarAmountAtom.reportRead();
    return super.editingSugarAmount;
  }

  @override
  set editingSugarAmount(double? value) {
    _$editingSugarAmountAtom.reportWrite(value, super.editingSugarAmount, () {
      super.editingSugarAmount = value;
    });
  }

  late final _$conditionIdAtom =
      Atom(name: '_EditRecordStoreBase.conditionId', context: context);

  @override
  int? get conditionId {
    _$conditionIdAtom.reportRead();
    return super.conditionId;
  }

  @override
  set conditionId(int? value) {
    _$conditionIdAtom.reportWrite(value, super.conditionId, () {
      super.conditionId = value;
    });
  }

  late final _$recordIdAtom =
      Atom(name: '_EditRecordStoreBase.recordId', context: context);

  @override
  int? get recordId {
    _$recordIdAtom.reportRead();
    return super.recordId;
  }

  @override
  set recordId(int? value) {
    _$recordIdAtom.reportWrite(value, super.recordId, () {
      super.recordId = value;
    });
  }

  late final _$currentEditStatusAtom =
      Atom(name: '_EditRecordStoreBase.currentEditStatus', context: context);

  @override
  String? get currentEditStatus {
    _$currentEditStatusAtom.reportRead();
    return super.currentEditStatus;
  }

  @override
  set currentEditStatus(String? value) {
    _$currentEditStatusAtom.reportWrite(value, super.currentEditStatus, () {
      super.currentEditStatus = value;
    });
  }

  late final _$editStatusAtom =
      Atom(name: '_EditRecordStoreBase.editStatus', context: context);

  @override
  String? get editStatus {
    _$editStatusAtom.reportRead();
    return super.editStatus;
  }

  @override
  set editStatus(String? value) {
    _$editStatusAtom.reportWrite(value, super.editStatus, () {
      super.editStatus = value;
    });
  }

  late final _$editChooseConditionAtom =
      Atom(name: '_EditRecordStoreBase.editChooseCondition', context: context);

  @override
  Conditions? get editChooseCondition {
    _$editChooseConditionAtom.reportRead();
    return super.editChooseCondition;
  }

  @override
  set editChooseCondition(Conditions? value) {
    _$editChooseConditionAtom.reportWrite(value, super.editChooseCondition, () {
      super.editChooseCondition = value;
    });
  }

  late final _$listRootConditionsAtom =
      Atom(name: '_EditRecordStoreBase.listRootConditions', context: context);

  @override
  List<Conditions>? get listRootConditions {
    _$listRootConditionsAtom.reportRead();
    return super.listRootConditions;
  }

  @override
  set listRootConditions(List<Conditions>? value) {
    _$listRootConditionsAtom.reportWrite(value, super.listRootConditions, () {
      super.listRootConditions = value;
    });
  }

  late final _$rootSugarInfoAtom =
      Atom(name: '_EditRecordStoreBase.rootSugarInfo', context: context);

  @override
  SugarInfo? get rootSugarInfo {
    _$rootSugarInfoAtom.reportRead();
    return super.rootSugarInfo;
  }

  @override
  set rootSugarInfo(SugarInfo? value) {
    _$rootSugarInfoAtom.reportWrite(value, super.rootSugarInfo, () {
      super.rootSugarInfo = value;
    });
  }

  late final _$editStatusLevelAtom =
      Atom(name: '_EditRecordStoreBase.editStatusLevel', context: context);

  @override
  int? get editStatusLevel {
    _$editStatusLevelAtom.reportRead();
    return super.editStatusLevel;
  }

  @override
  set editStatusLevel(int? value) {
    _$editStatusLevelAtom.reportWrite(value, super.editStatusLevel, () {
      super.editStatusLevel = value;
    });
  }

  late final _$isSwapedToMolAtom =
      Atom(name: '_EditRecordStoreBase.isSwapedToMol', context: context);

  @override
  bool? get isSwapedToMol {
    _$isSwapedToMolAtom.reportRead();
    return super.isSwapedToMol;
  }

  @override
  set isSwapedToMol(bool? value) {
    _$isSwapedToMolAtom.reportWrite(value, super.isSwapedToMol, () {
      super.isSwapedToMol = value;
    });
  }

  late final _$sugarAmountEditAtom =
      Atom(name: '_EditRecordStoreBase.sugarAmountEdit', context: context);

  @override
  String get sugarAmountEdit {
    _$sugarAmountEditAtom.reportRead();
    return super.sugarAmountEdit;
  }

  @override
  set sugarAmountEdit(String value) {
    _$sugarAmountEditAtom.reportWrite(value, super.sugarAmountEdit, () {
      super.sugarAmountEdit = value;
    });
  }

  late final _$tempSugarAmountEditAtom =
      Atom(name: '_EditRecordStoreBase.tempSugarAmountEdit', context: context);

  @override
  String? get tempSugarAmountEdit {
    _$tempSugarAmountEditAtom.reportRead();
    return super.tempSugarAmountEdit;
  }

  @override
  set tempSugarAmountEdit(String? value) {
    _$tempSugarAmountEditAtom.reportWrite(value, super.tempSugarAmountEdit, () {
      super.tempSugarAmountEdit = value;
    });
  }

  late final _$setConditionAtom =
      Atom(name: '_EditRecordStoreBase.setCondition', context: context);

  @override
  bool? get setCondition {
    _$setConditionAtom.reportRead();
    return super.setCondition;
  }

  @override
  set setCondition(bool? value) {
    _$setConditionAtom.reportWrite(value, super.setCondition, () {
      super.setCondition = value;
    });
  }

  late final _$_EditRecordStoreBaseActionController =
      ActionController(name: '_EditRecordStoreBase', context: context);

  @override
  dynamic getRootSugarInfo(List<Conditions> editChooseCondition) {
    final _$actionInfo = _$_EditRecordStoreBaseActionController.startAction(
        name: '_EditRecordStoreBase.getRootSugarInfo');
    try {
      return super.getRootSugarInfo(editChooseCondition);
    } finally {
      _$_EditRecordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setEditChooseCondition(int eDitchooseId) {
    final _$actionInfo = _$_EditRecordStoreBaseActionController.startAction(
        name: '_EditRecordStoreBase.setEditChooseCondition');
    try {
      return super.setEditChooseCondition(eDitchooseId);
    } finally {
      _$_EditRecordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setEditInputSugarAmount(double inputAmount) {
    final _$actionInfo = _$_EditRecordStoreBaseActionController.startAction(
        name: '_EditRecordStoreBase.setEditInputSugarAmount');
    try {
      return super.setEditInputSugarAmount(inputAmount);
    } finally {
      _$_EditRecordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCurrentEditAmount(double inputAmount) {
    final _$actionInfo = _$_EditRecordStoreBaseActionController.startAction(
        name: '_EditRecordStoreBase.setCurrentEditAmount');
    try {
      return super.setCurrentEditAmount(inputAmount);
    } finally {
      _$_EditRecordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCurrentEditStatus(double inputAmount) {
    final _$actionInfo = _$_EditRecordStoreBaseActionController.startAction(
        name: '_EditRecordStoreBase.setCurrentEditStatus');
    try {
      return super.setCurrentEditStatus(inputAmount);
    } finally {
      _$_EditRecordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setEditStatusLevel(String? currentEditStatus) {
    final _$actionInfo = _$_EditRecordStoreBaseActionController.startAction(
        name: '_EditRecordStoreBase.setEditStatusLevel');
    try {
      return super.setEditStatusLevel(currentEditStatus);
    } finally {
      _$_EditRecordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setEditedDayTime(DateTime dayTime) {
    final _$actionInfo = _$_EditRecordStoreBaseActionController.startAction(
        name: '_EditRecordStoreBase.setEditedDayTime');
    try {
      return super.setEditedDayTime(dayTime);
    } finally {
      _$_EditRecordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setEditedHourTime(DateTime hourTime) {
    final _$actionInfo = _$_EditRecordStoreBaseActionController.startAction(
        name: '_EditRecordStoreBase.setEditedHourTime');
    try {
      return super.setEditedHourTime(hourTime);
    } finally {
      _$_EditRecordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setErrorText(String errorMessage) {
    final _$actionInfo = _$_EditRecordStoreBaseActionController.startAction(
        name: '_EditRecordStoreBase.setErrorText');
    try {
      return super.setErrorText(errorMessage);
    } finally {
      _$_EditRecordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic checkValidateEditRecord(double value) {
    final _$actionInfo = _$_EditRecordStoreBaseActionController.startAction(
        name: '_EditRecordStoreBase.checkValidateEditRecord');
    try {
      return super.checkValidateEditRecord(value);
    } finally {
      _$_EditRecordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSugarAmountEdit(String value) {
    final _$actionInfo = _$_EditRecordStoreBaseActionController.startAction(
        name: '_EditRecordStoreBase.setSugarAmountEdit');
    try {
      return super.setSugarAmountEdit(value);
    } finally {
      _$_EditRecordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateSugarAmountEdit() {
    final _$actionInfo = _$_EditRecordStoreBaseActionController.startAction(
        name: '_EditRecordStoreBase.validateSugarAmountEdit');
    try {
      return super.validateSugarAmountEdit();
    } finally {
      _$_EditRecordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetSugarAmountEdit() {
    final _$actionInfo = _$_EditRecordStoreBaseActionController.startAction(
        name: '_EditRecordStoreBase.resetSugarAmountEdit');
    try {
      return super.resetSugarAmountEdit();
    } finally {
      _$_EditRecordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic activeNewCondition() {
    final _$actionInfo = _$_EditRecordStoreBaseActionController.startAction(
        name: '_EditRecordStoreBase.activeNewCondition');
    try {
      return super.activeNewCondition();
    } finally {
      _$_EditRecordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
editingDayTime: ${editingDayTime},
editingHourTime: ${editingHourTime},
editingDayTimeStr: ${editingDayTimeStr},
editingHourTimeStr: ${editingHourTimeStr},
editingSugarAmount: ${editingSugarAmount},
conditionId: ${conditionId},
recordId: ${recordId},
currentEditStatus: ${currentEditStatus},
editStatus: ${editStatus},
editChooseCondition: ${editChooseCondition},
listRootConditions: ${listRootConditions},
rootSugarInfo: ${rootSugarInfo},
editStatusLevel: ${editStatusLevel},
isSwapedToMol: ${isSwapedToMol},
sugarAmountEdit: ${sugarAmountEdit},
tempSugarAmountEdit: ${tempSugarAmountEdit},
setCondition: ${setCondition},
isButtonEnabled: ${isButtonEnabled},
isButtonEnabledEdit: ${isButtonEnabledEdit}
    ''';
  }
}
