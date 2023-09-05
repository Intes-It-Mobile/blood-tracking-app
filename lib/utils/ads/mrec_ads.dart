import 'package:applovin_max/applovin_max.dart';
// import 'package:booknight_new/src/utils/ads_helper.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import '../../constants/config_ads_id.dart';

class MRECAds extends StatefulWidget {
  const MRECAds({super.key});

  @override
  State<MRECAds> createState() => _MRECAdsState();
}

class _MRECAdsState extends State<MRECAds> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppLovinMAX.createMRec(AdsIdConfig.mrecAdsId, AdViewPosition.bottomCenter);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 250,
      child: MaxAdView(
        adUnitId: AdsIdConfig.mrecAdsId,
        adFormat: AdFormat.mrec,
        listener: AdViewAdListener(onAdLoadedCallback: (ad) {
          debugPrint('MREC ad loaded from ${ad.networkName}');
        }, onAdLoadFailedCallback: (adUnitId, error) {
          debugPrint(
              'MREC ad failed to load with error code ${error.code} and message: ${error.message}');
        }, onAdClickedCallback: (ad) {
          debugPrint('MREC ad clicked');
        }, onAdExpandedCallback: (ad) {
          debugPrint('MREC ad expanded');
        }, onAdCollapsedCallback: (ad) {
          debugPrint('MREC ad collapsed');
        }, onAdRevenuePaidCallback: (ad) async {
          debugPrint('MREC ad revenue paid: ${ad.revenue}');
          // await FirebaseAnalytics.instance
          //     .logEvent(name: 'ad_impression', parameters: {
          //   'ad_platform': 'AppLovin',
          //   'ad_source': ad.networkName,
          //   'ad_unit_name': ad.adUnitId,
          //   'ad_format': 'MREC Ad',
          //   'value': ad.revenue,
          //   'currency': 'USD'
          // });
          // await FirebaseAnalytics.instance
          //     .logEvent(name: 'ad_impression_abi', parameters: {
          //   'ad_platform': 'AppLovin',
          //   'ad_source': ad.networkName,
          //   'ad_unit_name': ad.adUnitId,
          //   'ad_format': 'MREC Ad',
          //   'value': ad.revenue,
          //   'currency': 'USD'
          // });
        }),
      ),
    );
  }
}
