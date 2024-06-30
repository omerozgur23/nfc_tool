import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/utils/context_extensiton.dart';
import 'package:url_launcher/url_launcher.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});
  final String englishBtnText = "English";
  final String arabicBtnText = "عربي";
  final String firstText = '"وداعا للبطاقات الورقية القديمة "';
  final String secondText =
      "التطبيق مجاني بالكامل وخاص بعملاء الشركة\nسواء الأفراد أو الشركات لإدارة بطاقاتهم الرقمية";
  final String copyRightText = "languageScreen.copyRight";
  final String navigateSiteBtnText = "قم بزيارة المتجر";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      primary: false,
      appBar: AppBar(
        backgroundColor: HexColor(appBarColor),
      ),
      body: buildBody(context),
    );
  }

  Padding buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          context.dynamicWidth(0.06),
          context.dynamicHeight(0.02),
          context.dynamicWidth(0.06),
          context.dynamicHeight(0.01)),
      child: Column(children: [
        Expanded(flex: 1, child: buildLogo()),
        SizedBox(
          height: context.dynamicHeight(0.02),
        ),
        Expanded(flex: 1, child: buildNavigateSiteButton(context)),
        SizedBox(
          height: context.dynamicHeight(0.010),
        ),
        Expanded(
          flex: 9,
          child: buildContainerBody(context),
        ),
        SizedBox(
          height: context.dynamicHeight(0.04),
        ),
        Expanded(child: buildCopyRight()),
      ]),
    );
  }

  Center buildLogo() {
    return Center(
        child: Image.asset(
      "assets/images/logo.png",
      fit: BoxFit.contain,
    ));
  }

  Padding buildNavigateSiteButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.dynamicWidth(0.17),
          vertical: context.dynamicHeight(0.01)),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              backgroundColor: HexColor(darkGrey)),
          onPressed: () {
            launchURL("https://www.ferhatozgur.info");
          },
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.arrow_back,
              color: HexColor(white),
            ),
            SizedBox(
              width: context.dynamicWidth(0.03),
            ),
            Text(
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: HexColor(white)),
                navigateSiteBtnText),
          ])),
    );
  }

  Container buildContainerBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: context.dynamicWidth(0.05),
          vertical: context.dynamicHeight(0.05)),
      decoration: BoxDecoration(
          color: HexColor(frameColor),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        children: [
          Expanded(
            child: Text(
              firstText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              secondText,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 4,
            child: buildGif(),
          ),
          SizedBox(
            height: context.dynamicHeight(0.02),
          ),
          Expanded(
            child: buildLanguageButton(
                context: context,
                text: arabicBtnText,
                locale: const Locale("ar", "AR")),
          ),
          SizedBox(
            height: context.dynamicHeight(0.02),
          ),
          Expanded(
            child: buildLanguageButton(
                context: context,
                text: englishBtnText,
                fontSize: context.dynamicHeight(0.020),
                locale: const Locale("en", "US")),
          )
        ],
      ),
    );
  }

  Text buildCopyRight() => Text(copyRightText).tr();

  Image buildGif() {
    return Image.asset(
      'assets/gif/nfc.gif',
      fit: BoxFit.contain,
    );
  }

  SizedBox buildLanguageButton(
      {double? fontSize,
      required String text,
      required Locale locale,
      required BuildContext context}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              backgroundColor: HexColor(buttonColor)),
          onPressed: () {
            changeLocale(context, locale);
            navigateToLoginScreen(context);
          },
          child: Text(
            text,
            style: TextStyle(
                color: HexColor(buttonTextColor),
                fontSize: fontSize ?? context.dynamicHeight(0.023)),
          )),
    );
  }

  void changeLocale(BuildContext context, Locale locale) {
    context.setLocale(locale);
  }

  void navigateToLoginScreen(BuildContext context) {
    Navigator.of(context).pushNamed("/login");
  }

  void launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
