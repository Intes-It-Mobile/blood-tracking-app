import 'package:applovin_max/applovin_max.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:blood_sugar_tracking/AppLanguage.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/constants/config_ads_id.dart';
import 'package:blood_sugar_tracking/models/alarm_info/menu_info.dart';
import 'package:blood_sugar_tracking/models/enums.dart';
import 'package:blood_sugar_tracking/models/information/information.dart';
import 'package:blood_sugar_tracking/models/information/information_provider.dart';
import 'package:blood_sugar_tracking/routes.dart';
import 'package:blood_sugar_tracking/utils/ads/applovin_function.dart';
import 'package:blood_sugar_tracking/utils/ads_handle.dart';
import 'package:blood_sugar_tracking/utils/ads_ios/ads.dart';
import 'package:blood_sugar_tracking/utils/device/size_config.dart';
import 'package:blood_sugar_tracking/views/personal_data/personal_data_screen.dart';
import 'package:blood_sugar_tracking/views/select_unit/gender_screen.dart';
import 'package:blood_sugar_tracking/views/splash/splash_screen.dart';
import 'package:blood_sugar_tracking/widgets/share_local.dart';
import 'package:blood_sugar_tracking/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:alarm/alarm.dart';
import 'controllers/stores/edit_record_store.dart';
import 'controllers/stores/sugar_info_store.dart';
import 'utils/locale/appLocalizations.dart';
import 'package:blood_sugar_tracking/widgets/flushbar.dart';

late AppsflyerSdk appsflyerSdk;
bool isInitialized = false;
bool isShowInterAndReward = false;
GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  // Alarm.ringStream.stream.listen((_) {
  //   print("Ringing main");
  // });
  WidgetsFlutterBinding.ensureInitialized();
  Map? configuration = await AppLovinMAX.initialize(AdsIdConfig.sdkKey);
  if (configuration != null) {
    isInitialized = true;
    debugPrint('Max is Init');
  }

  // await GetStorage.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
      statusBarIconBrightness: Brightness.dark // dark text for status bar
      ));
  AppLanguage appLanguage = AppLanguage();
  WidgetsFlutterBinding.ensureInitialized();
  await appLanguage.fetchLocale();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  shareLocal = await ShareLocal.getInstance();
  await Alarm.init(showDebugLogs: true);
  final AppsFlyerOptions options = AppsFlyerOptions(
    afDevKey: 'G3MBmMRHTuEpXbqyqSWGeK',
    showDebug: true,
  );
  appsflyerSdk = AppsflyerSdk(options);

  appsflyerSdk.initSdk(
    registerConversionDataCallback: true,
    registerOnAppOpenAttributionCallback: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
      testDeviceIds: ["A5A709EEACA677615871633DD27AC3DC"]));

  runApp(ChangeNotifierProvider(
    create: (context) => InformationNotifier(),
    child: MyApp(
      appLanguage: appLanguage,
    ),
    
  ));
   
}
class GlobalContext {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Cập nhật GlobalKey khi ứng dụng khởi động
  static void init(BuildContext? context) {
    context = navigatorKey.currentContext;
  }
}

class MyApp extends StatefulWidget {
  final AppLanguage appLanguage;

   MyApp({super.key, required this.appLanguage});


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  late AppLifecycleState app;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    AppLovinFunction().initializeInterstitialAds();
    appOpenAdManager.loadAd();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement
    super.didChangeDependencies();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && isShowInterAndReward == false) {
      appOpenAdManager.showAdIfAvailable();
    }
    debugPrint('app state:${state.toString()}');
    super.didChangeAppLifecycleState(state);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    GlobalContext.init(context);
    Alarm.ringStream.stream.listen((_) {
        FlushbarManager().showFlushbar(GlobalContext.navigatorKey.currentContext!);
      print("Ringing main");
    });
    TextSizeConfig.init(context);
    return Center(
        child: ChangeNotifierProvider<AppLanguage>(
      create: (_) => widget.appLanguage,
      child: MultiProvider(
        providers: [
          Provider<SugarInfoStore>(
            create: (_) => SugarInfoStore(),
          ),
          ChangeNotifierProvider<MenuInfo>(
            create: (context) => MenuInfo(MenuType.alarm),
            child: const SplashScreen(),
          ),
          Provider<EditRecordStore>(
            create: (_) => EditRecordStore(),
          ),
          ChangeNotifierProvider<InformationNotifier>(
            create: (context) => InformationNotifier(),
            child: PersonalDataScreen(),
          ),
        ],
        child: Consumer<AppLanguage>(builder: (context, model, child) {
          return MaterialApp(
            
            locale: model.appLocal,
            routes: Routes.routes,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'EN'),
              Locale('vi', 'VI'),
              Locale('fr', 'FR'),
              Locale('zh', 'CN'),
              Locale('es', 'SP'),
            ],
            localeResolutionCallback:
                (Locale? deviceLocale, Iterable<Locale> supportedLocales) =>
                    deviceLocale != null &&
                            ['en', 'vi', 'fr', 'zh', 'es']
                                .contains(deviceLocale.languageCode)
                        ? deviceLocale
                        : supportedLocales.first,
            theme: ThemeData(
              primaryColor: AppColors.AppColor2,
              colorScheme: const ColorScheme(
                brightness: Brightness.light,
                primary: Colors.white,
                error: Colors.red,
                onError: Colors.red,
                primaryVariant: AppColors.AppColor2,
                secondary: AppColors.AppColor2,
                secondaryVariant: AppColors.AppColor2,
                onSecondary: Colors.black,
                background: Colors.white,
                surface: Colors.grey,
                onPrimary: Colors.white,
                onBackground: Colors.black,
                onSurface: Colors.black,
              ),
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              useMaterial3: true,
            ),
            //  home: SelectUnit(),
            home: const SplashScreen(),
            scaffoldMessengerKey: scaffoldMessengerKey,
            navigatorKey: GlobalContext.navigatorKey,
          );
        }),
      ),
    ));
  }
}

void logAdRevenue(String eventName, String adFormat, double revenueAmount, String currencyCode) async {
  final Map<String, dynamic> eventValues = {
    "ad_platform": 'AdMob',
    "ad_unit_name": eventName,
    'ad_format': adFormat,
    "af_revenue": revenueAmount / 1000000,
    "af_currency": currencyCode,
  };
  await appsflyerSdk.logEvent('ad_impression', eventValues);
  // await analytics.logEvent(name: 'ad_impression', parameters: eventValues);
}
