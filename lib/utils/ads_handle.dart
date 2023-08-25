import 'dart:developer';

import '../constants/config_ads_id.dart';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_helper.dart';

class AdsNative extends StatefulWidget {
  final TemplateType templateType;
  final String nativeAdUnitId;
  const AdsNative(
      {super.key, required this.templateType, required this.nativeAdUnitId});

  @override
  State<AdsNative> createState() => _AdsNativeState();
}

class _AdsNativeState extends State<AdsNative> {
  late NativeAd _nativeAd;
  bool isNativeAdReady = false;

  @override
  void initState() {
    _nativeAd = NativeAd(
        adUnitId: widget.nativeAdUnitId,
        listener: NativeAdListener(onAdLoaded: (_) {
          setState(() {
            isNativeAdReady = true;
          });
        }, onAdFailedToLoad: (ad, e) {
          log('native ads error:$e');
          isNativeAdReady = false;
          ad.dispose();
        }),
        request: const AdRequest(
          nonPersonalizedAds: true,
        ),
        nativeTemplateStyle:
            NativeTemplateStyle(templateType: widget.templateType))
      ..load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth:
              MediaQuery.of(context).size.width, // minimum recommended width
          minHeight: widget.templateType == TemplateType.medium
              ? MediaQuery.of(context).size.height * 0.35
              : MediaQuery.of(context).size.height *
                  0.14, // minimum recommended height
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: widget.templateType == TemplateType.medium
              ? MediaQuery.of(context).size.height * 0.35
              : MediaQuery.of(context).size.height * 0.14,
        ),
        child: isNativeAdReady ? AdWidget(ad: _nativeAd) : const SizedBox());
  }
}

class AppOpenAdManager {
  /// Maximum duration allowed between loading and showing the ad.
  final Duration maxCacheDuration = const Duration(hours: 4);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;

  AppOpenAd? _appOpenAd;
  bool isShowingAd = false;

  void dispose() {
    if (_appOpenAd != null || isShowInterAndReward) {
      _appOpenAd!.dispose();
    }
  }

  /// Load an [AppOpenAd].
  void loadAd() {

    AppOpenAd.load(
      adUnitId: AdsIdConfig.appOpenAdsId,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          log('$ad loaded');
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          log('AppOpenAd failed to load: $error');
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
      log('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (isShowingAd) {
      log('Tried to show ad while already showing an ad.');
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      log('Maximum cache duration exceeded. Loading another ad.');
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) async {
        isShowingAd = true;
        log('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        log('$ad onAdFailedToShowFullScreenContent: $error');
        isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        log('$ad onAdDismissedFullScreenContent');
        isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }
}
