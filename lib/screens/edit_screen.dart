// import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:nfc_tool/custom_widgets/bottom_bar_widget.dart';
import 'package:nfc_tool/custom_widgets/edit_screen_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/exceptions/business_exception.dart';
import 'package:nfc_tool/models/card.dart' as card;
import 'package:nfc_tool/services/nfc_writer.dart';
import 'package:nfc_tool/utils/media_query/context_extensiton.dart';
import 'package:nfc_tool/models/card.dart' as c;
import 'package:nfc_tool/utils/vcard/vcard_creator.dart';

class EditScreen extends StatefulWidget {
  final c.Card card;

  const EditScreen({super.key, required this.card});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  EditScreenWidget editScreenWidget = EditScreenWidget();
  BottomBarWidget bottomBarWidget = BottomBarWidget();
  var formKey = GlobalKey<FormState>();
  late c.Card createCard;

  @override
  void initState() {
    super.initState();
    createCard = widget.card;
  }

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
        "editScreen.title".tr(),
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
                  editScreenWidget.buildInput(
                      context: context,
                      labelText: "editScreen.inputLabel.fullName",
                      icon: CupertinoIcons.person_alt_circle,
                      initValue: createCard.fullName!,
                      onSaved: (value) {
                        createCard.fullName = value;
                      }),
                  editScreenWidget.buildInput(
                      context: context,
                      labelText: "editScreen.inputLabel.companyName",
                      icon: CupertinoIcons.building_2_fill,
                      initValue: createCard.companyName!,
                      onSaved: (value) {
                        createCard.companyName = value;
                      }),
                  editScreenWidget.buildInput(
                      context: context,
                      labelText: "editScreen.inputLabel.jobTitle",
                      icon: CupertinoIcons.briefcase,
                      initValue: createCard.jobTitle!,
                      onSaved: (value) {
                        createCard.jobTitle = value;
                      }),
                  editScreenWidget.buildInput(
                      context: context,
                      labelText: "editScreen.inputLabel.phone",
                      initValue: createCard.phone!,
                      icon: CupertinoIcons.phone,
                      onSaved: (value) {
                        createCard.phone = value;
                      }),
                  editScreenWidget.buildInput(
                      context: context,
                      labelText: "editScreen.inputLabel.mobilePhone",
                      icon: CupertinoIcons.device_phone_portrait,
                      initValue: createCard.mobilePhone!,
                      onSaved: (value) {
                        createCard.mobilePhone = value;
                      }),
                  editScreenWidget.buildInput(
                      context: context,
                      labelText: "editScreen.inputLabel.email",
                      icon: CupertinoIcons.mail,
                      initValue: createCard.email!,
                      onSaved: (value) {
                        createCard.email = value;
                      }),
                  editScreenWidget.buildInput(
                      context: context,
                      labelText: "editScreen.inputLabel.website",
                      icon: CupertinoIcons.link,
                      initValue: createCard.website!,
                      onSaved: (value) {
                        createCard.website = value;
                      }),
                  editScreenWidget.buildInput(
                      context: context,
                      labelText: "editScreen.inputLabel.address",
                      icon: CupertinoIcons.location,
                      initValue: createCard.address!,
                      onSaved: (value) {
                        createCard.address = value;
                      }),
                ],
              ))),
    );
  }

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
}
