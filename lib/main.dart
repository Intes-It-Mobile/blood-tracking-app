import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/models/alarm_info/menu_info.dart';
import 'package:blood_sugar_tracking/models/enums.dart';
import 'package:blood_sugar_tracking/routes.dart';
import 'package:blood_sugar_tracking/utils/device/size_config.dart';
import 'package:blood_sugar_tracking/views/record_remind/record_remind_screens.dart';
import 'package:blood_sugar_tracking/views/splash/splash_screen.dart';
import 'package:blood_sugar_tracking/widgets/share_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'controllers/stores/edit_record_store.dart';
import 'controllers/stores/sugar_info_store.dart';
import 'utils/locale/appLocalizations.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {});
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });
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
              error: Colors.red,
              onError: Colors.red,
              primary: Colors.white,
              primaryVariant: AppColors.AppColor2,
              secondary: AppColors.AppColor2,
              secondaryVariant: AppColors.AppColor2,
              background: Colors.white,
              surface: Colors.grey,
              onPrimary: Colors.white,
              onSecondary: Colors.black,
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
