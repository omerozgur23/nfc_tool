import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/screens/language_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: HexColor(backgroundColor),
      appBar: buildAppBar(),
      body: buildLoginForm(),
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

  Widget buildLoginForm() {
    double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        height: screenHeight * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
        decoration: BoxDecoration(
            color: HexColor(frameColor),
            borderRadius: BorderRadius.circular(5.0)),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildEmailInput(),
              const SizedBox(height: 16.0),
              buildPasswordInput(),
              const SizedBox(height: 16.0),
              Text("loginScreen.forgotPasswordButton".tr()),
              const SizedBox(height: 16.0),
              buildSignInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmailInput() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          labelText: "loginScreen.emailInput".tr(),
          labelStyle: const TextStyle(color: Colors.black),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          )),
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
    );
  }

  Widget buildPasswordInput() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          labelText: "loginScreen.passwordInput".tr(),
          labelStyle: const TextStyle(color: Colors.black),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
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

  Widget buildSignInButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          backgroundColor: HexColor(buttonColor),
          minimumSize: const Size.fromHeight(50),
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          signInWithEmailAndPassword();
        },
        child: Text(
            style: TextStyle(
                color: HexColor(buttonTextColor),
                fontSize: 20,
                fontWeight: FontWeight.w500),
            "loginScreen.signInButton".tr()),
      ),
    );
  }

  Widget buildChangeLanguageButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const ContinuousRectangleBorder(),
            backgroundColor: HexColor(buttonColor),
            minimumSize: const Size.fromHeight(50)),
        onPressed: (() => navigateToLanguageScreen)(),
        child: Text(
            style: TextStyle(
                color: HexColor(buttonTextColor),
                fontSize: 20,
                fontWeight: FontWeight.w500),
            "loginScreen.changeLanguageButton".tr()));
  }

  void navigateToLanguageScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LanguageScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.of(context).pushNamed("/home");
    } catch (e) {
      errorDialog();
    }
  }

  Future<dynamic> errorDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: HexColor(frameColor),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Icon(
                //   Icons.cancel_outlined,
                //   color: HexColor(buttonColor),
                //   size: 50,
                // ),
                Image.asset("assets/gif/error.gif"),
                const SizedBox(
                  height: 20,
                ),
                Text("loginScreen.errorLoginMessage".tr()),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor(buttonColor),
                      shape: const ContinuousRectangleBorder()),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                      style: TextStyle(color: HexColor(buttonTextColor)),
                      "loginScreen.errorDialogOkButton".tr()))
            ],
          );
        });
  }
}
