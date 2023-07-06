import 'package:flutter/material.dart';

import '../../constants/app_theme.dart';
import '../../constants/colors.dart';
import '../../utils/locale/appLocalizations.dart';

class SelectUnit extends StatefulWidget {
  const SelectUnit({Key? key}) : super(key: key);

  @override
  State<SelectUnit> createState() => _SelectUnitState();
}

class _SelectUnitState extends State<SelectUnit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.AppColor1,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    '${AppLocalizations.of(context)!.getTranslate('select_your_starting_unit')}',
                    style: AppTheme.unit24Text),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  height: 44,
                  width: MediaQuery.of(context).size.width * 0.57,
                  decoration: BoxDecoration(
                    color: AppColors.AppColor2,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Center(
                    child: Text(
                      '${AppLocalizations.of(context)!.getTranslate('mg/dL')}',
                      style: AppTheme.Headline20Text.copyWith(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 44,
                  width: MediaQuery.of(context).size.width * 0.57,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Center(
                    child: Text(
                      '${AppLocalizations.of(context)!.getTranslate('mmol/L')}',
                      style: AppTheme.Headline20Text.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.AppColor2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 18,
            top: 30,
            child: Text(
              '${AppLocalizations.of(context)!.getTranslate('done')}',
              style: AppTheme.Headline20Text.copyWith(
                  fontWeight: FontWeight.w600, color: AppColors.AppColor4),
            ),
          ),
        ],
      ),
    );
  }
}
