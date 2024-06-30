import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/utils/context_extensiton.dart';

class BottomBarWidget {
  Container buildBottomBar(BuildContext context, VoidCallback onPressed) {
    return Container(
      color: HexColor(buttonColor),
      padding: EdgeInsets.symmetric(
          horizontal: context.dynamicWidth(0.05),
          vertical: context.dynamicHeight(0.01)),
      child: Row(
        children: [
          SizedBox(
            width: context.dynamicWidth(0.1),
          ),
          Expanded(
            child: buildBottomBarButton(
              context: context,
              buttonText: "writeScreen.cancelButton",
              onpressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          SizedBox(width: context.dynamicWidth(0.05)),
          Expanded(
              child: buildBottomBarButton(
            context: context,
            buttonText: "writeScreen.saveButton",
            onpressed: onPressed,
          )),
          SizedBox(
            width: context.dynamicWidth(0.1),
          ),
        ],
      ),
    );
  }

  ElevatedButton buildBottomBarButton(
      {required BuildContext context,
      required String buttonText,
      required VoidCallback onpressed}) {
    return ElevatedButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        backgroundColor: HexColor(appBarColor),
      ),
      child: Text(
        buttonText.tr(),
        style: TextStyle(
            fontSize: context.dynamicHeight(0.02),
            color: HexColor(buttonTextColor)),
      ),
    );
  }
}
