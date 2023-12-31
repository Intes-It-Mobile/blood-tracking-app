import 'package:blood_sugar_tracking/views/setting/language_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:provider/provider.dart';

import '../../constants/app_theme.dart';
import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../controllers/stores/sugar_info_store.dart';
import '../../routes.dart';
import '../../utils/dialog/dialog_feedback.dart';
import '../../utils/locale/appLocalizations.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/change_unit_dialog.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    super.key,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  SugarInfoStore? sugarInfoStore;

  Future<void> share() async {
    await FlutterShare.share(
      title: 'Blood Sugar Tracking',
      text: 'https://play.google.com/store/games',
    );
  }

  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    sugarInfoStore!.fetchGoalAmountFromSharedPreferences();
    super.didChangeDependencies();
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
                    margin: const EdgeInsets.only(left: 17),
                    child: Text(
                      "${AppLocalizations.of(context)!.getTranslate('setting')}",
                      style: AppTheme.Headline20Text,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(Routes.edit_range);
              },
              child: Container(
                height: 32,
                width: 32,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: const BoxDecoration(
                    color: AppColors.mainBgColor,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: SvgPicture.asset(Assets.iconEditRangeScreen),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(Routes.record_remind);
              },
              child: Container(
                height: 32,
                width: 32,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: const BoxDecoration(
                    color: AppColors.mainBgColor,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: SvgPicture.asset(Assets.iconAlarm),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 19),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ButtonWidget(
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.languages);
                    },
                    btnColor: AppColors.AppColor2,
                    btnText: "languages",

                  ),
                  ButtonWidget(
                    onTap: () {
                      sugarInfoStore!.exportToExcel(context);
                    },
                    btnColor: AppColors.AppColor2,
                    btnText: "export_data",
                  ),
                  ButtonWidget(
                    onTap: () {
                      // sugarInfoStore!.swapUnit();
                      showDiaLogUnit(sugarInfoStore!, context);
                    },
                    btnColor: AppColors.AppColor2,
                    btnText: "change_unit",
                  ),
                  ButtonWidget(
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.personal_data);
                    },
                    btnColor: AppColors.AppColor2,
                    btnText: "personal_data",
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
                          return const DialogFeedback();
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

Future<String?> showDiaLogUnit(
  SugarInfoStore store,
  BuildContext context,
) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => ChageUnitDialog(sugarInfoStore: store),
  );
}
