import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/screens/edit_screen.dart';
import 'package:nfc_tool/services/nfc_erase.dart';
import 'package:nfc_tool/services/nfc_reader.dart';
import 'package:nfc_tool/utils/media_query/context_extensiton.dart';
import 'package:nfc_tool/auth/auth_provider.dart' as custom_provider;
import 'package:nfc_tool/custom_widgets/home_screen_widget.dart'
    as custom_widget;
// import 'package:permission_handler/permission_handler.dart';
import 'package:nfc_tool/models/card.dart' as c;
import 'package:nfc_tool/utils/page_route/custom_page_route.dart';

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

  final NfcErase nfcErase = NfcErase();
  final NFCReader nfcReader = NFCReader();

  String _scanBarcode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            onPressed: () => navigateToHowToUse()),
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
                onPressed: () => navigateToEdit(context),
                icon: CupertinoIcons.settings)
          ]),
          SizedBox(height: context.dynamicHeight(0.02)),
          customWidget.buildButtonRow(context: context, buttons: [
            customWidget.buildButton(
                context: context,
                buttonText: "homeScreen.databaseButton",
                onPressed: () => navigateToDatabase(),
                icon: CupertinoIcons.layers_alt),
            customWidget.buildButton(
                context: context,
                buttonText: "homeScreen.deleteButton",
                onPressed: () => deleteCard(),
                icon: CupertinoIcons.delete)
          ]),
          SizedBox(height: context.dynamicHeight(0.02)),
          customWidget.buildButtonRow(context: context, buttons: [
            customWidget.buildButton(
                context: context,
                buttonText: "homeScreen.wifiButton",
                onPressed: () => navigateToWifi(),
                icon: CupertinoIcons.wifi),
            customWidget.buildButton(
                context: context,
                buttonText: "homeScreen.scanButton",
                onPressed: () {
                  scanQR();
                  // Navigator.of(context).pushNamed("/test");
                },
                icon: CupertinoIcons.camera_viewfinder)
          ]),
          SizedBox(height: context.dynamicHeight(0.02)),
          customWidget.buildButtonRow(context: context, buttons: [
            customWidget.buildButton(
                context: context,
                useRowWidget: true,
                minimumSize: context.dynamicHeight(0.1),
                buttonText: "homeScreen.changePasswordButton",
                onPressed: () => navigateToChangePassword(),
                icon: CupertinoIcons.lock_rotation)
          ]),
        ],
      ),
    );
  }

  navigateToHowToUse() async {
    Navigator.of(context).pushNamed("/howToUse");
  }

  navigateToWrite() async {
    Navigator.of(context).pushNamed("/write");
  }

  void deleteCard() async {
    try {
      await nfcErase.clearNfcTag(context);
      await FlutterNfcKit.finish(
          iosAlertMessage: "Etiket başarıyla temizlendi!");
    } catch (e) {
      await FlutterNfcKit.finish(
          iosErrorMessage: "Etiket temizleme başarısız oldu: $e");
    }
  }

  Future<void> navigateToEdit(BuildContext context) async {
    var result = await nfcReader.readFromNfcTag(context);
    if (result is c.Card) {
      Navigator.push(context,
          CustomPageRoute(builder: (context) => EditScreen(card: result)));
    }
  }

  navigateToWifi() async {
    Navigator.of(context).pushNamed("/wifi");
  }

  navigateToDatabase() async {
    Navigator.of(context).pushNamed("/database");
  }

  navigateToChangePassword() async {
    Navigator.of(context).pushNamed("/changePassword");
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }
}
