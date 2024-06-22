import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/screens/home_screen.dart';
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

  PreferredSize buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          color: HexColor(appBarColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3), // Yalnızca y ekseninde gölge
            ),
          ],
        ),
        child: AppBar(
          centerTitle: true,
          title: Text(
            "loginScreen.title",
            style: TextStyle(color: HexColor(appBarTitleColor)),
          ).tr(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: HexColor(appBarIconColor)),
        ),
      ),
    );
  }

  Widget buildLoginForm() {
    return SingleChildScrollView(
      child: Container(
        height: 550,
        padding: const EdgeInsets.fromLTRB(25, 50, 25, 50),
        margin: const EdgeInsets.fromLTRB(25, 130, 25, 130),
        decoration: BoxDecoration(color: HexColor(frameColor)),
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
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(0.0)),
        ),
      ),
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
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0.0))),
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
          shape: const ContinuousRectangleBorder(),
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

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                    size: 50,
                  ),
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
}
