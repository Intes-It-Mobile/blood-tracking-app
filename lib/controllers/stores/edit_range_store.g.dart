// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_range_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EditRangeStore on _EditRangeStoreBase, Store {
  late final _$tempConditionDisplayAtom =
      Atom(name: '_EditRangeStoreBase.tempConditionDisplay', context: context);

  @override
  List<SugarAmount>? get tempConditionDisplay {
    _$tempConditionDisplayAtom.reportRead();
    return super.tempConditionDisplay;
  }

  @override
  set tempConditionDisplay(List<SugarAmount>? value) {
    _$tempConditionDisplayAtom.reportWrite(value, super.tempConditionDisplay,
        () {
      super.tempConditionDisplay = value;
    });
  }

  late final _$errorTextAtom =
      Atom(name: '_EditRangeStoreBase.errorText', context: context);

  @override
  String? get errorText {
    _$errorTextAtom.reportRead();
    return super.errorText;
  }

  @override
  set errorText(String? value) {
    _$errorTextAtom.reportWrite(value, super.errorText, () {
      super.errorText = value;
    });
  }

  late final _$canChangeAtom =
      Atom(name: '_EditRangeStoreBase.canChange', context: context);

  @override
  bool? get canChange {
    _$canChangeAtom.reportRead();
    return super.canChange;
  }

  @override
  set canChange(bool? value) {
    _$canChangeAtom.reportWrite(value, super.canChange, () {
      super.canChange = value;
    });
  }

  late final _$_EditRangeStoreBaseActionController =
      ActionController(name: '_EditRangeStoreBase', context: context);

  @override
  dynamic setMaxValue(String? value, int? id) {
    final _$actionInfo = _$_EditRangeStoreBaseActionController.startAction(
        name: '_EditRangeStoreBase.setMaxValue');
    try {
      return super.setMaxValue(value, id);
    } finally {
      _$_EditRangeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic checkValidate(String value, int id) {
    final _$actionInfo = _$_EditRangeStoreBaseActionController.startAction(
        name: '_EditRangeStoreBase.checkValidate');
    try {
      return super.checkValidate(value, id);
    } finally {
      _$_EditRangeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tempConditionDisplay: ${tempConditionDisplay},
errorText: ${errorText},
canChange: ${canChange}
    ''';
  }
}
