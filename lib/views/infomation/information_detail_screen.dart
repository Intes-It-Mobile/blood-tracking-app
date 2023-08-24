import 'package:blood_sugar_tracking/constants/font_family.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_html_v3/flutter_html.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../utils/ads/applovin_function.dart';
import '../../utils/locale/appLocalizations.dart';

class DetailInformationScreen extends StatefulWidget {
  DetailInformationScreen({
    super.key,
  });

  @override
  State<DetailInformationScreen> createState() =>
      _DetailInformationScreenState();
}

class _DetailInformationScreenState extends State<DetailInformationScreen> {
  String? type;

  @override
  void initState() {
    AppLovinFunction().initializeInterstitialAds();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    if (arguments != null) {
      type = arguments['type'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        backgroundColor: AppColors.AppColor2,
        title: Container(
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      AppLovinFunction().showInterstitialAds();
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
                    child: Text(
                      "${AppLocalizations.of(context)!.getTranslate('${type}')}",
                      style: AppTheme.Headline20Text,
                      overflow: TextOverflow
                          .ellipsis, // Hiển thị dấu chấm ba khi có tràn
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            Center(
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  height: 78,
                  child: Image.asset(
                    "${getImagePath(type)}",
                    fit: BoxFit.fitHeight,
                  )),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Html(
                data: """
                        ${getContent(type)}
                      """,
                style: {
                  'p': Style(
                      textAlign: TextAlign.justify,
                      fontFamily: FontFamily
                          .IBMPlexSans), // Áp dụng một style cho thẻ <p>
                  'strong': Style(
                      fontWeight: FontWeight.bold,
                      fontFamily: FontFamily
                          .IBMPlexSans), // Áp dụng một style cho thẻ <strong>
                },
              ),
              // child:

              //  HtmlWidget(
              //   "${getContent(type)}",
              //   textStyle: AppTheme.appBodyTextStyle.copyWith(
              //       color: Colors.black,
              //       fontWeight: FontWeight.w400,
              //       fontSize: 16,),
              // )
            )
          ]),
        ),
      ),
    );
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

  String? getContent(String? value) {
    switch (value) {
      case 'bls_do':
        return AppLocalizations.of(context)!.getTranslate('bls_do_asw');
      case 'bls_low_what':
        return AppLocalizations.of(context)!.getTranslate('bls_low_what_asw');
      case 'bls_high_what':
        return AppLocalizations.of(context)!.getTranslate('bls_high_what_asw');
      case 'bls_monitor':
        return AppLocalizations.of(context)!.getTranslate('bls_monitor_asw');
      case 'prv_know_diabets':
        return AppLocalizations.of(context)!
            .getTranslate('prv_know_diabets_asw');
      case 'prv_low_bls':
        return AppLocalizations.of(context)!.getTranslate('prv_low_bls_asw');
      case 'prv_treat_low_bls':
        return AppLocalizations.of(context)!
            .getTranslate('prv_treat_low_bls_asw');
      case 'prv_change_type_2':
        return AppLocalizations.of(context)!
            .getTranslate('prv_change_type_2_asw');
      case 'prv_what_type_1':
        return AppLocalizations.of(context)!
            .getTranslate('prv_what_type_1_asw');
      case 'prv_what_type_2':
        return AppLocalizations.of(context)!
            .getTranslate('prv_what_type_2_asw');
      case 'prv_ges_dia':
        return AppLocalizations.of(context)!.getTranslate('prv_ges_dia_asw');
      default:
        throw RangeError("");
    }
  }
}
