import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../constants/config_ads_id.dart';
import '../../controllers/stores/sugar_info_store.dart';
import '../../models/sugar_info/sugar_info.dart';
import '../../utils/ads/applovin_function.dart';
import '../../utils/ads/mrec_ads.dart';
import '../../utils/ads_handle.dart';
import '../../utils/ads_helper.dart';
import '../../utils/ads_ios/ads.dart';
import '../../utils/locale/appLocalizations.dart';
import '../home/record_info_slide_bar/record_info_slide_bar_item.dart';

class RecordHistory extends StatefulWidget {
  const RecordHistory({super.key});

  @override
  State<RecordHistory> createState() => _RecordHistoryState();
}

class _RecordHistoryState extends State<RecordHistory> {
  SugarInfoStore? sugarInfoStore;
  ShowInterstitialAdsController showInterstitialAdsController =
      ShowInterstitialAdsController();

  @override
  void initState() {
    showInterstitialAdsController.loadAd();
    AppLovinFunction().initializeInterstitialAds();
  }

  @override
  void didChangeDependencies() {
    sugarInfoStore = Provider.of<SugarInfoStore>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: 68,
        backgroundColor: AppColors.AppColor2,
        title: Container(
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      showInterstitialAdsController.showAlert();
                      // AppLovinFunction().showInterstitialAds();
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 12),
                      child: SvgPicture.asset(
                        Assets.iconBack,
                        height: 40,
                        width: 40,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${AppLocalizations.of(context)!.getTranslate('record_history')}",
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
          width: MediaQuery.of(context).size.width,
          // margin: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
          margin: EdgeInsets.fromLTRB(15, 16, 15, 16),
          child: sugarInfoStore!.listRecord != null &&
                  sugarInfoStore!.listRecord!.isNotEmpty
              ? Column(
                  children: buildHistoryRecord(),
                )
              : Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(Assets.history_mpt, width: 146, height: 146),
                      SizedBox(height: 30),
                      Text(
                          "${AppLocalizations.of(context)!.getTranslate('you_have_not_record')}",
                          textAlign: TextAlign.center,
                          style: AppTheme.TextIntroline16Text.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.black)),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
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
                    ],
                  ),
                ) //Trường hợp chưa có record,
          ),
    );
  }

List<Widget> buildHistoryRecord() {
  final List<Widget> widgetsList =
      sugarInfoStore!.listRecord!.asMap().entries.fold(
    <Widget>[],
    (List<Widget> acc, MapEntry<int, SugarRecord> entry) {
      final int index = entry.key;
      final SugarRecord recordInfo = entry.value;

      acc.add(
        RecordInfoSliderItemWidget(
          margin: true,
          id: recordInfo.id,
          status: recordInfo.status,
          dayTime: recordInfo.dayTime,
          hourTime: recordInfo.hourTime,
          sugarAmount: recordInfo.sugarAmount,
        ),
      );

      return acc;
    },
  );

  // Sử dụng hàm buildCustomList để tạo danh sách theo yêu cầu
  return buildCustomList(widgetsList);
}
List<Widget> buildCustomList(List<Widget> widgetList) {
  final List<Widget> resultList = [];

  for (int i = 0; i < widgetList.length; i += 2) {
    final rowWidgets = <Widget>[];
    rowWidgets.add(widgetList[i]);

    if (i + 1 < widgetList.length) {
      rowWidgets.add(SizedBox(width: 25)); // Thêm margin giữa các phần tử
      rowWidgets.add(widgetList[i + 1]);
    }

    resultList.add(
      Padding(
        padding: EdgeInsets.only(left: 15), // Thêm margin cạnh trái màn hình 15px
        child: Row(
          children: rowWidgets,
        ),
      ),
    );

    // Kiểm tra nếu không còn cặp phần tử nào và không phải hàng cuối cùng
    if (i + 2 < widgetList.length) {
      resultList.add(
        Container(
                width: double.infinity,
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: AdsNative(
                        templateType: TemplateType.small,
                        unitId: AdHelper.nativeInAppAdUnitId,
                      )),
                ),
              ),
      );
    }
  }

  return resultList;
}

}
