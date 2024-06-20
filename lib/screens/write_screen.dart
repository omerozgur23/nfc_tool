import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor(backgroundColor),
        centerTitle: true,
        title: Text("writeScreen.title".tr()),
      ),
      body: buildWriteScreen(),
    );
  }

  Widget buildWriteScreen() {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          buildButton(
              buttonText: "writeScreen.addButton",
              buttonIcon: Icons.add,
              onPressed: () {}),
          const SizedBox(
            height: 5,
          ),
          buildButton(
              buttonText: "writeScreen.optionsButton",
              buttonIcon: Icons.settings,
              onPressed: () {})
        ],
      ),
    );
  }

  Widget buildButton(
      {required String buttonText,
      required IconData buttonIcon,
      required VoidCallback onPressed}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: HexColor(buttonColor),
            minimumSize: const Size.fromHeight(50)),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(
              buttonIcon,
              color: HexColor(buttonTextColor),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
                style:
                    TextStyle(color: HexColor(buttonTextColor), fontSize: 16),
                buttonText.tr())
          ],
        ));
  }
}
