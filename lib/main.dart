import 'package:blood_sugar_tracking/constants/colors.dart';
import 'package:blood_sugar_tracking/routes.dart';
import 'package:blood_sugar_tracking/utils/device/size_config.dart';
import 'package:blood_sugar_tracking/views/home/home_screen.dart';
import 'package:blood_sugar_tracking/views/splash/splash_screen.dart';
import 'package:blood_sugar_tracking/widgets/share_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'controllers/stores/sugar_info_store.dart';
import 'utils/locale/appLocalizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          localeResolutionCallback: (Locale? deviceLocale, Iterable<Locale> supportedLocales) =>
              deviceLocale != null && ['en', 'vi', 'fr'].contains(deviceLocale.languageCode)
                  ? deviceLocale
                  : supportedLocales.first,
          theme: ThemeData(
            useMaterial3: true,
          ),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
