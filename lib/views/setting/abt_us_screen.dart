import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
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
                      margin: EdgeInsets.only(right: 12),
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
        height: double.infinity,
        width: double.infinity,
        child: Column(children: [
          Center(
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                height: 78,
                child: Image.asset(
                  Assets.about_us,
                  fit: BoxFit.fitHeight,
                )),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(AppLocalizations.of(context)!
                .getTranslate('about_us_content'), style: AppTheme.hintText.copyWith(fontWeight: FontWeight.w400,fontSize: 12, color: Colors.black),),
          ),
          Spacer(),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: AppLocalizations.of(context)!
                    .getTranslate('app_name'), style: AppTheme.hintText.copyWith(fontWeight: FontWeight.w700,fontSize: 12, color: AppColors.AppColor2),),
                TextSpan(
                  text: AppLocalizations.of(context)!
                      .getTranslate('version'),
                  style: AppTheme.hintText.copyWith(fontWeight: FontWeight.w400,fontSize: 12, color: Colors.black),
                ),
                TextSpan(
                  text: AppLocalizations.of(context)!
                      .getTranslate('1.0.0'),
                  style: AppTheme.hintText.copyWith(fontWeight: FontWeight.bold,fontSize: 12, color: Colors.black),
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
          )
        ]),
      ),
    );
  }
}
