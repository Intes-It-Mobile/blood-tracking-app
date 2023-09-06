import 'dart:math';

import 'package:applovin_max/applovin_max.dart';
import '../../constants/config_ads_id.dart';
import '../ads_handle.dart';
import '/main.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

enum AdLoadState { notLoaded, loading, loaded }

class AppLovinFunction {
  var _interstitialRetryAttempt = 0;
  var _rewardedAdRetryAttempt = 0;
  // AppOpenAdManager appOpenAds = AppOpenAdManager();
  void initializeInterstitialAds() {
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) async {
        // Interstitial ad is ready to be shown. AppLovinMAX.isInterstitialReady(_interstitial_ad_unit_id) will now return 'true'
        debugPrint('Interstitial ad loaded from ${ad.networkName}');
        await FirebaseAnalytics.instance.logEvent(name: 'ads_inter_load', parameters: {
          "placement": "",
        });
        // Reset retry attempt
        _interstitialRetryAttempt = 0;
      },
      onAdLoadFailedCallback: (adUnitId, error) async {
        // Interstitial ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        _interstitialRetryAttempt = _interstitialRetryAttempt + 1;

        int retryDelay = pow(2, min(6, _interstitialRetryAttempt)).toInt();
        debugPrint('retry:$retryDelay');
        debugPrint('Interstitial ad failed to load with code ${error.code} - retrying in ${retryDelay}s');

        Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
          AppLovinMAX.loadInterstitial(AdsIdConfig.interstitialAdsId);
        });
        await FirebaseAnalytics.instance.logEvent(
            name: 'ads_inter_failed',
            parameters: {"placement": "", "errormsg": 'Error Message: FailToLoad, Unavailable'});
      },
      onAdDisplayedCallback: (ad) async {
        appsflyerSdk.logEvent('af_inters_displayed', {});
        await FirebaseAnalytics.instance.logEvent(name: 'ads_inter_show', parameters: {
          "placement": "",
        });

        debugPrint('Interstitial ad displayed,$isShowInterAndReward');
      },
      onAdDisplayFailedCallback: (ad, error) async {
        debugPrint('Interstitial ad failed to display with code ${error.code} and message ${error.message}');
        await FirebaseAnalytics.instance.logEvent(
            name: 'ads_inter_failed',
            parameters: {"placement": "", "errormsg": 'Error Message: FailToLoad, Unavailable'});
      },
      onAdClickedCallback: (ad) async {
        debugPrint('Interstitial ad clicked');
        await FirebaseAnalytics.instance.logEvent(name: 'ads_inter_click', parameters: {
          "placement": "",
        });
      },
      onAdHiddenCallback: (ad) {
        debugPrint('Interstitial ad hidden');
        isShowInterAndReward = false;
      },
      onAdRevenuePaidCallback: (ad) async {
        debugPrint('Interstitial ad revenue paid: ${ad.revenue}');
        await FirebaseAnalytics.instance.logEvent(name: 'ad_impression', parameters: {
          'ad_platform': 'AppLovin',
          'ad_source': ad.networkName,
          'ad_unit_name': ad.adUnitId,
          'ad_format': 'Interstitial Ad',
          'value': ad.revenue,
          'currency': 'USD'
        });
        await FirebaseAnalytics.instance.logEvent(name: 'ad_impression_abi', parameters: {
          'ad_platform': 'AppLovin',
          'ad_source': ad.networkName,
          'ad_unit_name': ad.adUnitId,
          'ad_format': 'Interstitial Ad',
          'value': ad.revenue,
          'currency': 'USD'
        });
        isShowInterAndReward = true;

        // appOpenAds.dispose();
      },
    ));

    // Load the first interstitial
    AppLovinMAX.loadInterstitial(AdsIdConfig.interstitialAdsId);
  }

  void showInterstitialAds() async {
    bool isReady = (await AppLovinMAX.isInterstitialReady(AdsIdConfig.interstitialAdsId))!;
    debugPrint('$isReady');
    if (isReady) {
      AppLovinMAX.showInterstitial(AdsIdConfig.interstitialAdsId);
    } else {
      AppLovinMAX.loadInterstitial(AdsIdConfig.interstitialAdsId);
    }
  }

  void initializeRewardedAds() {
    AppLovinMAX.setRewardedAdListener(RewardedAdListener(onAdLoadedCallback: (ad) async {
      // Rewarded ad is ready to be shown. AppLovinMAX.isRewardedAdReady(_rewarded_ad_unit_id) will now return 'true'
      debugPrint('Rewarded ad loaded from ${ad.networkName}');
      await FirebaseAnalytics.instance.logEvent(name: 'ads_reward_offer', parameters: {
        "placement": "",
      });
      // Reset retry attempt
      _rewardedAdRetryAttempt = 0;
    }, onAdLoadFailedCallback: (adUnitId, error) async {
      // Rewarded ad failed to load
      // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
      _rewardedAdRetryAttempt = _rewardedAdRetryAttempt + 1;

      int retryDelay = pow(2, min(6, _rewardedAdRetryAttempt)).toInt();
      debugPrint('Rewarded ad failed to load with code ${error.code} - retrying in ${retryDelay}s');
      await FirebaseAnalytics.instance.logEvent(name: 'ads_reward_fail', parameters: {
        "placement": "",
        "errormsg": "Error Message: Unknown,Offline,NoFill,InternalError,InvalidRequest,UnableToPrecached"
      });
      Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
        AppLovinMAX.loadRewardedAd(AdsIdConfig.rewardedAdsId);
      });
    }, onAdDisplayedCallback: (ad) async {
      appsflyerSdk.logEvent('af_rewarded_displayed', {});
      await FirebaseAnalytics.instance.logEvent(name: 'ads_reward_show', parameters: {
        "placement": "",
      });

      debugPrint('Rewarded ad displayed,$isShowInterAndReward');
    }, onAdDisplayFailedCallback: (ad, error) async {
      debugPrint('Rewarded ad failed to display with code ${error.code} and message ${error.message}');
      await FirebaseAnalytics.instance.logEvent(name: 'ads_reward_fail', parameters: {
        "placement": "",
        "errormsg": "Error Message: Unknown,Offline,NoFill,InternalError,InvalidRequest,UnableToPrecached"
      });
    }, onAdClickedCallback: (ad) async {
      debugPrint('Rewarded ad clicked');
      await FirebaseAnalytics.instance.logEvent(name: 'ads_reward_click', parameters: {
        "placement": "",
      });
    }, onAdHiddenCallback: (ad) {
      debugPrint('Rewarded ad hidden');
    }, onAdReceivedRewardCallback: (ad, reward) async {
      appsflyerSdk.logEvent('af_rewarded_successfullyloaded', {});
      await FirebaseAnalytics.instance.logEvent(name: 'ads_reward_complete', parameters: {
        "placement": "",
      });
      debugPrint('Rewarded ad granted reward');
    }, onAdRevenuePaidCallback: (ad) async {
      debugPrint('Rewarded ad revenue paid: ${ad.revenue}');
      await FirebaseAnalytics.instance.logEvent(name: 'ad_impression', parameters: {
        'ad_platform': 'AppLovin',
        'ad_source': ad.networkName,
        'ad_unit_name': ad.adUnitId,
        'ad_format': 'Rewarded Ad',
        'value': ad.revenue,
        'currency': 'USD'
      });
      await FirebaseAnalytics.instance.logEvent(name: 'ad_impression_abi', parameters: {
        'ad_platform': 'AppLovin',
        'ad_source': ad.networkName,
        'ad_unit_name': ad.adUnitId,
        'ad_format': 'Rewarded Ad',
        'value': ad.revenue,
        'currency': 'USD'
      });
      isShowInterAndReward = true;
      // appOpenAds.dispose();
    }));
    AppLovinMAX.loadRewardedAd(AdsIdConfig.rewardedAdsId);
  }
}
