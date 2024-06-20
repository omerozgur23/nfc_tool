import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/screens/login_screen.dart';
import 'package:nfc_tool/screens/write_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: HexColor(backgroundColor),
        title: Text("homeScreen.title".tr()),
        centerTitle: true,
      ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => signOut()),
        child: const Icon(Icons.logout_rounded),
      ),
    );
  }

  Widget buildBody() {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildButton(
                buttonText: "homeScreen.writeButton",
                onPressed: (() => navigateWritePage())),
            const SizedBox(
              height: 25.0,
            ),
            buildButton(
                buttonText: "homeScreen.updateButton", onPressed: () {}),
            const SizedBox(
              height: 25.0,
            ),
            buildButton(buttonText: "homeScreen.clearButton", onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget buildButton(
      {required String buttonText, required VoidCallback onPressed}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(100),
            backgroundColor: HexColor(buttonColor)),
        onPressed: onPressed,
        child: Text(
            style: TextStyle(fontSize: 25, color: HexColor(buttonTextColor)),
            buttonText.tr()));
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    // Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  navigateWritePage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WriteScreen(),
        ));
  }
}
