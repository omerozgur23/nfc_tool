import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key, required this.tag});
  final NFCTag tag;
  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor(backgroundColor),
        centerTitle: true,
        title: Text("writeScreen.title".tr()),
      ),
      body: buildWriteScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: saveCardData,
        child: const Icon(Icons.save),
      ),
    );
  }

  // Widget buildWriteScreen() {
  //   return Container(
  //     margin: const EdgeInsets.all(20.0),
  //     child: Column(
  //       children: [
  //         buildButton(
  //             buttonText: "writeScreen.addButton",
  //             buttonIcon: Icons.add,
  //             onPressed: () {}),
  //         const SizedBox(
  //           height: 5,
  //         ),
  //         buildButton(
  //             buttonText: "writeScreen.optionsButton",
  //             buttonIcon: Icons.settings,
  //             onPressed: () {}),
  //         Text("NFC ID : ${widget.tag.id}")
  //       ],
  //     ),
  //   );
  // }
  Widget buildWriteScreen() {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text("NFC ID : ${widget.tag.id}"),
        ],
      ),
    );
  }

  // Widget buildButton(
  //     {required String buttonText,
  //     required IconData buttonIcon,
  //     required VoidCallback onPressed}) {
  //   return ElevatedButton(
  //       style: ElevatedButton.styleFrom(
  //           backgroundColor: HexColor(buttonColor),
  //           minimumSize: const Size.fromHeight(50)),
  //       onPressed: onPressed,
  //       child: Row(
  //         children: [
  //           Icon(
  //             buttonIcon,
  //             color: HexColor(buttonTextColor),
  //           ),
  //           const SizedBox(
  //             width: 10,
  //           ),
  //           Text(
  //               style:
  //                   TextStyle(color: HexColor(buttonTextColor), fontSize: 16),
  //               buttonText.tr())
  //         ],
  //       ));
  // }

  void saveCardData() async {
    // Girilen telefon numarası
    String phoneNumber = _phoneController.text;

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a phone number")));
      return;
    }

    // Kullanıcıya NFC kartı okutmasını isteyen bir dialog gösterme
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
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

    try {
      var tag = await FlutterNfcKit.poll();

      // NFC kartına yazma işlemi
      await FlutterNfcKit.transceive('write NDEF: TEL:$phoneNumber');

      Navigator.of(context).pop(); // Dialogu kapat
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Phone number written to NFC card successfully")));
    } catch (e) {
      Navigator.of(context).pop(); // Dialogu kapat
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.error, color: Colors.red, size: 50),
                SizedBox(height: 20),
                Text('Failed to write data to NFC card'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
