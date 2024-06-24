import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/screens/login_screen.dart';
import 'package:nfc_tool/utils/route_animation.dart';
import 'package:url_launcher/url_launcher.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String englishBtnText = "English";
    const String arabicBtnText = "عربي";
    const String welcomeTextArabic = '" وداعا للبطاقات الورقية القديمة "';
    // const String welcomeTextEnglish = "Welcome";
    // const String sloganTextArabic = '"دعنا نعزز عملك"';
    // const String sloganTextEnglish = '"Let\'s boost your business"';
    const String copyRightText = "©2024 ExpressTap. All rights reserved.";
    return Scaffold(
      primary: false,
      appBar: AppBar(
        backgroundColor: HexColor(appBarColor),
      ),
      backgroundColor: HexColor(backgroundColor),
      body: Column(children: [
        Expanded(
          child: Stack(children: [
            buildLogo(context),
            Positioned(
                top: MediaQuery.of(context).size.height * 0.13,
                left: 0,
                right: 0,
                child: buildNewContainer()),
            Container(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              margin: const EdgeInsets.fromLTRB(25, 150, 25, 30),
              decoration: BoxDecoration(
                  color: HexColor(frameColor),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Column(
                children: [
                  buildSloganText(text: welcomeTextArabic, context: context),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, right: 25, top: 20),
                    child: Text("التطبيق مجاني بالكامل وخاص بعملاء الشركة"),
                  ),
                  const Text(
                      " سواء الأفراد أو الشركات لإدارة بطاقاتهم الرقمية"),
                  buildGif(),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLanguageButton(
                            context: context,
                            buttonText: arabicBtnText,
                            locale: const Locale("ar", "AR")),
                        const SizedBox(
                          height: 20,
                        ),
                        buildLanguageButton(
                            context: context,
                            buttonText: englishBtnText,
                            locale: const Locale("en", "US"))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        buildCopyRight(context: context, text: copyRightText),
      ]),
    );
  }

  Widget buildNewContainer() {
    return GestureDetector(
      onTap: () async {
        const url = 'https://www.yourwebsite.com';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          // Handle the error if the URL can't be launched
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Could not launch URL')),
          // );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 90),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: HexColor(frameTwoColor),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              SizedBox(width: 15.0),
              Text(
                "قم بزيارة المتجر",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLogo(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.02,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.075,
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget buildSloganText(
      {required String text, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.044,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildGif() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: Image.asset(
        'assets/gif/nfc.gif',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget buildLanguageButton(
      {required String buttonText,
      required Locale locale,
      required BuildContext context}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        backgroundColor: HexColor(buttonColor),
        minimumSize: const Size(250, 50),
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () {
        changeLocale(context, locale);
        navigateToLoginScreen(context);
      },
      child: Text(
        buttonText,
        style: TextStyle(
          color: HexColor(buttonTextColor),
          fontSize: MediaQuery.of(context).size.width * 0.05,
        ),
      ),
    );
  }

  Widget buildCopyRight({required BuildContext context, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width * 0.034,
          ),
        ),
      ),
    );
  }

  void changeLocale(BuildContext context, Locale locale) {
    context.setLocale(locale);
  }

  void navigateToLoginScreen(BuildContext context) {
    Navigator.of(context).pushNamed("/login");
  }
}
