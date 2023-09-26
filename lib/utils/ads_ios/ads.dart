import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../main.dart';
import '../ads_helper.dart';
import 'package:blood_sugar_tracking/views/heart_rate/widgets/countdown_timer.dart';

class AdsBanner extends StatefulWidget {
  const AdsBanner({super.key});

  @override
  State<AdsBanner> createState() => _AdsBannerState();
}

class _AdsBannerState extends State<AdsBanner> {
  late BannerAd _bannerAd;
  bool isBannerAdReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isBannerAdReady = false;
    _loadAd();
  }

  Future<void> _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            setState(() {
              // When the ad is loaded, get the ad size and use it to set
              // the height of the ad container.
              _bannerAd = ad as BannerAd;
              isBannerAdReady = true;
            });
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
          },
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (Ad ad) {},
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) {},
          // Called when an impression occurs on the ad.
          onAdImpression: (Ad ad) {},
          onPaidEvent: (Ad ad, double valueMicros, PrecisionType precision, String currencyCode) {
            logAdRevenue(ad.adUnitId, 'bannerAd', valueMicros, currencyCode);
          }),
    );
    return _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return isBannerAdReady
        ? SizedBox(
            width: _bannerAd.size.width.toDouble(),
            height: MediaQuery.of(context).size.height * 0.08,
            child: AdWidget(ad: _bannerAd),
          )
        : SizedBox(height: MediaQuery.of(context).size.height * 0.08);
  }
}

bool isShowAOA = true;

class AdsNative extends StatefulWidget {
  final TemplateType templateType;
  String? unitId;
  AdsNative({super.key, required this.templateType, this.unitId});

  @override
  State<AdsNative> createState() => _AdsNativeState();
}

class _AdsNativeState extends State<AdsNative> {
  late NativeAd _nativeAd;
  bool isNativeAdReady = false;

  @override
  void initState() {
    _nativeAd = NativeAd(
        adUnitId: widget.unitId!,
        listener: NativeAdListener(onAdLoaded: (_) {
          setState(() {
            isNativeAdReady = true;
          });
        }, onAdFailedToLoad: (ad, e) {
          print(e);
          isNativeAdReady = false;
          ad.dispose();
        }, onPaidEvent: (Ad ad, double valueMicros, PrecisionType precision, String currencyCode) {
          logAdRevenue(ad.adUnitId, 'nativeAd', valueMicros, currencyCode);
        }),
        request: const AdRequest(
          nonPersonalizedAds: true,
        ),
        nativeTemplateStyle: NativeTemplateStyle(templateType: widget.templateType))
      ..load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width, // minimum recommended width
          minHeight: widget.templateType == TemplateType.medium
              ? MediaQuery.of(context).size.height * 0.39
              : MediaQuery.of(context).size.height * 0.14, // minimum recommended height
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: widget.templateType == TemplateType.medium
              ? MediaQuery.of(context).size.height * 0.39
              : MediaQuery.of(context).size.height * 0.14,
        ),
        child: isNativeAdReady ? AdWidget(ad: _nativeAd) : const SizedBox());
  }
}

class ShowInterstitialAdsController {
  InterstitialAd? interstitialAd;

  void showAlert() {
    //Todo: off inter
    if (interstitialAd != null) {
      appsflyerSdk.logEvent('af_inters_displayed', {});
      // interstitialAd?.show();
      isShowAOA = false;
    }
  }

  void loadAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {
                  appsflyerSdk.logEvent('af_inters_ad_eligible', {});
                },
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  isShowAOA = true;
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            // Keep a reference to the ad so you can show it later.
            appsflyerSdk.logEvent('af_inters_api_called', {});
            interstitialAd = ad;

            ad.onPaidEvent = (Ad ad, double valueMicros, PrecisionType precision, String currencyCode) {
              logAdRevenue(ad.adUnitId, 'interstitialAd', valueMicros, currencyCode);
            };
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            // ignore: avoid_print
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  void dispose() {
    interstitialAd?.dispose();
  }
}

// class ShowRewardedAdsController {
//   var showWatchVideoButton = false;
//   final CountdownTimer countdownTimer = CountdownTimer();
//   RewardedAd? rewardedAd;
//
//   Future<void> show(Function doneAds) async {
//     appsflyerSdk.logEvent('af_rewarded_ad_eligible', {});
//     rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
//       // ignore: avoid_print
//       print('Reward amount: ${rewardItem.amount}');
//       appsflyerSdk.logEvent('af_rewarded_ad_completed', {});
//       doneAds();
//     });
//   }
//
//   init() {
//     countdownTimer.addListener(() {
//       if (countdownTimer.isComplete) {
//         showWatchVideoButton = true;
//       } else {
//         showWatchVideoButton = false;
//       }
//     });
//     loadAd();
//     countdownTimer.start();
//   }
//
//   Future<void> loadAd() async {
//     RewardedAd.load(
//         adUnitId: AdHelper.rewardedAdUnitId,
//         request: const AdRequest(),
//         rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
//           ad.fullScreenContentCallback = FullScreenContentCallback(
//               // Called when the ad showed the full screen content.
//               onAdShowedFullScreenContent: (ad) {
//                 isShowAOA = false;
//                 appsflyerSdk.logEvent('af_rewarded_displayed', {});
//               },
//               // Called when an impression occurs on the ad.
//               onAdImpression: (ad) {},
//               // Called when the ad failed to show full screen content.
//               onAdFailedToShowFullScreenContent: (ad, err) {
//                 ad.dispose();
//               },
//               // Called when the ad dismissed full screen content.
//               onAdDismissedFullScreenContent: (ad) {
//                 isShowAOA = true;
//                 ad.dispose();
//               },
//               // Called when a click is recorded for an ad.
//               onAdClicked: (ad) {});
//
//           // Keep a reference to the ad so you can show it later.
//           appsflyerSdk.logEvent('af_rewarded_api_called', {});
//           rewardedAd = ad;
//         }, onAdFailedToLoad: (LoadAdError error) {
//           // ignore: avoid_print
//           print('RewardedAd failed to load: $error');
//         }));
//   }
//
//   dispose() {
//     rewardedAd?.dispose();
//     // countdownTimer.dispose();
//   }
// }

class AppOpenAdManager {
  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = const Duration(hours: 4);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;

  AppOpenAd? _appOpenAd;
  bool isShowingAd = false;

  void dispose() {
    if (_appOpenAd != null) {
      _appOpenAd!.dispose();
    }
  }

  /// Load an [AppOpenAd].
  void loadAd() {
    AppOpenAd.load(
      adUnitId: AdHelper.appOpenAdUnitId,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print('$ad loaded');
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  /// Shows the ad, if one exists and is not already being shown.
  ///
  /// If the previously cached ad has expired, this just loads and caches a
  /// new ad.
  void showAdIfAvailable() {
    if (!isAdAvailable) {
      print('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (isShowingAd) {
      print('Tried to show ad while already showing an ad.');
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      print('Maximum cache duration exceeded. Loading another ad.');
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        isShowingAd = true;
        print('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        print('$ad onAdDismissedFullScreenContent');
        isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }
}
