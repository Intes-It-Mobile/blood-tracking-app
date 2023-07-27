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

  @override
  String toString() {
    return '''
tempConditionDisplay: ${tempConditionDisplay}
    ''';
  }
}
