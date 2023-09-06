import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/config_ads_id.dart';
import '../../routes.dart';
import '../../utils/ads/applovin_function.dart';
import '../../utils/ads_handle.dart';
import '../../utils/locale/appLocalizations.dart';
import 'info_btn_widget.dart';

class InfomationTitleScreen extends StatefulWidget {
  const InfomationTitleScreen({super.key});

  @override
  State<InfomationTitleScreen> createState() => _InfomationTitleScreenState();
}

class _InfomationTitleScreenState extends State<InfomationTitleScreen> {
  String? title;
  List<String>? listChildTitle = [];
  @override
  void initState() {
    AppLovinFunction().initializeInterstitialAds();
    // AppOpenAdManager()
    //   ..loadAd()
    //   ..showAdIfAvailable();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    if (arguments != null) {
      title = arguments['title'];
      getListChildTitle(title!);
    }
    super.didChangeDependencies();
  }

  getListChildTitle(String value) {
    switch (value) {
      case "info_title_1":
        listChildTitle = ["bls_do", "bls_low_what", "bls_high_what", "bls_monitor"];
        break;
      case "info_title_2":
        listChildTitle = [
          "prv_know_diabets",
          "prv_low_bls",
          "prv_treat_low_bls",
          "prv_change_type_2",
          "prv_what_type_1",
          "prv_what_type_2",
          "prv_ges_dia",
        ];
        break;
      default:
    }
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
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                margin: EdgeInsets.only(right: 12),
                child: SvgPicture.asset(
                  Assets.iconBack,
                  height: 40,
                  width: 40,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 17),
                  child: Text(
                    "${AppLocalizations.of(context)!.getTranslate(title!)}",
                    style: AppTheme.Headline20Text.copyWith(
                      letterSpacing: 2.0,
                    ),
                  )),
            ),
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
                Column(
                  children: getListChildWidget(),
                )
              ],
            ),
          )),
    );
  }

  List<Widget> getListChildWidget() {
    return listChildTitle!.asMap().entries.map((entry) {
      int index = entry.key;
      String title = entry.value;
      return InfoButtonWidget(title: title);
    }).toList();
  }
}
