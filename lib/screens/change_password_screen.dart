import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/custom_widgets/bottom_bar_widget.dart';
import 'package:nfc_tool/custom_widgets/change_password_screen_widget.dart';
import 'package:nfc_tool/utils/context_extensiton.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  ChangePasswordScreenWidget changePasswordScreenWidget =
      ChangePasswordScreenWidget();
  BottomBarWidget bottomBarWidget = BottomBarWidget();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      bottomNavigationBar: bottomBarWidget.buildBottomBar(context),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: HexColor(appBarColor),
      iconTheme: IconThemeData(color: HexColor(appBarIconColor)),
      centerTitle: true,
      title: Text(
        "changepasswordScreen.title".tr(),
        style: TextStyle(color: HexColor(appBarTitleColor)),
      ),
    );
  }

  SingleChildScrollView buildBody() {
    return SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: context.dynamicWidth(0.015),
              vertical: context.dynamicHeight(0.015)),
          child: Form(
              // key: formKey,
              child: Column(
            children: [
              changePasswordScreenWidget.buildInput(
                  context: context,
                  labelText: "changepasswordScreen.inputLabel.lastPassword",
                  onSaved: (value) {}),
              changePasswordScreenWidget.buildInput(
                  context: context,
                  labelText: "changepasswordScreen.inputLabel.newPassword",
                  onSaved: (value) {}),
              changePasswordScreenWidget.buildInput(
                  context: context,
                  labelText: "changepasswordScreen.inputLabel.confirmPassword",
                  onSaved: (value) {})
            ],
          ))),
    );
  }
}
