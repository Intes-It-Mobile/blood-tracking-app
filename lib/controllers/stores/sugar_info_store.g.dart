// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sugar_info_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SugarInfoStore on _SugarInfoStoreBase, Store {
  late final _$abcAtom =
      Atom(name: '_SugarInfoStoreBase.abc', context: context);

  @override
  int get abc {
    _$abcAtom.reportRead();
    return super.abc;
  }

  @override
  set abc(int value) {
    _$abcAtom.reportWrite(value, super.abc, () {
      super.abc = value;
    });
  }

  late final _$rootSugarInfoAtom =
      Atom(name: '_SugarInfoStoreBase.rootSugarInfo', context: context);

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

  late final _$listRootConditionsAtom =
      Atom(name: '_SugarInfoStoreBase.listRootConditions', context: context);

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

  late final _$_SugarInfoStoreBaseActionController =
      ActionController(name: '_SugarInfoStoreBase', context: context);

  @override
  dynamic getRootSugarInfo(SugarInfo? fromSharepref) {
    final _$actionInfo = _$_SugarInfoStoreBaseActionController.startAction(
        name: '_SugarInfoStoreBase.getRootSugarInfo');
    try {
      return super.getRootSugarInfo(fromSharepref);
    } finally {
      _$_SugarInfoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
abc: ${abc},
rootSugarInfo: ${rootSugarInfo},
listRootConditions: ${listRootConditions}
    ''';
  }
}
