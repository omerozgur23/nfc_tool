import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';

class DatabaseScreenWidget {
  DataColumn buildColumn({required String title, bool numeric = false}) {
    return DataColumn(
      label: Text(
        title.tr(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      numeric: numeric,
    );
  }
}
