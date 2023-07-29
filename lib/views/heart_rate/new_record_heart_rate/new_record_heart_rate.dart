import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/constants/font_family.dart';
import 'package:blood_sugar_tracking/models/heart_rate/heart_rate_info.dart';
import 'package:blood_sugar_tracking/utils/locale/appLocalizations.dart';
import 'package:blood_sugar_tracking/views/heart_rate/widgets/custom_datetime.dart';
import 'package:blood_sugar_tracking/views/heart_rate/widgets/show_dialog_custom.dart';
import 'package:blood_sugar_tracking/views/heart_rate/widgets/sort_heart_rate.dart';
import 'package:blood_sugar_tracking/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class NewRecordHeartRateScreen extends StatefulWidget {
  const NewRecordHeartRateScreen({super.key});

  @override
  State<NewRecordHeartRateScreen> createState() => _NewRecordHeartRateScreenState();
}

class _NewRecordHeartRateScreenState extends State<NewRecordHeartRateScreen> {
  HeartRateInfo? info;
  DateTime? date;
  late BuildContext context;
  bool checkError = false;
  bool checkEmpty = false;
  String? st;

  @override
  Widget build(BuildContext context) {
    info ??= ModalRoute.of(context)!.settings.arguments as HeartRateInfo;
    date ??= info!.date;
    this.context = context;
    return Scaffold(
      appBar: _buildAppBarCustom(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBarCustom() {
    return AppBar(
      toolbarHeight: 56,
      backgroundColor: AppColors.AppColor2,
      title: Text(
        AppLocalizations.of(context).getTranslate("new_record"),
        style: AppTheme.appBarTextStyle,
      ),
      titleSpacing: 0,
      leadingWidth: 48,
      leading: _buildButtonBack(),
    );
  }

  Widget _buildButtonBack() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: SvgPicture.asset(
        Assets.iconBack,
        height: 16,
        width: 20,
        fit: BoxFit.scaleDown,
      ),
    );
  }

  Widget _buildBody() {
    TextStyle textTitleStyle = TextStyle(color: AppColors.AppColor4, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: FontFamily.IBMPlexSans, fontStyle: FontStyle.normal, letterSpacing: 0.8);
    return Container(
      padding: const EdgeInsets.only(top: 26, left: 16, right: 16),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(
            AppLocalizations.of(context).getTranslate("date_and_time"),
            style: textTitleStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 20),
            child: CustomDatetime(
              date: date!,
              onChangedDate: (day) {
                setState(() {
                  date = DateTime(day.year, day.month, day.day, date!.hour, date!.minute);
                });
              },
              onChangedHour: (hour) {
                setState(() {
                  date = DateTime(date!.year, date!.month, date!.day, hour.hour, hour.minute);
                });
              },
            ),
          ),
          Text(
            AppLocalizations.of(context).getTranslate("heart_rate"),
            style: textTitleStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 10),
            child: SortHeartRate(
              indicator: info!.indicator,
              onChangedIndicator: (newValue) {
                st = newValue;
                if (newValue != "" && newValue != null){
                  int n = int.tryParse(newValue)??0;
                  info!.indicator = n;
                }
                setState(() {});
              },
            ),
          ),
          if (checkEmpty)
            Center(
              child: Text(
                AppLocalizations.of(context).getTranslate("enter_value"),
                style: AppTheme.errorText,
              ),
            ),
          if (!checkEmpty && checkError)
            Center(
              child: Text(
                AppLocalizations.of(context).getTranslate("errow_heart_rate_input_text"),
                style: AppTheme.errorText,
              ),
            ),
          _buildBtnSaveRecord(),
        ]),
      ),
    );
  }

  Widget _buildBtnSaveRecord() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 30),
      child: InkWell(
        onTap: () {
          checkEmpty = (st == "" || st == null);
          checkError = (info!.indicator < 1 || info!.indicator > 120);
          setState(() {});
          if (!checkError && !checkEmpty) {
            ShowDialogCustom().showDialogCustom(
              context: context,
              title: AppLocalizations.of(context).getTranslate('save_edit_dialog_content'),
              contentLeft: AppLocalizations.of(context).getTranslate('keep'),
              contentRight: AppLocalizations.of(context).getTranslate('change_btn'),
              onClickBtRight: () {
                Navigator.of(context).pop();
              },
              onClickBtnLeft: () {
                Navigator.of(context).pop();
              },
            );
          }
        },
        child: ButtonWidget(
          btnText: "save_record",
          btnColor: AppColors.AppColor4,
          mainAxisSizeMin: true,
        ),
      ),
    );
  }
}
