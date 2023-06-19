// ignore_for_file: prefer_const_constructors

import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../routes.dart';
import '../../utils/locale/appLocalizations.dart';

class TopWidgetHomeContent extends StatefulWidget {
  const TopWidgetHomeContent({super.key});

  @override
  State<TopWidgetHomeContent> createState() => _TopWidgetHomeContentState();
}

class _TopWidgetHomeContentState extends State<TopWidgetHomeContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 25, 15, 0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      child: SvgPicture.asset(Assets.iconRedCross),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context)!.getTranslate('app_name'),
                        style: AppTheme.Headline20Text,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.mainBgColor, borderRadius: BorderRadius.all(Radius.circular(5))),
                        padding: EdgeInsets.all(6),
                        child: SvgPicture.asset(
                          Assets.iconAlarm,
                          height: 20,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.history);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.mainBgColor, borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(5.5, 8, 7, 8),
                          child: SvgPicture.asset(
                            Assets.iconHistory,
                            height: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      color: AppColors.mainBgColor,
                    ),
                    child: Row(children: [
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Text(
                          AppLocalizations.of(context)!.getTranslate('default_txt'),
                          style: TextStyle(color: AppColors.AppColor4),
                        ),
                      ),
                      SvgPicture.asset(Assets.iconType)
                    ]),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
