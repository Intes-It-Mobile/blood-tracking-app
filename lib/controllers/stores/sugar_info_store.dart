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

  @action
  getRootSugarInfo(SugarInfo? fromSharepref) {
    rootSugarInfo = fromSharepref;
    listRootConditions = fromSharepref!.conditions;
  }
}
