import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
// import 'package:nfc_tool/exceptions/business_exception.dart';
// import 'package:nfc_tool/constants/business_exception_messages.dart';
// import 'package:nfc_tool/rules/write_rules.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:nfc_tool/models/card.dart' as c;

class NFCReader {
  Future<Object> readFromNfcTag(BuildContext context) async {
    try {
      NFCAvailability availability = await FlutterNfcKit.nfcAvailability;
      if (availability == NFCAvailability.available) {
        showNFCDialog(context);
        await FlutterNfcKit.poll(timeout: const Duration(seconds: 20));

        List<ndef.NDEFRecord> ndefRecords =
            await FlutterNfcKit.readNDEFRecords();

        List<String> vCardStrings = parseVCardRecords(ndefRecords);
        if (vCardStrings.isNotEmpty) {
          // İlk vCard kaydını parse et
          String vCardString = vCardStrings.first;

          c.Card card = c.Card(
              _extractVCardField(vCardString, "FN"),
              _extractVCardField(vCardString, "ORG"),
              _extractVCardField(vCardString, "TITLE"),
              _extractVCardField(vCardString, "EMAIL"),
              _extractVCardField(vCardString, "TEL;TYPE=WORK,VOICE"),
              _extractVCardField(vCardString, "TEL;TYPE=CELL,VOICE"),
              _extractVCardField(vCardString, "URL"),
              _extractVCardField(vCardString, "ADR;TYPE=WORK,PREF"));
          return card;
        } else {
          Navigator.pop(context);
          showErrorDialog(context, "There is no record of the business card");
          return {'error': 'vCard kaydı bulunamadı.'};
        }
      } else {
        showErrorDialog(context, "NFC not available");
        return "NFC etkin değil.";
      }
    } catch (e) {
      Navigator.pop(context);
      showErrorDialog(context, "An error occurred. Please try again");
      return "NFC okuma hatası: $e";
    } finally {
      await FlutterNfcKit.finish();
    }
  }

  List<String> parseVCardRecords(List<ndef.NDEFRecord> records) {
    List<String> vCardStrings = [];

    for (var record in records) {
      if (record.tnf == ndef.TypeNameFormat.media &&
          record.type != null &&
          utf8.decode(record.type!) == "text/vcard" &&
          record.payload != null &&
          record.payload!.isNotEmpty) {
        String vCardString = utf8.decode(record.payload!);
        vCardStrings.add(vCardString);
      }
    }

    return vCardStrings;
  }

  String _extractVCardField(String vCardString, String fieldName) {
    RegExp regExp = RegExp('$fieldName:(.+?)\n', multiLine: true);
    Match? match = regExp.firstMatch(vCardString);
    return match?.group(1)?.trim() ?? '';
  }

  void showNFCDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: HexColor(white),
          title: const Text("NFC Etiket Yaklaştırın"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset('assets/gif/nfc.gif'),
              const SizedBox(height: 20),
              const Text("Lütfen NFC etiketinizi telefona dokundurun"),
            ],
          ),
        );
      },
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: HexColor(frameColor),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset("assets/gif/error.gif"),
                const SizedBox(
                  height: 20,
                ),
                Text(message.tr()),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor(buttonColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                      style: TextStyle(color: HexColor(buttonTextColor)),
                      "loginScreen.errorDialogOkButton".tr()))
            ],
          );
        });
  }
}
