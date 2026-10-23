import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/app_localizations.dart';
import 'state/locale_provider.dart';
import 'state/auth_provider.dart';
import 'state/profile_provider.dart';
import 'state/job_provider.dart';
import 'state/crop_price_provider.dart';
import 'state/scheme_provider.dart';
import 'state/panchayat_provider.dart';
import 'state/weather_provider.dart';
import 'ui/screens/splash/splash_screen.dart';

class Uzhavan360App extends StatelessWidget {
  const Uzhavan360App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => CropPriceProvider()),
        ChangeNotifierProvider(create: (_) => SchemeProvider()),
        ChangeNotifierProvider(create: (_) => PanchayatProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProv, _) {
          return MaterialApp(
            title: 'UZHAVAN360',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: localeProv.locale,
            supportedLocales: const [
              Locale('ta', 'IN'),
              Locale('ta'),
              Locale('en', 'IN'),
              Locale('en'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
