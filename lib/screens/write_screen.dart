import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/custom_widgets/bottom_bar_widget.dart';
import 'package:nfc_tool/custom_widgets/write_screen_widget.dart';
import 'package:nfc_tool/models/card.dart' as card;
// import 'package:ndef/ndef.dart' as ndef;
// import 'package:ndef/record.dart';
// import 'package:ndef/records/media/mime.dart';
// import 'package:ndef/records/well_known/text.dart';
// import 'package:ndef/records/well_known/uri.dart';
// import 'package:ndef/utilities.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/utils/context_extensiton.dart';
import 'package:image_picker/image_picker.dart';
// import 'dart:convert'; // UTF-8 encode işlemi için gerekli
// import 'dart:typed_data';
// import 'package:vcf_dart/vcf_dart.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});
  // final NFCTag tag;
  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  WriteScreenWidget writeScreenWidget = WriteScreenWidget();
  BottomBarWidget bottomBarWidget = BottomBarWidget();
  var formKey = GlobalKey<FormState>();
  card.Card createCard = card.Card(null, "", "", "", "", "", "", "", "", "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      bottomNavigationBar: bottomBarWidget.buildBottomBar(context),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: HexColor(appBarColor),
      iconTheme: IconThemeData(color: HexColor(appBarIconColor)),
      centerTitle: true,
      title: Text(
        "writeScreen.title".tr(),
        style: TextStyle(color: HexColor(appBarTitleColor)),
      ),
    );
  }

  SingleChildScrollView buildBody() {
    return SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: context.dynamicWidth(0.015),
              vertical: context.dynamicHeight(0.015)),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  buildProfilePhotoPicker(),
                  SizedBox(
                    height: context.dynamicHeight(0.015),
                  ),
                  writeScreenWidget.buildInput(
                      context: context,
                      labelText: "writeScreen.inputLabel.fullName",
                      icon: CupertinoIcons.person_alt_circle,
                      onSaved: (value) {
                        createCard.fullName = value;
                      }),
                  writeScreenWidget.buildInput(
                      context: context,
                      labelText: "writeScreen.inputLabel.companyName",
                      icon: CupertinoIcons.building_2_fill,
                      onSaved: (value) {
                        createCard.companyName = value;
                      }),
                  writeScreenWidget.buildInput(
                      context: context,
                      labelText: "writeScreen.inputLabel.jobTitle",
                      icon: CupertinoIcons.briefcase,
                      onSaved: (value) {
                        createCard.jobTitle = value;
                      }),
                  writeScreenWidget.buildInput(
                      context: context,
                      labelText: "writeScreen.inputLabel.phone",
                      icon: CupertinoIcons.phone,
                      onSaved: (value) {
                        createCard.phone = value;
                      }),
                  writeScreenWidget.buildInput(
                      context: context,
                      labelText: "writeScreen.inputLabel.mobilePhone",
                      icon: CupertinoIcons.device_phone_portrait,
                      onSaved: (value) {
                        createCard.mobilePhone = value;
                      }),
                  writeScreenWidget.buildInput(
                      context: context,
                      labelText: "writeScreen.inputLabel.email",
                      icon: CupertinoIcons.mail,
                      onSaved: (value) {
                        createCard.email = value;
                      }),
                  writeScreenWidget.buildInput(
                      context: context,
                      labelText: "writeScreen.inputLabel.website",
                      icon: CupertinoIcons.link,
                      onSaved: (value) {
                        createCard.website = value;
                      }),
                  writeScreenWidget.buildInput(
                      context: context,
                      labelText: "writeScreen.inputLabel.address",
                      icon: CupertinoIcons.location,
                      onSaved: (value) {
                        createCard.address = value;
                      }),
                  writeScreenWidget.buildInput(
                      context: context,
                      labelText: "writeScreen.inputLabel.notes",
                      icon: CupertinoIcons.square_pencil,
                      maxLines: 3,
                      onSaved: (value) {
                        createCard.notes = value;
                      }),
                ],
              ))),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        createCard.profileImage = File(pickedFile.path);
      });
    } else {
      throw "No Image File";
    }
  }

  Widget buildProfilePhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey[200],
        backgroundImage: createCard.profileImage != null
            ? FileImage(createCard.profileImage!)
            : null,
        child: createCard.profileImage == null
            ? Icon(
                CupertinoIcons.profile_circled,
                size: 40,
                color: Colors.grey[800],
              )
            : null,
      ),
    );
  }

  // Text("NFC ID : ${widget.tag.id}"),
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
