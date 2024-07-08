import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/utils/media_query/context_extensiton.dart';

class EditScreenWidget {
  Padding buildInput(
      {required BuildContext context,
      required String labelText,
      required IconData icon,
      required String initValue,
      required ValueSetter<String?> onSaved,
      int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.dynamicHeight(0.015)),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: labelText.tr(),
          labelStyle: TextStyle(color: HexColor(black)),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor(black), width: 1.5)),
        ),
        onSaved: onSaved,
        maxLines: maxLines,
        initialValue: initValue,
      ),
    );
  }
}
