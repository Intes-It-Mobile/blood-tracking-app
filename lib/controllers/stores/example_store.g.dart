// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ExampleStore on _ExampleStoreBase, Store {
  late final _$abcAtom = Atom(name: '_ExampleStoreBase.abc', context: context);

  @override
  int? get abc {
    _$abcAtom.reportRead();
    return super.abc;
  }

  @override
  set abc(int? value) {
    _$abcAtom.reportWrite(value, super.abc, () {
      super.abc = value;
    });
  }

  @override
  String toString() {
    return '''
abc: ${abc}
    ''';
  }
}
