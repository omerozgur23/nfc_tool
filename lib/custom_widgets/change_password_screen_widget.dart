import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/utils/context_extensiton.dart';

class ChangePasswordScreenWidget {
  Padding buildInput({
    required BuildContext context,
    required String labelText,
    // IconData? icon,
    required ValueSetter<String?> onSaved,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.dynamicHeight(0.015)),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          labelText: labelText.tr(),
          labelStyle: TextStyle(color: HexColor(black)),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor(black), width: 1.5)),
        ),
        onSaved: onSaved,
      ),
    );
  }
}
