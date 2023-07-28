import 'package:blood_sugar_tracking/controllers/stores/edit_range_store.dart';
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
  String? conditionName;
  ChangeTargetDialog(
      {super.key, required this.conditionId, required this.conditionName});

  @override
  State<ChangeTargetDialog> createState() => _ChangeTargetDialogState();
}

class _ChangeTargetDialogState extends State<ChangeTargetDialog> {
  SugarInfoStore? sugarInfoStore;
  List<SugarAmount> tempCondition = [];
  EditRangeStore? editRangeStore;
  @override
  void didChangeDependencies() {
    editRangeStore = EditRangeStore();
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    sugarInfoStore!.getTempCondition(widget.conditionId!);
    editRangeStore!.tempConditionDisplay = sugarInfoStore!.tempConditionDisplay;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    tempCondition = sugarInfoStore!.tempConditionDisplay;

    return Container(
      child: AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 5 ),
        insetPadding: EdgeInsets.symmetric(horizontal: 7),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        content: StatefulBuilder(builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.38,
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.getTranslate(widget.conditionName!)}",
                    style: AppTheme.Headline16Text.copyWith(
                        color: AppColors.AppColor4),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                      runAlignment: WrapAlignment.spaceEvenly,
                      spacing: 25,
                      runSpacing: 10,
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
                                isLastItem: true,
                              ),
                            ]
                          : [Container()]),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (sugarInfoStore!.canSave() == false) {
                        showSnackbarOverlay(context,
                            "${AppLocalizations.of(context)!.getTranslate("err_correct_value")}");
                      } else if (sugarInfoStore!.canSave() == true) {
                        sugarInfoStore!.setNewRootCondition();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Container(
                      height: 35,
                      margin: const EdgeInsets.only(left: 50, right: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.AppColor2,
                      ),
                      child: Center(
                        child: Text(
                          '${AppLocalizations.of(context)!.getTranslate('save_changes_button')}',
                          style: AppTheme.TextIntroline16Text,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void showSnackbarOverlay(BuildContext context, String message) async {
    final overlay = Overlay.of(context);
    final opacityController = AnimationController(
      vsync: Navigator.of(context),
      duration: Duration(milliseconds: 200),
    );
    // Create an OverlayEntry for the Snackbar
    final overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: opacityController,
          builder: (context, child) {
            return Opacity(
              opacity: opacityController.value,
              child: snackbarContent(message),
            );
          },
        );
      },
    );

    overlay.insert(overlayEntry);

    await opacityController.forward();
    await Future.delayed(Duration(seconds: 2));
    await opacityController.reverse();

    overlayEntry.remove();
    opacityController.dispose();
  }

  List<Widget> builsListItem() {
    return sugarInfoStore!.tempConditionDisplay.map((e) {
      return EditRangeItem(
        id: e.id,
        maxValue: e.maxValue,
        minValue: e.minValue,
        status: e.status,
        onEdit: (value, id) {
          sugarInfoStore!.setMaxValue(value, id);
        },
      );
    }).toList();
  }
}

Widget snackbarContent(String message) {
  return Container(
    alignment: Alignment.bottomCenter,
    child: Card(
      margin: EdgeInsets.only(bottom: 65),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          message,
          style: AppTheme.appBodyTextStyle.copyWith(color: Colors.black),
        ),
      ),
    ),
  );
}
