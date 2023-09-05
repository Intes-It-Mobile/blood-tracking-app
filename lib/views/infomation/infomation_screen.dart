import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:applovin_max/applovin_max.dart';
import 'dart:math';

import '../../constants/config_ads_id.dart';
import '../../routes.dart';
import '../../utils/ads/mrec_ads.dart';
import '../../utils/locale/appLocalizations.dart';
import 'info_btn_widget.dart';

class InfomationScreen extends StatefulWidget {
  const InfomationScreen({super.key});

  @override
  State<InfomationScreen> createState() => _InfomationScreenState();
}

class _InfomationScreenState extends State<InfomationScreen> {




  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.AppColor2,
        title: Row(
          children: [
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
                SizedBox(
                  height: 7,
                ),
                InfoButtonWidget(
                  title: "info_title_1",
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.infoTitleScreen,
                        arguments: {"title": "info_title_1"});
                  },
                ),
                InfoButtonWidget(
                  title: "info_title_2",
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.infoTitleScreen,
                        arguments: {"title": "info_title_2"});
                  },
                ),
                Center(child: const MRECAds())
              ],
            ),
          )),
    );
  }
}
