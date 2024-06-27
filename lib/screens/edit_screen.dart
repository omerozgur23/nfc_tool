import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nfc_tool/custom_widgets/bottom_bar_widget.dart';
import 'package:nfc_tool/custom_widgets/edit_screen_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/models/card.dart' as card;
import 'package:nfc_tool/utils/context_extensiton.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  EditScreenWidget editScreenWidget = EditScreenWidget();
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
                  buildProfilePhotoPicker(),
                  SizedBox(
                    height: context.dynamicHeight(0.015),
                  ),
                  editScreenWidget.buildInput(
                      context: context,
                      labelText: "editScreen.inputLabel.fullName",
                      icon: CupertinoIcons.person_alt_circle,
                      onSaved: (value) {
                        createCard.fullName = value;
                      }),
                  editScreenWidget.buildInput(
                      context: context,
                      labelText: "editScreen.inputLabel.companyName",
                      icon: CupertinoIcons.building_2_fill,
                      onSaved: (value) {
                        createCard.companyName = value;
                      }),
                  editScreenWidget.buildInput(
                      context: context,
                      labelText: "editScreen.inputLabel.jobTitle",
                      icon: CupertinoIcons.briefcase,
                      onSaved: (value) {
                        createCard.jobTitle = value;
                      }),
                  editScreenWidget.buildInput(
                      context: context,
                      labelText: "editScreen.inputLabel.phone",
                      icon: CupertinoIcons.phone,
                      onSaved: (value) {
                        createCard.phone = value;
                      }),
                  editScreenWidget.buildInput(
                      context: context,
                      labelText: "editScreen.inputLabel.mobilePhone",
                      icon: CupertinoIcons.device_phone_portrait,
                      onSaved: (value) {
                        createCard.mobilePhone = value;
                      }),
                  editScreenWidget.buildInput(
                      context: context,
                      labelText: "editScreen.inputLabel.email",
                      icon: CupertinoIcons.mail,
                      onSaved: (value) {
                        createCard.email = value;
                      }),
                  editScreenWidget.buildInput(
                      context: context,
                      labelText: "editScreen.inputLabel.website",
                      icon: CupertinoIcons.link,
                      onSaved: (value) {
                        createCard.website = value;
                      }),
                  editScreenWidget.buildInput(
                      context: context,
                      labelText: "editScreen.inputLabel.address",
                      icon: CupertinoIcons.location,
                      onSaved: (value) {
                        createCard.address = value;
                      }),
                  editScreenWidget.buildInput(
                      context: context,
                      labelText: "editScreen.inputLabel.notes",
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
}
