import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_tool/screens/database_screen.dart';
import 'package:nfc_tool/screens/edit_screen.dart';
import 'package:nfc_tool/screens/entry_password_screen.dart';
import 'package:nfc_tool/screens/home_screen.dart';
import 'package:nfc_tool/screens/how_to_use_screen.dart';
import 'package:nfc_tool/screens/language_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nfc_tool/screens/login_screen.dart';
import 'package:nfc_tool/screens/wifi_screen.dart';
import 'package:nfc_tool/screens/write_screen.dart';
import 'package:nfc_tool/test.dart';
import 'firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nfc_tool/utils/custom_page_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Kullanıcı oturum açma durumunu kontrol et
  User? user = FirebaseAuth.instance.currentUser;
  // Sadece dikeyde çalışmasını sağlar
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ar', 'AR')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: MyApp(
          user: user,
        )),
  );
}

class MyApp extends StatefulWidget {
  final User? user;
  const MyApp({super.key, this.user});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? _user;

  @override
  void initState() {
    super.initState();
    // initState içinde _user'ı widget.user'dan başlatın
    _user = widget.user;
  }

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
      home: widget.user != null ? const HomeScreen() : const LanguageScreen(),
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
      case '/edit':
        return const EditScreen();
      case '/wifi':
        return const WifiScreen();
      case '/database':
        return DatabaseScreen();
      case '/changePassword':
        return const EntryPasswordScreen();
      case '/howToUse':
        return const HowToUseScreen();
      case '/test':
        return TestScreen();
      default:
        return const LanguageScreen();
    }
  }
}
