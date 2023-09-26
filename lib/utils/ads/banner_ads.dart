import 'package:applovin_max/applovin_max.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import '../../constants/config_ads_id.dart';

class BannerAds extends StatefulWidget {
  const BannerAds({super.key});

  @override
  State<BannerAds> createState() => _BannerAdsState();
}

class _BannerAdsState extends State<BannerAds> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppLovinMAX.createBanner(
      AdsIdConfig.bannerAdsId,
      AdViewPosition.bottomCenter,
    );
    // AppLovinMAX.showBanner(AdHelper.bannerAdUnitId);
  }

  @override
  Widget build(BuildContext context) {
    return MaxAdView(
      
      adUnitId: AdsIdConfig.bannerAdsId,
      adFormat: AdFormat.banner,
      isAutoRefreshEnabled: true,
      listener: AdViewAdListener(onAdLoadedCallback: (ad) {
        debugPrint('Banner ad loaded from ${ad.networkName}');
      }, onAdLoadFailedCallback: (adUnitId, error) {
        debugPrint(
            'Banner ad failed to load with error code ${error.code} and message: ${error.message}');
      }, onAdClickedCallback: (ad) {
        debugPrint('Banner ad clicked');
      }, onAdExpandedCallback: (ad) {
        debugPrint('Banner ad expanded');
      }, onAdCollapsedCallback: (ad) {
        debugPrint('Banner ad collapsed');
      }, onAdRevenuePaidCallback: (ad) async {
        debugPrint('Banner ad revenue paid: ${ad.revenue}');
        await FirebaseAnalytics.instance
            .logEvent(name: 'ad_impression', parameters: {
          'ad_platform': 'AppLovin',
          'ad_source': ad.networkName,
          'ad_unit_name': ad.adUnitId,
          'ad_format': 'Banner Ad',
          'value': ad.revenue,
          'currency': 'USD'
        });
        await FirebaseAnalytics.instance
            .logEvent(name: 'ad_impression_abi', parameters: {
          'ad_platform': 'AppLovin',
          'ad_source': ad.networkName,
          'ad_unit_name': ad.adUnitId,
          'ad_format': 'Banner Ad',
          'value': ad.revenue,
          'currency': 'USD'
        });
      }),
    );
  }
}
