import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/utils/context_extensiton.dart';

class HowToUseScreen extends StatelessWidget {
  const HowToUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: HexColor(appBarColor),
      iconTheme: IconThemeData(color: HexColor(appBarIconColor)),
      centerTitle: true,
      title: Text(
        "howToUseScreen.title".tr(),
        style: TextStyle(color: HexColor(appBarTitleColor)),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
          horizontal: context.dynamicWidth(0.02),
          vertical: context.dynamicHeight(0.02)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(children: [
          buildButton(
              context: context,
              buttonText: "homeScreen.createButton",
              onPressed: () {},
              icon: CupertinoIcons.create),
          //   const Spacer(flex: 2)
          // ]),
          buildListTile("howToUseScreen.listText".tr()),
          buildListTile("howToUseScreen.listText".tr()),
          buildListTile("howToUseScreen.listText".tr()),
          buildButton(
              context: context,
              buttonText: "homeScreen.updateButton",
              onPressed: () {},
              icon: CupertinoIcons.settings),
          buildListTile("howToUseScreen.listText".tr()),
          buildListTile("howToUseScreen.listText".tr()),
          buildListTile("howToUseScreen.listText".tr()),
          buildButton(
              context: context,
              buttonText: "homeScreen.databaseButton",
              onPressed: () {},
              icon: CupertinoIcons.layers_alt),
          buildListTile("howToUseScreen.listText".tr()),
          buildListTile("howToUseScreen.listText".tr()),
          buildListTile("howToUseScreen.listText".tr()),
          buildButton(
              context: context,
              buttonText: "homeScreen.deleteButton",
              onPressed: () {},
              icon: CupertinoIcons.delete),
          buildListTile("howToUseScreen.listText".tr()),
          buildListTile("howToUseScreen.listText".tr()),
          buildListTile("howToUseScreen.listText".tr()),
          buildButton(
              context: context,
              buttonText: "homeScreen.wifiButton",
              onPressed: () {},
              icon: CupertinoIcons.wifi),
          buildListTile("howToUseScreen.listText".tr()),
          buildListTile("howToUseScreen.listText".tr()),
          buildListTile("howToUseScreen.listText".tr()),
          buildButton(
              context: context,
              buttonText: "homeScreen.scanButton",
              onPressed: () {},
              icon: CupertinoIcons.camera_viewfinder),
          buildListTile("howToUseScreen.listText".tr()),
          buildListTile("howToUseScreen.listText".tr()),
          buildListTile("howToUseScreen.listText".tr()),
          buildButton(
              context: context,
              buttonText: "homeScreen.changePasswordButton",
              onPressed: () {},
              icon: CupertinoIcons.lock_rotation),
          buildListTile("howToUseScreen.listText".tr()),
          buildListTile("howToUseScreen.listText".tr()),
          buildListTile("howToUseScreen.listText".tr()),
        ],
      ),
    );
  }

  Widget buildListTile(String title) {
    return ListTile(
      leading: Icon(CupertinoIcons.dot_square_fill),
      title: Text(title),
    );
  }

  SizedBox buildButton(
      {required BuildContext context,
      required String buttonText,
      required VoidCallback onPressed,
      required IconData icon,
      double? minimumSize,
      bool useRowWidget = false}) {
    return SizedBox(
      width: context.dynamicWidth(0.3),
      height: context.dynamicHeight(0.135),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            // minimumSize:
            //     Size.fromHeight(minimumSize ?? context.dynamicHeight(0.13)),
            backgroundColor: HexColor(homeScreenButtonColor)),
        onPressed: onPressed,
        child: useRowWidget
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(
                  icon,
                  size: context.dynamicHeight(0.045),
                  color: HexColor(white),
                ),
                SizedBox(width: context.dynamicWidth(0.08)),
                Text(
                    style: TextStyle(
                        fontSize: 15, color: HexColor(buttonTextColor)),
                    buttonText.tr()),
              ])
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(
                  icon,
                  size: context.dynamicHeight(0.045),
                  color: HexColor(white),
                ),
                SizedBox(height: context.dynamicHeight(0.01)),
                Text(
                    style: TextStyle(
                        fontSize: 15, color: HexColor(buttonTextColor)),
                    buttonText.tr()),
              ]),
      ),
    );
  }
}
