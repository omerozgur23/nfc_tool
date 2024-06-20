import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text("loginScreen.title").tr(),
        backgroundColor: HexColor(backgroundColor),
      ),
      body: buildLoginForm(),
    );
  }

  Widget buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildEmailInput(),
            const SizedBox(height: 16.0),
            buildPasswordInput(),
            const SizedBox(height: 16.0),
            buildSignInButton(),
            const SizedBox(height: 16.0),
            buildChangeLanguageButton()
          ],
        ),
      ),
    );
  }

  Widget buildEmailInput() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        labelText: "loginScreen.emailInput".tr(),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
      ),
    );
  }

  Widget buildPasswordInput() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          labelText: "loginScreen.passwordInput".tr(),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              icon:
                  Icon(obscureText ? Icons.visibility : Icons.visibility_off))),
      obscureText: obscureText,
    );
  }

  Widget buildSignInButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: HexColor(buttonColor),
          minimumSize: const Size.fromHeight(50)),
      onPressed: signInWithEmailAndPassword,
      child: Text(
          style: TextStyle(
              color: HexColor(languageButtonTextColor),
              fontSize: 20,
              fontWeight: FontWeight.w500),
          "loginScreen.signInButton".tr()),
    );
  }

  Widget buildChangeLanguageButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: HexColor(buttonColor),
            minimumSize: const Size.fromHeight(50)),
        onPressed: (() => navigateToLanguageScreen)(),
        child: Text(
            style: TextStyle(
                color: HexColor(languageButtonTextColor),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in. Please check your credentials.'),
        ),
      );
    }
  }
}
