import 'package:blood_sugar_tracking/controllers/stores/sugar_info_store.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../routes.dart';
import '../../utils/ads_helper.dart';
import '../../utils/ads_ios/ads.dart';
import '../../utils/locale/appLocalizations.dart';

class SelectUnit extends StatefulWidget {
  const SelectUnit({Key? key}) : super(key: key);

  @override
  State<SelectUnit> createState() => _SelectUnitState();
}

class _SelectUnitState extends State<SelectUnit> {
  SugarInfoStore? sugarInfoStore;

  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  bool? isMol = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.AppColor1,
      body: Stack(
        children: [
          Container(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          '${AppLocalizations.of(context)!.getTranslate('select_your_starting_unit')}',
                          textAlign: TextAlign.center,
                          style: AppTheme.unit24Text),
                      const SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isMol = true) {
                              isMol = false;
                            }
                          });
                        },
                        child: Container(
                          height: 44,
                          width: MediaQuery.of(context).size.width * 0.57,
                          decoration: BoxDecoration(
                            color: isMol == false
                                ? AppColors.AppColor2
                                : Colors.white,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Center(
                            child: Text(
                              '${AppLocalizations.of(context)!.getTranslate('mg/dL')}',
                              style: AppTheme.Headline20Text.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isMol == false
                                      ? Colors.white
                                      : AppColors.AppColor2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isMol == false) {
                            setState(() {
                              isMol = true;
                            });
                          }
                        },
                        child: Center(
                          child: Container(
                            height: 44,
                            width: MediaQuery.of(context).size.width * 0.57,
                            decoration: BoxDecoration(
                              color: isMol == true
                                  ? AppColors.AppColor2
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Center(
                              child: Text(
                                '${AppLocalizations.of(context)!.getTranslate('mmol/L')}',
                                style: AppTheme.Headline20Text.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isMol == true
                                        ? Colors.white
                                        : AppColors.AppColor2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: AdsNative(
                        templateType: TemplateType.medium,
                        unitId: AdHelper.nativeInAppAdUnitId,
                      )),
                )
              ],
            ),
          ),
          Positioned(
            right: 20,
            top: MediaQuery.of(context).size.height * 0.067,
            child: InkWell(
              onTap: () {
                // sugarInfoStore!.saveIsSwapedToMol(isMol!);
                // sugarInfoStore!.setSwapStatusToMol(isMol);
                sugarInfoStore!.setTempChooseUnitMol(isMol!);
                if (isMol == true) {
                  Navigator.of(context).pushNamed(Routes.goal_mmol_screen);
                } else if (isMol == false)
                  Navigator.of(context).pushNamed(Routes.goal_mg_screen);
              },
              child: Container(
                decoration: BoxDecoration(),
                child: Text(
                  '${AppLocalizations.of(context)!.getTranslate('next')}',
                  style: AppTheme.Headline20Text.copyWith(
                      fontWeight: FontWeight.w600, color: AppColors.AppColor4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
