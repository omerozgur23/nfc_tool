import 'package:flutter/material.dart';
import 'package:nfc_tool/screens/home_screen.dart';
import 'package:nfc_tool/screens/language_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nfc_tool/screens/login_screen.dart';
import 'package:nfc_tool/screens/write_screen.dart';
import 'firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nfc_tool/utils/custom_page_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ar', 'AR')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Express Tap',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      onGenerateRoute: (settings) {
        return CustomPageRoute(
          builder: (context) => _getPageFromSettings(settings),
          settings: settings,
        );
      },
      // home: const LanguageScreen(),
    );
  }

  Widget _getPageFromSettings(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return const LoginScreen();
      case '/home':
        return const HomeScreen();
      case '/write':
        return const WriteScreen();
      // Diğer sayfaları buraya ekleyin
      default:
        return const LanguageScreen();
    }
  }
}
