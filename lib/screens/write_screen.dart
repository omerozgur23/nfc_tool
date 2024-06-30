import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ndef/ndef.dart';
import 'package:nfc_tool/custom_widgets/bottom_bar_widget.dart';
import 'package:nfc_tool/custom_widgets/write_screen_widget.dart';
import 'package:nfc_tool/models/card.dart' as card;
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/utils/context_extensiton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});
  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  WriteScreenWidget writeScreenWidget = WriteScreenWidget();
  BottomBarWidget bottomBarWidget = BottomBarWidget();
  var formKey = GlobalKey<FormState>();
  card.Card createCard = card.Card(null, "", "", "", "", "", "", "", "");

  var tagId;
  int totalBytes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      bottomNavigationBar: bottomBarWidget.buildBottomBar(context, () {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          writeVCardToNfcTag();
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
                  Text("Tag ID : ${tagId.toString()}"),
                  Text("Total Bytes: $totalBytes"),
                  ElevatedButton(
                    onPressed: checkNfcTagSize,
                    child: Text('Check NFC Tag'),
                  ),
                  ElevatedButton(
                    onPressed: createNFCCardDocument,
                    child: Text('Add Firestore'),
                  ),
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

  Future<void> checkNfcTagSize() async {
    showNFCDialog();
    try {
      var tag = await FlutterNfcKit.poll(timeout: const Duration(seconds: 10));
      setState(() {
        tagId = tag.id;
      });
      Navigator.of(context, rootNavigator: true).pop();
    } catch (e) {
      // print("NFC etiketini okuma hatası: $e");
    }
  }

  Future<void> writeVCardToNfcTag() async {
    showNFCDialog();

    // VCard verisini manuel olarak string formatında oluşturma
    StringBuffer vCardBuffer = StringBuffer();
    vCardBuffer.write("BEGIN:VCARD\n");
    vCardBuffer.write("VERSION:3.0\n");

    if (createCard.profileImage != null &&
        createCard.profileImage!.path.isNotEmpty) {
      String base64Image =
          base64Encode(await createCard.profileImage!.readAsBytes());
      vCardBuffer.write("PHOTO;ENCODING=b;TYPE=image/jpeg:$base64Image\n");
    }
    if (createCard.fullName != null && createCard.fullName!.isNotEmpty) {
      vCardBuffer.write("FN:${createCard.fullName}\n");
    }
    if (createCard.companyName != null && createCard.companyName!.isNotEmpty) {
      vCardBuffer.write("ORG:${createCard.companyName}\n");
    }
    if (createCard.jobTitle != null && createCard.jobTitle!.isNotEmpty) {
      vCardBuffer.write("TITLE:${createCard.jobTitle}\n");
    }
    if (createCard.phone != null && createCard.phone!.isNotEmpty) {
      vCardBuffer.write("TEL;TYPE=WORK,VOICE:${createCard.phone}\n");
    }
    if (createCard.mobilePhone != null && createCard.mobilePhone!.isNotEmpty) {
      vCardBuffer.write("TEL;TYPE=CELL,VOICE:${createCard.mobilePhone}\n");
    }
    if (createCard.email != null && createCard.email!.isNotEmpty) {
      vCardBuffer.write("EMAIL;TYPE=WORK:${createCard.email}\n");
    }
    if (createCard.website != null && createCard.website!.isNotEmpty) {
      vCardBuffer.write("URL:${createCard.website}\n");
    }
    if (createCard.address != null && createCard.address!.isNotEmpty) {
      vCardBuffer.write("ADR;TYPE=WORK,PREF:;;${createCard.address}\n");
      // vCardBuffer.write(
      //     "LABEL;TYPE=WORK,PREF:${createCard.address?.replaceAll(';', '\\;').replaceAll(',', '\\,')}\n");
    }
    vCardBuffer.write("END:VCARD");

    String vCardString = vCardBuffer.toString();
    int vCardByteLength = utf8.encode(vCardString).length;
    totalBytes = vCardByteLength;

    print("vCard Byte Length: $vCardByteLength");

    // NFC etikete yazma
    try {
      var tag = await FlutterNfcKit.poll(timeout: Duration(seconds: 10));
      if (tag.ndefWritable == true) {
        if (vCardByteLength <= tag.ndefCapacity!) {
          await FlutterNfcKit.writeNDEFRecords([
            NDEFRecord(
              tnf: TypeNameFormat.media,
              type: utf8.encode("text/vcard"),
              payload: utf8.encode(vCardString),
            ),
          ]);
          print("NFC etiketine yazma başarılı.");
        } else {
          print("Veri NFC etiket kapasitesini aşıyor.");
        }
      } else {
        print("NFC etiketi yazılabilir değil.");
      }
    } catch (e) {
      print("NFC etiketine yazma hatası: $e");
    } finally {
      await FlutterNfcKit.finish();
    }
  }

  void showNFCDialog() {
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

  Future<void> createNFCCardDocument() async {
    showNFCDialog();
    try {
      // NFC etiketini okut
      var tag = await FlutterNfcKit.poll(timeout: Duration(seconds: 10));

      // Etiketin içeriğini oku
      var ndefRecords = await FlutterNfcKit.readNDEFRecords();
      int usedSize = 0;

      // NDEF records varsa, toplam byte uzunluğunu hesapla
      if (ndefRecords.isNotEmpty) {
        usedSize = ndefRecords.fold<int>(
            0, (prev, record) => prev + record.payload!.length);
      }

      // Firestore referansı
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference nfcCardsCollectionRef =
          firestore.collection('nfc_cards');

      // Döküman verisi hazırla
      Map<String, dynamic> nfcCardData = {
        'is_used': false,
        'serial_number': tag.id,
        'size': tag.ndefCapacity ?? 0, // NFC etiketin kapasitesi
        'used_size': usedSize, // Başlangıçta dolu alan yok
      };

      // Firestore'a döküman ekle
      await nfcCardsCollectionRef.add(nfcCardData);

      print('NFC Card document created successfully.');
      Navigator.of(context, rootNavigator: true).pop();
    } catch (e) {
      print('Error creating NFC Card document: $e');
    } finally {
      await FlutterNfcKit.finish(); // NFC işlemi sonlandır
    }
  }
}
