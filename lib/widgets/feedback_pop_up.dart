import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/assets.dart';
import '../utils/locale/appLocalizations.dart';

class FeedbackPopUpWidget extends StatelessWidget {
  const FeedbackPopUpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        "${AppLocalizations.of(context)!.getTranslate('feedback_title')}",
                        style: AppTheme.Headline20Text.copyWith(
                            color: AppColors.AppColor4),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Container(
                  child: Text(
                    "${AppLocalizations.of(context)!.getTranslate('email_if_have')}",
                    style: AppTheme.appBodyTextStyle
                        .copyWith(color: AppColors.AppColor4),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.AppColor4),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText:
                          "${AppLocalizations.of(context)!.getTranslate('email_label_txt')}",
                      hintStyle: AppTheme.hintText,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 13)),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Container(
                  child: Text(
                    "${AppLocalizations.of(context)!.getTranslate('feedback_write_dwn')}",
                    style: AppTheme.appBodyTextStyle
                        .copyWith(color: AppColors.AppColor4),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.AppColor4),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText:
                          "${AppLocalizations.of(context)!.getTranslate('feedback_write_dwn_label_txt')}",
                      hintStyle: AppTheme.hintText,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 185)),
                ),
              ),
            ]),
          ),
          Positioned(
            right: 20,
            top: 16,
            child: SvgPicture.asset(
              Assets.iconX,
              color: AppColors.AppColor4,
              height: 20,
            ),
          )
        ],
      ),
    );
  }
}
