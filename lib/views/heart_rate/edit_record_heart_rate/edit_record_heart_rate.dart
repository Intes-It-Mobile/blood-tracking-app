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

class EditRecordHeartRateScreen extends StatelessWidget {
  EditRecordHeartRateScreen({super.key});
  late HeartRateInfo info;
  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    info = ModalRoute.of(context)!.settings.arguments as HeartRateInfo;
    this.context = context;
    return Scaffold(
      appBar: _buildAppBarCustom(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBarCustom(){ 
    return AppBar(
      toolbarHeight: 56,
      backgroundColor: AppColors.AppColor2,
      title: Text(
        AppLocalizations.of(context).getTranslate("edit_record"),
        style: AppTheme.appBarTextStyle,
      ),
      titleSpacing: 0,
      leadingWidth : 48,
      leading: _buildButtonBack(),
      actions: [
        _buildButtonDelete()
      ],
    );
  }

  Widget _buildButtonBack() {
    return InkWell(
      onTap:() {
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

  Widget _buildButtonDelete() {
    return InkWell(
      onTap:() {
        ShowDialogCustom().showDialogCustom(
          context: context,
          title: AppLocalizations.of(context).getTranslate('delete_record_alert'),
          contentLeft: AppLocalizations.of(context).getTranslate('delete'),
          contentRight: AppLocalizations.of(context).getTranslate('keep'),
          onClickBtRight: (){
            Navigator.of(context).pop();
          },
          onClickBtnLeft: () {
            Navigator.of(context).pop();
          },
        );
      },
      child: Container(
          height: 32,
          width: 32,
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5)
          ),
          child: SvgPicture.asset(Assets.iconDelete),
        ),
    );
  }

  Widget _buildBody(){
    TextStyle textTitleStyle = TextStyle(
      color: AppColors.AppColor4,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: FontFamily.IBMPlexSans,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.8
    );
    return Container(
      padding: const EdgeInsets.only(top: 26, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context).getTranslate("date_and_time"),
            style: textTitleStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 20),
            child: CustomDatetime(date: info.date),
          ),
          Text(
            AppLocalizations.of(context).getTranslate("heart_rate"),
            style: textTitleStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 40),
            child: SortHeartRate(indicator: info.indicator,),
          ),
          _buildBtnSaveRecord(),
        ]
      ),
    );
  }

  Align _buildBtnSaveRecord() {
    return Align(
      child: InkWell(
        onTap: () {
          ShowDialogCustom().showDialogCustom(
            context: context,
            title: AppLocalizations.of(context).getTranslate('save_edit_dialog_content'),
            contentLeft: AppLocalizations.of(context).getTranslate('keep'),
            contentRight: AppLocalizations.of(context).getTranslate('change_btn'),
            onClickBtRight: (){
              Navigator.of(context).pop();
            },
            onClickBtnLeft: () {
              Navigator.of(context).pop();
            },
          );
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