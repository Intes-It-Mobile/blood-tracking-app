import 'package:google_mobile_ads/google_mobile_ads.dart';


class AppLifecycleReactor {
  // final AppOpenAdManager appOpenAdManager;

  // AppLifecycleReactor({required this.appOpenAdManager});
  AppLifecycleReactor();

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  void stopListening() {
    AppStateEventNotifier.stopListening();
  }

  void _onAppStateChanged(AppState appState) {
    // log('New AppState state: $appState,$isShowInterAndReward');
    // if (appState == AppState.foreground) {
    //   appOpenAdManager.showAdIfAvailable();
    }
  }
