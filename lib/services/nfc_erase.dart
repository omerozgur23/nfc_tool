import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ndef/ndef.dart';
import 'package:nfc_tool/constants/color.dart';

class NfcErase {
  Future<void> clearNfcTag(BuildContext context) async {
    try {
      // NFC'nin aktif olup olmadığını kontrol et
      var availability = await FlutterNfcKit.nfcAvailability;
      if (availability == NFCAvailability.available) {
        showNFCDialog(context);

        await FlutterNfcKit.poll();

        NDEFRecord record = NDEFRecord(
          tnf: TypeNameFormat.empty,
          type: Uint8List(0),
          payload: Uint8List(0),
        );

        // NFC etiketine yazın
        await FlutterNfcKit.writeNDEFRecords([record]);
        Navigator.pop(context);
        showSuccessDialog(context, "Success");
        await FlutterNfcKit.finish();
      } else {
        showErrorDialog(context, "NFC not available");
      }
    } catch (e) {
      Navigator.pop(context);
      showErrorDialog(context, "An error occurred. Please try again");
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
