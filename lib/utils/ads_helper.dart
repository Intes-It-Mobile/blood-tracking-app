// TODO Implement this library.class AppLifecycleReactor {
import 'dart:io';

import 'package:flutter/services.dart';
import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:blood_sugar_tracking/utils/ads_ios/ads.dart';
import '../../main.dart';
import 'ads_handle.dart';
import 'ads_ios/ads.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9819920607806935/1180522328';
      // return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      // return 'ca-app-pub-9819920607806935/5555032909';

      /*test*/ return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError("no Platform");
    }
  }

  static String get appOpenAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9819920607806935/6049705628';
      // return 'ca-app-pub-3940256099942544/3419835294';
    } else if (Platform.isIOS) {
      // return 'ca-app-pub-9819920607806935/9789791382';
      /*test*/ return 'ca-app-pub-3940256099942544/5662855259';
    } else {
      throw UnsupportedError("no Platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9819920607806935/8240754692';
      // return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      // return 'ca-app-pub-9819920607806935/9494277910';
      /*test*/ return 'ca-app-pub-3940256099942544/4411468910';
    } else {
      throw UnsupportedError("no Platform");
    }
  }

  static String get nativeInAppAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9819920607806935/8497519961';
      // return 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      // return 'ca-app-pub-9819920607806935/2302183608';
      /*test*/ return 'ca-app-pub-3940256099942544/3986624511';
    } else {
      throw UnsupportedError("no Platform");
    }
  }

  static String get nativeExitAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9819920607806935/8497519961';
      // return 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      // return 'ca-app-pub-9819920607806935/1065123550';
      /*test*/ return 'ca-app-pub-3940256099942544/3986624511';
    } else {
      throw UnsupportedError("no Platform");
    }
  }

  static String get nativeIntroAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9819920607806935/8497519961';
      // return 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      // return 'ca-app-pub-9819920607806935/5004368568';
      /*test*/ return 'ca-app-pub-3940256099942544/3986624511';
    } else {
      throw UnsupportedError("no Platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9819920607806935/6220277770';
      // return 'ca-app-pub-3940256099942544/5224354917';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9819920607806935/1256695242';
      /*test*/ return 'ca-app-pub-3940256099942544/1712485313';
    } else {
      throw UnsupportedError("no Platform");
    }
  }
}

class MyMethodChannel {
  final MethodChannel _methodChannel = MethodChannel('com.intes.sugartracking/mediation-channel');

  /// Sets whether the user is age restricted in AppLovin.
  Future<void> setAppLovinIsAgeRestrictedUser(bool isAgeRestricted) async {
    return _methodChannel.invokeMethod(
      'setIsAgeRestrictedUser',
      {
        'isAgeRestricted': isAgeRestricted,
      },
    );
  }

  /// Sets whether we have user consent for the user in AppLovin.
  Future<void> setHasUserConsent(bool hasUserConsent) async {
    return _methodChannel.invokeMethod(
      'setHasUserConsent',
      {
        'hasUserConsent': hasUserConsent,
      },
    );
  }
}

/// Listens for app foreground events and shows app open ads.
class AppLifecycleReactor {
  final AppOpenAdManager appOpenAdManager;

  AppLifecycleReactor({required this.appOpenAdManager});

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.forEach((state) => _onAppStateChanged(state));
  }

  void stopListening() {
    AppStateEventNotifier.stopListening();
  }

  void _onAppStateChanged(AppState appState) {
    print('New AppState state: $appState');
    if (appState == AppState.foreground) {
      if (isShowAOA) {
        appOpenAdManager.showAdIfAvailable();
      }
    }
  }
}
