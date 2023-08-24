import 'package:blood_sugar_tracking/constants/app_theme.dart';
import 'package:blood_sugar_tracking/constants/assets.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/constants/font_family.dart';
import 'package:blood_sugar_tracking/controllers/stores/heart_rate_store.dart';
import 'package:blood_sugar_tracking/models/heart_rate/heart_rate_info.dart';
import 'package:blood_sugar_tracking/routes.dart';
import 'package:blood_sugar_tracking/utils/locale/appLocalizations.dart';
import 'package:blood_sugar_tracking/views/heart_rate/history_heart_rate/history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/ads/applovin_function.dart';
import '../../../utils/ads/mrec_ads.dart';

class HistoryHeartRateScreen extends StatefulWidget {
  const HistoryHeartRateScreen({super.key});

  @override
  State<HistoryHeartRateScreen> createState() => _HistoryHeartRateScreenState();
}

class _HistoryHeartRateScreenState extends State<HistoryHeartRateScreen> {
  late List<HeartRateInfo> history;
  late BuildContext context;

  Future<List<HeartRateInfo>> loadData() async {
    HeartRateStore heartRateStore = HeartRateStore();
    await heartRateStore.getListRecords();
    return heartRateStore.listRecord ?? [];
  }
@override
  void initState() {
    AppLovinFunction().initializeInterstitialAds();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: _buildAppBarCustom(),
      body: FutureBuilder(
        future: loadData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            history = snapshot.data;
            if (history.isEmpty) return noData(context);
            return _buildBody();
          }
          return noData(context);
        },
      ),
    );
  }

  Container noData(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(Assets.history_mpt, width: 146, height: 146),
          const SizedBox(height: 30),
          Text(
              "${AppLocalizations.of(context)!.getTranslate('you_have_not_record')}",
              textAlign: TextAlign.center,
              style: AppTheme.TextIntroline16Text.copyWith(
                  fontWeight: FontWeight.w700, color: Colors.black)),
          Center(child: const MRECAds()),
        ],
      ),
    );
  }

  AppBar _buildAppBarCustom() {
    return AppBar(
      toolbarHeight: 68,
      backgroundColor: AppColors.AppColor2,
      title: Text(
        AppLocalizations.of(context).getTranslate("record_history"),
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
        AppLovinFunction().showInterstitialAds();
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
    history.sort((a, b) => b.date!.compareTo(a.date!));
    return Container(
        margin: const EdgeInsets.fromLTRB(15, 16, 15, 16),
        child: GridView.count(
          childAspectRatio: 1.8,
          mainAxisSpacing: 16,
          crossAxisSpacing: 12,
          crossAxisCount: 2,
          children: List.generate(history.length, (index) {
            return HistoryHeartRateRecord(
              info: history[index],
              onClick: () {
                Navigator.of(context)
                    .pushNamed(Routes.edit_record_heart_rate,
                        arguments: history[index])
                    .then((onValue) async {
                  if (onValue as bool == true) {
                    history = await loadData();
                    setState(() {});
                  }
                });
              },
            );
          }),
        ));
  }
}
