import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:ndef/record.dart';
import 'package:ndef/records/media/mime.dart';
import 'package:ndef/records/well_known/text.dart';
import 'package:ndef/records/well_known/uri.dart';
import 'package:ndef/utilities.dart';
import 'package:nfc_tool/constants/color.dart';
import 'dart:convert'; // UTF-8 encode işlemi için gerekli
import 'dart:typed_data';
import 'package:vcf_dart/vcf_dart.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});
  // final NFCTag tag;
  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor(appBarColor),
        iconTheme: IconThemeData(color: HexColor(appBarIconColor)),
        centerTitle: true,
        title: Text(
          "writeScreen.title".tr(),
          style: TextStyle(color: HexColor(appBarTitleColor)),
        ),
      ),
      body: buildWriteScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // writeToCard(context: context);
          // checkNfcTagSize();
        },
        child: const Icon(Icons.save),
      ),
    );
  }

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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Text("NFC ID : ${widget.tag.id}"),
        ],
      ),
    );
  }

  // Future writeToCard({required BuildContext context}) async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Approach an NFC Card"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             Image.asset('assets/gif/nfc.gif'),
  //             const SizedBox(height: 20),
  //             const Text("Please tap your NFC card to the phone"),
  //           ],
  //         ),
  //       );
  //     },
  //   );

  //   var availability = await FlutterNfcKit
  //       .nfcAvailability; // Cihazın NFC özelliği açık mı değil mi sonucunu alıyor
  //   if (availability == NFCAvailability.available) {
  //     // Okutulacak NFC bilgisini alır. !0 sn içinde alamazsa zaman aşımına uğrar
  //     var tag = await FlutterNfcKit.poll(
  //       timeout: const Duration(seconds: 10),
  //     );

  //     // String phoneNumber = _phoneController.text;
  //     // var uriPhone = ndef.UriRecord.fromString(_phoneController.text);
  //     // String name = _nameController.text;
  //     // var uriName = ndef.UriRecord.fromString(_nameController.text);
  //     // List<String> list = [name, phoneNumber];
  //     // var ndefRecords = [uriName, uriPhone];
  //     const localStr = """BEGIN:VCARD
  //     VERSION:3.0
  //     N:User;Test
  //     FN:Test User
  //     EMAIL;TYPE=HOME:test@mail.com
  //     END:VCARD""";
  //     // vCard oluşturun
  //   final stack = VCardStack();
  //   final builder = VCardItemBuilder()
  //     ..addProperty(
  //       VCardProperty(
  //         name: VConstants.name,
  //         values: [_nameController.text], // Test kısmını kendinize göre ayarlayın
  //       ),
  //     )
  //     ..addPropertyFromEntry(
  //       VConstants.formattedName,
  //       _nameController.text, // Test kısmını kendinize göre ayarlayın
  //     )
  //     ..addProperty(
  //       VCardProperty(
  //         name: VConstants.email,
  //         nameParameters: [
  //           VCardNameParameter(
  //             VConstants.nameParamType,
  //             VConstants.phoneTypeHome,
  //           ),
  //         ],
  //         values: [_phoneController.text],
  //       ),
  //     );
  //   stack.items.add(builder.build());

  //   // vCard'ı NFC kaydına dönüştürün
  //   var vCardData = stack.toString();

  //     try {
  //       if (tag.ndefWritable != null && tag.ndefWritable!) {
  //         // await FlutterNfcKit.writeNDEFRecords(ndefRecords);
  //         // NDEF mesajı oluşturun
  //         var ndefMessage = NdefMessage(records: [
  //           MimeRecord(
  //             type: 'text/vcard',
  //             payload: utf8.encode(vCardData),
  //             isReadOnly: true,
  //           ),
  //         ]);

  //         // NFC kaydına yazın
  //         await FlutterNfcKit.writeNDEFRecords([ndefMessage]);

  //         // await FlutterNfcKit.writeNDEFRecords([
  //         //   UriRecord.fromString(phoneNumber),
  //         //   UriRecord.fromString(name),
  //         // ]);
  //       }
  //     } catch (ex) {
  //       print(ex);
  //     }

  //     try {
  //       List<String> data = stringToHexList(_phoneController.text);
  //       if (tag.type == NFCTagType.iso15693) {
  //         await FlutterNfcKit.writeBlock(
  //           1, // index
  //           data, // data
  //           iso15693Flags: Iso15693RequestFlags(),
  //           iso15693ExtendedMode: false,
  //         );
  //       }
  //     } catch (ex) {
  //       print(ex);
  //     }

  //     Navigator.of(context).pop();
  //   } else {
  //     Navigator.of(context).pop();
  //     showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text("Error"),
  //             content: const Text("NFC is not available on this device"),
  //             actions: [
  //               TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: const Text("OK"))
  //             ],
  //           );
  //         });
  //   }
  // }

  List<String> stringToHexList(String input) {
    List<String> hexList = [];
    for (int i = 0; i < input.length; i++) {
      hexList.add(input.codeUnitAt(i).toRadixString(16).padLeft(2, '0'));
    }
    return hexList;
  }

  Future<void> checkNfcTagSize() async {
    var tag = await FlutterNfcKit.poll(timeout: Duration(seconds: 10));
    if (tag.ndefCapacity != null) {
      int capacity = tag.ndefCapacity!;
      print("NFC etiket kapasitesi: $capacity bytes");
    } else {
      print("NFC etiket kapasitesi bilgisi alınamadı.");
    }
  }
}
