import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../controllers/stores/sugar_info_store.dart';
import '../../models/sugar_info/sugar_info.dart';
import '../../utils/locale/appLocalizations.dart';
import 'edit_range_item.dart';

class ChangeTargetDialog extends StatefulWidget {
  int? conditionId;
  ChangeTargetDialog({super.key, required this.conditionId});

  @override
  State<ChangeTargetDialog> createState() => _ChangeTargetDialogState();
}

class _ChangeTargetDialogState extends State<ChangeTargetDialog> {
  SugarInfoStore? sugarInfoStore;
  List<SugarAmount> tempCondition = [];
  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    sugarInfoStore!.getTempCondition(widget.conditionId!);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    tempCondition = sugarInfoStore!.tempConditionDisplay;

    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      content: StatefulBuilder(builder: (context, setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Before exercise",
                  style: AppTheme.Headline16Text.copyWith(
                      color: AppColors.AppColor4),
                ),
                Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: sugarInfoStore!.listRootConditions!.isNotEmpty
                        ? [
                            EditRangeItem(
                                id: tempCondition[0].id,
                                maxValue: tempCondition[0].maxValue,
                                status: tempCondition[0].status,
                                minValue: tempCondition[0].minValue),
                            EditRangeItem(
                                id: tempCondition[1].id,
                                maxValue: tempCondition[1].maxValue,
                                status: tempCondition[1].status,
                                minValue: tempCondition[0].maxValue),
                            EditRangeItem(
                                id: tempCondition[2].id,
                                maxValue: tempCondition[2].maxValue,
                                status: tempCondition[2].status,
                                minValue: tempCondition[1].maxValue),
                            EditRangeItem(
                              id: tempCondition[3].id,
                              maxValue: tempCondition[3].maxValue,
                              status: tempCondition[3].status,
                              minValue: tempCondition[2].maxValue,
                            ),
                          ]
                        : [Container()]),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 35,
                  margin: const EdgeInsets.only(left: 50, right: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.AppColor2,
                  ),
                  child: Center(
                    child: Text(
                      '${AppLocalizations.of(context)!.getTranslate('choose_this_unit')}',
                      style: AppTheme.TextIntroline16Text,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  List<Widget> builsListItem() {
    return sugarInfoStore!.tempConditionDisplay.map((e) {
      return EditRangeItem(
        id: e.id,
        maxValue: e.maxValue,
        minValue: e.minValue,
        // conditionName: ,
        status: e.status,
      );
    }).toList();
  }
}
