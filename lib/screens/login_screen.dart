import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/utils/media_query/context_extensiton.dart';
import 'package:nfc_tool/auth/auth_provider.dart' as auth_provider;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth_provider.AuthProvider authProvider = auth_provider.AuthProvider();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: HexColor(backgroundColor),
      appBar: buildAppBar(),
      body: buildBody(context),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        "loginScreen.title",
        style: TextStyle(color: HexColor(appBarTitleColor)),
      ).tr(),
      backgroundColor: HexColor(appBarColor),
      iconTheme: IconThemeData(color: HexColor(appBarIconColor)),
    );
  }

  Container buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: context.dynamicWidth(0.06),
          vertical: context.dynamicHeight(0.06)),
      padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.05)),
      decoration: BoxDecoration(
          color: HexColor(frameColor),
          borderRadius: BorderRadius.circular(5.0)),
      child: Form(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildEmailInput(),
          SizedBox(height: context.dynamicHeight(0.02)),
          buildPasswordInput(),
          SizedBox(height: context.dynamicHeight(0.02)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => showResetPasswordDialog(context),
                  child: Text(
                    "loginScreen.forgotPasswordButton".tr(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.dynamicHeight(0.06)),
          buildSignInButton()
        ],
      )),
    );
  }

  TextFormField buildEmailInput() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          labelText: "loginScreen.emailInput".tr(),
          labelStyle: TextStyle(color: HexColor(black)),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor(black), width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          )),
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
    );
  }

  TextFormField buildPasswordInput() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          labelText: "loginScreen.passwordInput".tr(),
          labelStyle: TextStyle(color: HexColor(black)),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor(black), width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          ),
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              icon:
                  Icon(obscureText ? Icons.visibility : Icons.visibility_off))),
      obscureText: obscureText,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
      ],
    );
  }

  SizedBox buildSignInButton() {
    return SizedBox(
      width: context.dynamicWidth(0.5),
      height: context.dynamicHeight(0.050),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          backgroundColor: HexColor(buttonColor),
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          authProvider.signInWithEmailAndPassword(
              context: context,
              email: _emailController.text,
              password: _passwordController.text);
        },
        child: Text(
          "loginScreen.signInButton".tr(),
          style: TextStyle(
              color: HexColor(buttonTextColor),
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void showResetPasswordDialog(BuildContext context) {
    final TextEditingController resetEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: HexColor(frameColor),
          title: Text(
              textAlign: TextAlign.center,
              'loginScreen.resetPasswordTitle'.tr()),
          content: TextField(
            autofocus: true,
            controller: resetEmailController,
            decoration: InputDecoration(
                labelText: 'loginScreen.resetPasswordInput'.tr(),
                labelStyle: TextStyle(color: HexColor(black)),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor(black), width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                )),
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor(buttonColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                  style: TextStyle(color: HexColor(buttonTextColor)),
                  'loginScreen.resetPasswordCancelButton'.tr()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor(buttonColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              onPressed: () {
                authProvider.resetPassword(
                  email: resetEmailController.text,
                  context: context,
                );
                Navigator.of(context).pop();
              },
              child: Text(
                  style: TextStyle(color: HexColor(buttonTextColor)),
                  'loginScreen.resetPasswordSendButton'.tr()),
            ),
          ],
        );
      },
    );
  }
}
