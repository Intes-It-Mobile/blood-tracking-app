import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_share/flutter_share.dart';

import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../routes.dart';
import '../../utils/dialog/dialog_modal.dart';
import '../../utils/locale/appLocalizations.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/feedback_pop_up.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Future<void> share() async {
    await FlutterShare.share(
      title: 'Blood Sugar Tracking',
      text: 'https://play.google.com/store/games',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppColors.AppColor2,
        title: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                      child: Image.asset(
                    Assets.settings,
                    height: 44,
                  )),
                  Container(
                    margin: EdgeInsets.only(left: 17),
                    child: Text(
                      "${AppLocalizations.of(context)!.getTranslate('setting')}",
                      style: AppTheme.Headline20Text,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pushNamed(Routes.edit_range);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                padding: EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                decoration: BoxDecoration(
                    color: AppColors.mainBgColor,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: SvgPicture.asset(Assets.iconInfoBook),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pushNamed(Routes.record_remind);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                    color: AppColors.mainBgColor,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: SvgPicture.asset(Assets.iconAlarm),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: SvgPicture.asset(Assets.iconSwapUnit))
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 19),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ButtonWidget(
                    onTap: () {
                      share();
                    },
                    btnColor: AppColors.AppColor2,
                    btnText: "export_data",
                  ),
                  ButtonWidget(
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.abt_us);
                    },
                    btnColor: AppColors.AppColor2,
                    btnText: "about_us",
                  ),
                  ButtonWidget(
                    onTap: () {
                      share();
                    },
                    btnColor: AppColors.AppColor2,
                    btnText: "share_app",
                  ),
                  ButtonWidget(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return DialogFeedback();
                        },
                      );
                    },
                    btnColor: AppColors.AppColor2,
                    btnText: "send_feedback",
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
