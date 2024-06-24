import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/screens/login_screen.dart';
import 'package:nfc_tool/screens/write_screen.dart';
import 'package:nfc_tool/utils/custom_page_route.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: HexColor(appBarColor),
        title: Text(
          "homeScreen.title".tr(),
          style: TextStyle(color: HexColor(appBarTitleColor)),
        ),
        centerTitle: true,
      ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => signOut(context)),
        child: const Icon(Icons.logout_rounded),
      ),
    );
  }

  Widget buildBody() {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      margin: const EdgeInsets.fromLTRB(25, 130, 25, 130),
      decoration: BoxDecoration(color: HexColor(frameColor)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildButton(
                buttonText: "homeScreen.writeButton",
                onPressed: (() => readNfcAndNavigate())),
            // const SizedBox(
            //   height: 25.0,
            // ),
            // buildButton(
            //     buttonText: "homeScreen.updateButton", onPressed: () {}),
            // const SizedBox(
            //   height: 25.0,
            // ),
            // buildButton(buttonText: "homeScreen.clearButton", onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget buildButton(
      {required String buttonText, required VoidCallback onPressed}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const ContinuousRectangleBorder(),
            minimumSize: const Size.fromHeight(90),
            backgroundColor: HexColor(buttonColor)),
        onPressed: onPressed,
        child: Text(
            style: TextStyle(fontSize: 25, color: HexColor(buttonTextColor)),
            buttonText.tr()));
  }

  signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      CustomPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  // readNfcAndNavigate() async {
  //   try {
  //     var tag = await FlutterNfcKit.poll();
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => WriteScreen(tag: tag),
  //         ));
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Nfc okuma başarısız oldu")));
  //   }
  // }

  readNfcAndNavigate() async {
    Navigator.of(context).pushNamed("/write");
//     try {
//       var availability = await FlutterNfcKit.nfcAvailability;
//       if (availability == NFCAvailability.available) {
//         showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: const Text("Approach an NFC Card"),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Image.asset("assets/gif/nfc.gif"),
//                   ],
//                 ),
//               );
//             });
// var tag = await FlutterNfcKit.poll();
//         Navigator.of(context).pop();
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => WriteScreen(tag: tag),
//             ));
//       } else {
//         showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return const AlertDialog(
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Icon(
//                       Icons.error,
//                       color: Colors.red,
//                       size: 50,
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Text("NFC disabled"),
//                   ],
//                 ),
//               );
//             });
//       }
//     } catch (e) {
//       Navigator.of(context).pop();
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return const AlertDialog(
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Icon(
//                     Icons.error,
//                     color: Colors.red,
//                     size: 50,
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Text("NFC okuma başarısız oldu"),
//                 ],
//               ),
//             );
//           });
//     }
  }
}
