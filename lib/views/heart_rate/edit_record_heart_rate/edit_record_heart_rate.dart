import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/constants/font_family.dart';
import 'package:blood_sugar_tracking/controllers/stores/heart_rate_store.dart';
import 'package:blood_sugar_tracking/models/heart_rate/heart_rate_info.dart';
import 'package:blood_sugar_tracking/utils/locale/appLocalizations.dart';
import 'package:blood_sugar_tracking/views/heart_rate/widgets/custom_datetime.dart';
import 'package:blood_sugar_tracking/views/heart_rate/widgets/show_dialog_custom.dart';
import 'package:blood_sugar_tracking/views/heart_rate/widgets/sort_heart_rate.dart';
import 'package:blood_sugar_tracking/widgets/button_widget.dart';
import 'package:blood_sugar_tracking/widgets/sucess_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../constants/config_ads_id.dart';
import '../../../utils/ads/applovin_function.dart';
import '../../../utils/ads/mrec_ads.dart';
import '../../../utils/ads_handle.dart';

class EditRecordHeartRateScreen extends StatefulWidget {
  const EditRecordHeartRateScreen({super.key});

  @override
  State<EditRecordHeartRateScreen> createState() => _EditRecordHeartRateScreenState();
}

class _EditRecordHeartRateScreenState extends State<EditRecordHeartRateScreen> {
  HeartRateInfo? info;
  late BuildContext context;
  DateTime? date;
  bool checkError = false;
  bool checkEmpty = false;
  String? st = ' ';
  bool back = false;
  void initState() {
   AppLovinFunction().initializeInterstitialAds();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    info ??= ModalRoute.of(context)!.settings.arguments as HeartRateInfo;
    date ??= info!.date;
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
        AppLovinFunction().showInterstitialAds();
        Navigator.pop(context, false);
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
          onClickBtnRight: (){
            Navigator.of(context).pop(false);
            AppLovinFunction().showInterstitialAds();
          },
          onClickBtnLeft: () {
            Navigator.of(context).pop(true);
          },
        ).then((value) async {
          if (value as bool == true){
            HeartRateStore heartRateStore = HeartRateStore();
            await heartRateStore.deleteRecord(info!);
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => SucessDialog());
            Future.delayed(Duration(seconds: 1), () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
              AppLovinFunction().showInterstitialAds();
            });
          }
        });
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
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
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
              child: CustomDatetime(
                date : date!,
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
                indicator: info?.indicator??0,
                onChangedIndicator: (newValue) {
                  st = newValue;
                  if (newValue != "" && newValue != null){
                    int n = int.tryParse(newValue)??0;
                    info!.indicator = n;
                  }
                  setState(() {});
                },
                back: back,
              ),
            ),
            if (checkEmpty || checkError)
              Center(
                child: Text(
                  AppLocalizations.of(context).getTranslate("errow_heart_rate_input_text"),
                  style: AppTheme.errorText,
                ),
              ),
            _buildBtnSaveRecord(),
            Center(child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: AdsNative(
                    templateType: TemplateType.medium,
                    nativeAdUnitId: AdsIdConfig.nativeInAppAdsId,
                  )),),
          ]
        ),
      ),
    );
  }

  Widget _buildBtnSaveRecord() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 30),
      child: InkWell(
        onTap: () async{
          setState(() {
            checkEmpty = (st == "" || st == null);
            checkError = ((info?.indicator??0) < 1 || (info?.indicator??0) > 120);
          });
          if (!checkError && !checkEmpty) {
            HeartRateStore heartRateStore = HeartRateStore();
            HeartRateInfo? re = await heartRateStore.checkDateTime(date!, id: info!.id);
            if (re == null){
              editRecord();
            } else {
              changedRecord(re);
            }
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.AppColor4,
            borderRadius: BorderRadius.circular(5)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context).getTranslate("save_record"),
                textAlign: TextAlign.center,
                style: AppTheme.BtnText.copyWith(fontWeight: FontWeight.w700)
              ),
            ],
          ),
        )
      ),
    );
  }

  void editRecord(){
    ShowDialogCustom().showDialogCustom(
      context: context,
      title: AppLocalizations.of(context).getTranslate('save_edit_dialog_content'),
      contentLeft: AppLocalizations.of(context).getTranslate('keep'),
      contentRight: AppLocalizations.of(context).getTranslate('change_btn'),
      onClickBtnRight: () {
        setState(() {
          back = true;
        });
        Navigator.of(context).pop(true);
      },
      onClickBtnLeft: () {
        Navigator.of(context).pop(false);
      },
    ).then((value) async {
      if (value as bool == true){
        HeartRateStore heartRateStore = HeartRateStore();
        info!.date = date;
        await heartRateStore.editRecord(info!);
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => SucessDialog());
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop();
          Navigator.of(context).pop(true);
          AppLovinFunction().showInterstitialAds();
        });
      }
    });
  }

  void changedRecord(HeartRateInfo changed){
    ShowDialogCustom().showDialogCustom(
      context: context,
      title: AppLocalizations.of(context).getTranslate('add_new_record'),
      contentLeft: AppLocalizations.of(context).getTranslate('replace'),
      contentRight: AppLocalizations.of(context).getTranslate('keep'),
      onClickBtnRight: () {
        Navigator.of(context).pop(false);
      },
      onClickBtnLeft: () {
        setState(() {
          back = true;
        });
        Navigator.of(context).pop(true);
        
      },
    ).then((value) async {
      if (value as bool == true){
        HeartRateStore heartRateStore = HeartRateStore();
        info!.date = date;
        await heartRateStore.editRecord(info!);
        await heartRateStore.deleteRecord(changed);
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => SucessDialog());
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop();
          Navigator.of(context).pop(true);
          AppLovinFunction().showInterstitialAds();       
        });
      }
    });
  }

}