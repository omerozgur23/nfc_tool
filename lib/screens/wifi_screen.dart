import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/custom_widgets/bottom_bar_widget.dart';
import 'package:nfc_tool/custom_widgets/wifi_screen_widget.dart';
import 'package:nfc_tool/enums/wifi_authentications.dart';
import 'package:nfc_tool/enums/wifi_encryptions.dart';
import 'package:nfc_tool/utils/context_extensiton.dart';

class WifiScreen extends StatefulWidget {
  const WifiScreen({super.key});

  @override
  State<WifiScreen> createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {
  WifiScreenWidget wifiScreenWidget = WifiScreenWidget();
  BottomBarWidget bottomBarWidget = BottomBarWidget();
  var formKey = GlobalKey<FormState>();
  List<WifiAuthenticationType> authenticationList =
      WifiAuthenticationType.values;
  List<WifiEncryptionsType> encryptionList = WifiEncryptionsType.values;

  TextEditingController ssidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? selectedAuthentication;
  String? selectedEncryption;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      bottomNavigationBar: bottomBarWidget.buildBottomBar(context, () {}),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: HexColor(appBarColor),
      iconTheme: IconThemeData(color: HexColor(appBarIconColor)),
      centerTitle: true,
      title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(CupertinoIcons.wifi),
        SizedBox(
          width: context.dynamicWidth(0.02),
        ),
        Text(
          "wifiScreen.title".tr(),
          style: TextStyle(color: HexColor(appBarTitleColor)),
        ),
        SizedBox(
          width: context.dynamicWidth(0.1),
        )
      ]),
    );
  }

  SingleChildScrollView buildBody() {
    return SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: context.dynamicWidth(0.015),
              vertical: context.dynamicHeight(0.015)),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  wifiScreenWidget.buildSelect(
                      context: context,
                      labelText: "wifiScreen.inputLabel.authentication",
                      options:
                          authenticationList.map((e) => e.displayName).toList(),
                      onChanged: (selectedOption) {
                        selectedAuthentication = selectedOption;
                      }),
                  wifiScreenWidget.buildSelect(
                      context: context,
                      labelText: "wifiScreen.inputLabel.encryption",
                      options:
                          encryptionList.map((e) => e.displayName).toList(),
                      onChanged: (selectedOption) {
                        selectedEncryption = selectedOption;
                      }),
                  wifiScreenWidget.buildInput(
                      context: context,
                      labelText: "wifiScreen.inputLabel.ssid",
                      onSaved: (value) {
                        ssidController.text = value!;
                      }),
                  wifiScreenWidget.buildInput(
                      context: context,
                      labelText: "wifiScreen.inputLabel.password",
                      onSaved: (value) {
                        passwordController.text = value!;
                      })
                ],
              ))),
    );
  }
}
