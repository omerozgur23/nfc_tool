import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/utils/context_extensiton.dart';
import 'package:nfc_tool/auth/auth_provider.dart' as custom_provider;
import 'package:nfc_tool/custom_widgets/home_screen_widget.dart'
    as custom_widget;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final custom_provider.AuthProvider _authProvider =
      custom_provider.AuthProvider();

  final custom_widget.HomeScreenWidget customWidget =
      custom_widget.HomeScreenWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(black),
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: HexColor(appBarColor),
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        customWidget.buildAppBarButton(
            context: context,
            leftPadding: context.dynamicWidth(0.01),
            text: "homeScreen.howToUseButton",
            onPressed: () {}),
        customWidget.buildAppBarButton(
            context: context,
            rightPadding: context.dynamicWidth(0.01),
            text: "homeScreen.signOutButton",
            onPressed: () => _authProvider.signOut(context))
      ]),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.05)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customWidget.buildButtonRow(context: context, buttons: [
            customWidget.buildButton(
                context: context,
                buttonText: "homeScreen.createButton",
                onPressed: () => navigateToWrite(),
                icon: CupertinoIcons.create),
            customWidget.buildButton(
                context: context,
                buttonText: "homeScreen.updateButton",
                onPressed: () => navigateToWrite(),
                icon: CupertinoIcons.settings)
          ]),
          SizedBox(height: context.dynamicHeight(0.02)),
          customWidget.buildButtonRow(context: context, buttons: [
            customWidget.buildButton(
                context: context,
                buttonText: "homeScreen.databaseButton",
                onPressed: () => navigateToWrite(),
                icon: CupertinoIcons.layers_alt),
            customWidget.buildButton(
                context: context,
                buttonText: "homeScreen.deleteButton",
                onPressed: () => navigateToWrite(),
                icon: CupertinoIcons.delete)
          ]),
          SizedBox(height: context.dynamicHeight(0.02)),
          customWidget.buildButtonRow(context: context, buttons: [
            customWidget.buildButton(
                context: context,
                buttonText: "homeScreen.wifiButton",
                onPressed: () => navigateToWrite(),
                icon: CupertinoIcons.wifi),
            customWidget.buildButton(
                context: context,
                buttonText: "homeScreen.scanButton",
                onPressed: () => navigateToWrite(),
                icon: CupertinoIcons.camera_viewfinder)
          ]),
          SizedBox(height: context.dynamicHeight(0.02)),
          customWidget.buildButtonRow(context: context, buttons: [
            customWidget.buildButton(
                context: context,
                useRowWidget: true,
                minimumSize: context.dynamicHeight(0.1),
                buttonText: "homeScreen.changePasswordButton",
                onPressed: () => navigateToWrite(),
                icon: CupertinoIcons.lock_rotation)
          ]),
        ],
      ),
    );
  }

  navigateToWrite() async {
    Navigator.of(context).pushNamed("/write");
  }
}
