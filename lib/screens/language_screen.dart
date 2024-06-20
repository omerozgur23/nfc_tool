import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/screens/login_screen.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String englishBtnText = "English";
    const String arabicBtnText = "عربي";
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildLanguageButton(
                context: context,
                buttonText: englishBtnText,
                locale: const Locale("en", "US")),
            const SizedBox(
              height: 20,
            ),
            buildLanguageButton(
                context: context,
                buttonText: arabicBtnText,
                locale: const Locale("ar", "AR"))
          ],
        ),
      ),
    );
  }

  Widget buildLanguageButton(
      {required String buttonText,
      required Locale locale,
      required BuildContext context}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(250, 50),
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            )),
        onPressed: () {
          changeLocale(context, locale);
          navigateToLoginScreen(context);
        },
        child: Text(
            style: TextStyle(color: HexColor(languageButtonTextColor)),
            buttonText));
  }

  void changeLocale(BuildContext context, Locale locale) {
    context.setLocale(locale);
  }

  void navigateToLoginScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
  }
}
