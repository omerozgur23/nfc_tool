import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nfc_tool/utils/context_extensiton.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';

class WifiScreenWidget {
  Padding buildInput(
      {required BuildContext context,
      required String labelText,
      IconData? icon,
      required ValueSetter<String?> onSaved,
      int maxLines = 1,
      bool isPassword = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.dynamicHeight(0.015)),
      child: TextFormField(
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon) : null,
          labelText: labelText.tr(),
          labelStyle: TextStyle(color: HexColor(black)),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor(black), width: 1.5)),
        ),
        onSaved: onSaved,
        maxLines: maxLines,
      ),
    );
  }

  Padding buildSelect({
    required BuildContext context,
    required String labelText,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.dynamicHeight(0.015)),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText.tr(),
          labelStyle: TextStyle(color: HexColor(black)),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor(black), width: 1.5),
          ),
        ),
        items: [
          ...options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
