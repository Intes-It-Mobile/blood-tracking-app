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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            Center(
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  height: 78,
                  child: Image.asset(
                    Assets.blood_test,
                    fit: BoxFit.fitHeight,
                  )),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(AppLocalizations.of(context)!.getTranslate('about_us_content')),
            )
          ]),
        ),
      ),
    );
  }
}
