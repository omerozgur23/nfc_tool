// import 'dart:convert';
// import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:ndef/ndef.dart';
import 'package:nfc_tool/custom_widgets/bottom_bar_widget.dart';
import 'package:nfc_tool/custom_widgets/write_screen_widget.dart';
import 'package:nfc_tool/exceptions/business_exception.dart';
import 'package:nfc_tool/models/card.dart' as card;
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/services/nfc_writer.dart';
import 'package:nfc_tool/utils/media_query/context_extensiton.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:nfc_tool/utils/vcard/vcard_creator.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});
  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  WriteScreenWidget writeScreenWidget = WriteScreenWidget();
  BottomBarWidget bottomBarWidget = BottomBarWidget();
  var formKey = GlobalKey<FormState>();
  card.Card createCard = card.Card("", "", "", "", "", "", "", "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      bottomNavigationBar: bottomBarWidget.buildBottomBar(context, () {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          writeVCardToNfcTag(createCard);
        }
      }),
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
                  // ElevatedButton(
                  //   onPressed: createNFCCardDocument,
                  //   child: const Text('Add Firestore'),
                  // ),
                ],
              ))),
    );
  }

  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile =
  //       await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

  //   if (pickedFile != null) {
  //     setState(() {
  //       createCard.profileImage = File(pickedFile.path);
  //     });
  //   } else {
  //     throw "No Image File";
  //   }
  // }

  // Widget buildProfilePhotoPicker() {
  //   return GestureDetector(
  //     onTap: _pickImage,
  //     child: CircleAvatar(
  //       radius: 40,
  //       backgroundColor: Colors.grey[200],
  //       backgroundImage: createCard.profileImage != null
  //           ? FileImage(createCard.profileImage!)
  //           : null,
  //       child: createCard.profileImage == null
  //           ? Icon(
  //               CupertinoIcons.profile_circled,
  //               size: 40,
  //               color: Colors.grey[800],
  //             )
  //           : null,
  //     ),
  //   );
  // }

  Future<void> writeVCardToNfcTag(card.Card createCard) async {
    final vCardCreator = VCardCreator(createCard);
    final vCardString = vCardCreator.generateVCard();
    final nfcWriter = NFCWriter();
    try {
      nfcWriter.writeToNfcTag(vCardString, context);
    } catch (e) {
      throw BusinessException("Exception : $e");
    }
  }

  // void showNFCDialog() {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: HexColor(white),
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
  // }

  // Future<void> createNFCCardDocument() async {
  //   showNFCDialog();
  //   try {
  //     // NFC etiketini okut
  //     var tag = await FlutterNfcKit.poll(timeout: Duration(seconds: 10));

  //     // Etiketin içeriğini oku
  //     var ndefRecords = await FlutterNfcKit.readNDEFRecords();
  //     int usedSize = 0;

  //     // NDEF records varsa, toplam byte uzunluğunu hesapla
  //     if (ndefRecords.isNotEmpty) {
  //       usedSize = ndefRecords.fold<int>(
  //           0, (prev, record) => prev + record.payload!.length);
  //     }

  //     // Firestore referansı
  //     FirebaseFirestore firestore = FirebaseFirestore.instance;
  //     CollectionReference nfcCardsCollectionRef =
  //         firestore.collection('nfc_cards');

  //     // Döküman verisi hazırla
  //     Map<String, dynamic> nfcCardData = {
  //       'is_used': false,
  //       'serial_number': tag.id,
  //       'size': tag.ndefCapacity ?? 0,
  //       'used_size': usedSize,
  //     };

  //     // Firestore'a döküman ekle
  //     await nfcCardsCollectionRef.add(nfcCardData);

  //     print('NFC Card document created successfully.');
  //     Navigator.of(context, rootNavigator: true).pop();
  //   } catch (e) {
  //     print('Error creating NFC Card document: $e');
  //   } finally {
  //     await FlutterNfcKit.finish();
  //   }
  // }
}
