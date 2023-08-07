import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../routes.dart';
import '../../utils/locale/appLocalizations.dart';
import 'info_btn_widget.dart';

class InfomationScreen extends StatefulWidget {
  const InfomationScreen({super.key});

  @override
  State<InfomationScreen> createState() => _InfomationScreenState();
}

class _InfomationScreenState extends State<InfomationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //  toolbarHeight: 80,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.AppColor2,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SvgPicture.asset(
                Assets.iconBack,
                height: 40,
                width: 40,
                fit: BoxFit.scaleDown,
              ),
            ),
            Container(
                child: Image.asset(
              Assets.infomative,
              height: 44,
            )),
            Container(
                margin: const EdgeInsets.only(left: 17),
                child: Text(
                  "${AppLocalizations.of(context)!.getTranslate('infor')}",
                  style: AppTheme.Headline20Text.copyWith(
                    letterSpacing: 2.0,
                  ),
                )),
          ],
        ),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            primary: true,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 16,
                  ),
                  child: Text(
                      "${AppLocalizations.of(context)!.getTranslate('info_title_1')}",
                      style: AppTheme.Headline16Text.copyWith(
                          color: AppColors.AppColor4)),
                ),
                InfoButtonWidget(
                  title: "bls_do",
                ),
                InfoButtonWidget(
                  title: "bls_low_what",
                ),
                InfoButtonWidget(
                  title: "bls_high_what",
                ),
                InfoButtonWidget(
                  title: "bls_monitor",
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 16,
                  ),
                  child: Text(
                      "${AppLocalizations.of(context)!.getTranslate('info_title_2')}",
                      style: AppTheme.Headline16Text.copyWith(
                          color: AppColors.AppColor4)),
                ),
                InfoButtonWidget(
                  title: "prv_know_diabets",
                ),
                InfoButtonWidget(
                  title: "prv_low_bls",
                ),
                InfoButtonWidget(
                  title: "prv_treat_low_bls",
                ),
                InfoButtonWidget(
                  title: "prv_change_type_2",
                ),
                InfoButtonWidget(
                  title: "prv_what_type_1",
                ),
                InfoButtonWidget(
                  title: "prv_what_type_2",
                ),
                InfoButtonWidget(
                  title: "prv_ges_dia",
                ),
              ],
            ),
          )),
    );
  }
}
