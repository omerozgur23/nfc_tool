import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ndef/ndef.dart';
import 'package:nfc_tool/constants/business_exception_messages.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/exceptions/business_exception.dart';
import 'package:nfc_tool/rules/write_rules.dart';

class NFCWriter {
  Future<void> writeToNfcTag(String vCardString, BuildContext context) async {
    try {
      if (!await WriteRules.checkNfcAvailable()) {
        showErrorDialog(context, Messages.nfcNotAvailable);
        return;
      }

      showNFCDialog(context);

      var tag = await FlutterNfcKit.poll(timeout: const Duration(seconds: 10));
      WriteRules.checkNfcTagWritable(tag);

      int vCardByteLength = utf8.encode(vCardString).length;
      WriteRules.checkVCardSize(vCardByteLength, tag.ndefCapacity!);

      await FlutterNfcKit.writeNDEFRecords([
        NDEFRecord(
          tnf: TypeNameFormat.media,
          type: utf8.encode("text/vcard"),
          payload: utf8.encode(vCardString),
        )
      ]);
      Navigator.pop(context);
      showSuccessDialog(context, "Successfully");
    } catch (e) {
      showErrorDialog(context, "");
      if (e is BusinessException) {
        rethrow;
      } else {
        throw BusinessException("Error writing to NFC tag: $e");
      }
    } finally {
      await FlutterNfcKit.finish();
    }
  }

  void showNFCDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: HexColor(white),
          title: const Text("Approach an NFC Card"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset('assets/gif/nfc.gif'),
              const SizedBox(height: 20),
              const Text("Please tap your NFC card to the phone"),
            ],
          ),
        );
      },
    );
  }

  void showSuccessDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: HexColor(frameColor),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset("assets/gif/success.gif"),
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
