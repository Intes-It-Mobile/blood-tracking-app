import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../constants/app_theme.dart';
import '../constants/colors.dart';
import '../controllers/stores/sugar_info_store.dart';
import '../utils/ads/mrec_ads.dart';
import '../utils/locale/appLocalizations.dart';

class ChageUnitDialog extends StatefulWidget {
  SugarInfoStore? sugarInfoStore;
  ChageUnitDialog({super.key, this.sugarInfoStore});

  @override
  State<ChageUnitDialog> createState() => _ChageUnitDialogState();
}

class _ChageUnitDialogState extends State<ChageUnitDialog> {
  SugarInfoStore? sugarInfoStore;
  bool? isChooseMol;
  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    isChooseMol = sugarInfoStore!.isSwapedToMol;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      content: StatefulBuilder(builder: (context, setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.49,
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppLocalizations.of(context)!.getTranslate('change_unit')}',
                style: AppTheme.hintText.copyWith(
                    color: AppColors.AppColor4, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        if (isChooseMol == true) {
                          setState(() {
                            isChooseMol = false;
                          });
                          // sugarInfoStore!.setSwapStatusToMol(false);
                          // sugarInfoStore!.swapUnit();
                        }
                      },
                      child: Observer(builder: (_) {
                        return Container(
                          height: 35,
                          decoration: BoxDecoration(
                              color: isChooseMol == false
                                  ? AppColors.AppColor3
                                  : Colors.white,
                              border: Border.all(color: AppColors.AppColor3),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              '${AppLocalizations.of(context)!.getTranslate('mg/dL')}',
                              style: AppTheme.unitText,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        if (isChooseMol == false) {
                          setState(() {
                            isChooseMol = true;
                          });
                        }
                      },
                      child: Observer(builder: (_) {
                        return Container(
                          height: 35,
                          decoration: BoxDecoration(
                              color: isChooseMol == true
                                  ? AppColors.AppColor3
                                  : Colors.white,
                              border: Border.all(color: AppColors.AppColor3),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              '${AppLocalizations.of(context)!.getTranslate('mmol/L')}',
                              style: AppTheme.unitText,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              InkWell(
                splashColor: Colors.white,
                onTap: () {
                  if (sugarInfoStore!.isSwapedToMol != isChooseMol) {
                    sugarInfoStore!.setSwapStatusToMol(isChooseMol);
                    sugarInfoStore!.swapUnit();
                  }
                  Navigator.of(context).pop();
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
                      '${AppLocalizations.of(context)!.getTranslate('change_btn')}',
                      style: AppTheme.TextIntroline16Text,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 55,),
              Center(child: const MRECAds())
            ],
          ),
        );
      }),
    );
  }
}
