import 'package:alarm/alarm.dart';
import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/models/alarm_info/menu_info.dart';
import 'package:blood_sugar_tracking/models/enums.dart';
import 'package:blood_sugar_tracking/routes.dart';
import 'package:blood_sugar_tracking/utils/device/size_config.dart';
import 'package:blood_sugar_tracking/views/splash/splash_screen.dart';
import 'package:blood_sugar_tracking/widgets/share_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'controllers/stores/edit_record_store.dart';
import 'controllers/stores/sugar_info_store.dart';
import 'utils/locale/appLocalizations.dart';


void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
      statusBarIconBrightness: Brightness.dark // dark text for status bar
  ));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Alarm.init(showDebugLogs: true);
  shareLocal = await ShareLocal.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TextSizeConfig.init(context);
    return Center(
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
        ],
        child: MaterialApp(
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
          ],
          localeResolutionCallback:
              (Locale? deviceLocale, Iterable<Locale> supportedLocales) =>
                  deviceLocale != null &&
                          ['en', 'vi', 'fr'].contains(deviceLocale.languageCode)
                      ? deviceLocale
                      : supportedLocales.first,
          theme: ThemeData(
            primaryColor: AppColors.AppColor2,
            colorScheme: ColorScheme(
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
          home: SplashScreen(),
        ),
      ),
    );
  }
}
