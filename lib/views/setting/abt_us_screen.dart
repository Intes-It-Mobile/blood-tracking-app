import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/config_ads_id.dart';
import '../../utils/ads/mrec_ads.dart';
import '../../utils/ads_handle.dart';
import '../../utils/ads_helper.dart';
import '../../utils/ads_ios/ads.dart';
import '../../utils/locale/appLocalizations.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: SvgPicture.asset(
                        Assets.iconX,
                        height: 24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${AppLocalizations.of(context)!.getTranslate('about_us')}",
                      style: AppTheme.Headline20Text,
                      overflow: TextOverflow.ellipsis, // Hiển thị dấu chấm ba khi có tràn
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
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.start ,children: [
            Center(
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  height: 78,
                  child: Image.asset(
                    Assets.about_us,
                    fit: BoxFit.fitHeight,
                  )),
            ),
            const SizedBox(
              height: 8,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${AppLocalizations.of(context)!.getTranslate('app_name_about_us')}',
                    style: AppTheme.hintText
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.AppColor2),
                  ),
                  TextSpan(
                    text: '${AppLocalizations.of(context)!.getTranslate('version')}',
                    style: AppTheme.hintText.copyWith(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black),
                  ),
                  TextSpan(
                    text: '${AppLocalizations.of(context)!.getTranslate('1.0.0')}',
                    style: AppTheme.hintText.copyWith(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
                  )
                ],
              ),
            ),
            
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppLocalizations.of(context)!.getTranslate('about_us_content'),
                style: AppTheme.hintText.copyWith(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black),
                textAlign: TextAlign.justify,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                // padding: const EdgeInsets.all(8),
                child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: AdsNative(
                        templateType: TemplateType.medium,
                        unitId: AdHelper.nativeInAppAdUnitId,
                      )),
                ),
              ),
            ),
           
          ]),
        ),
      ),
    );
  }
}
