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
        providers: [  Provider<SugarInfoStore>(
          create: (_) => SugarInfoStore(),
        ),],
        child: MaterialApp(
          routes: Routes.routes,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('vi', ''),
            Locale('fr', ''),
          ],
          localeResolutionCallback: (Locale? deviceLocale, Iterable<Locale> supportedLocales) =>
              deviceLocale != null && ['en', 'vi', 'fr'].contains(deviceLocale.languageCode)
                  ? deviceLocale
                  : supportedLocales.first,
          theme: ThemeData(
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a blue toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
