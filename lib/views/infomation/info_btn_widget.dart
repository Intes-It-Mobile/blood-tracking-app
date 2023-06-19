import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../routes.dart';
import '../../utils/locale/appLocalizations.dart';

class InfoButtonWidget extends StatelessWidget {
  String? title;

  InfoButtonWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    String? getTitle(String? value) {
      return AppLocalizations.of(context)!.getTranslate('${value}');
    }

    String? getImagePath(String? value) {
      switch (value) {
        case 'bls_do':
          return Assets.blood_test;
        case 'bls_low_what':
          return Assets.low_energy;
        case 'bls_high_what':
          return Assets.high_temperature;
        case 'bls_monitor':
          return Assets.forehead;
        case 'prv_know_diabets':
          return Assets.open_book;
        case 'prv_low_bls':
          return Assets.low_performance;
        case 'prv_treat_low_bls':
          return Assets.infomation;
        case 'prv_change_type_2':
          return Assets.prevention;
        case 'prv_what_type_1':
          return Assets.diabetes_1;
        case 'prv_what_type_2':
          return Assets.diabetes_2;
        case 'prv_ges_dia':
          return Assets.gestational_diabetes;
        default:
          throw RangeError("");
      }
    }

    Color? getBtnColor(String? value) {
      switch (value) {
        case 'bls_do':
          return AppColors.infoBtnColor1;
        case 'bls_low_what':
          return AppColors.infoBtnColor2;
        case 'bls_high_what':
          return AppColors.infoBtnColor3;
        case 'bls_monitor':
          return AppColors.infoBtnColor4;
        case 'prv_know_diabets':
          return AppColors.infoBtnColor5;
        case 'prv_low_bls':
          return AppColors.infoBtnColor6;
        case 'prv_treat_low_bls':
          return AppColors.infoBtnColor7;
        case 'prv_change_type_2':
          return AppColors.infoBtnColor8;
        case 'prv_what_type_1':
          return AppColors.infoBtnColor9;
        case 'prv_what_type_2':
          return AppColors.infoBtnColor10;
        case 'prv_ges_dia':
          return AppColors.infoBtnColor11;
        default:
          throw RangeError("");
      }
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.detail_info,arguments: {"type":title});
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.fromLTRB(15, 11, 20, 11),
        decoration: BoxDecoration(
            color: getBtnColor(title),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Image.asset(
                    "${getImagePath(title)}",
                    height: 42,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text("${getTitle(title)}",
                        style: AppTheme.appBodyTextStyle
                            .copyWith(color: Colors.black)),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 65,
            ),
            SvgPicture.asset(Assets.iconArrowInfoBtn)
          ],
        ),
      ),
    );
  }
}
