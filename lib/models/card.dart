import 'dart:io';

class Card {
  int? id;
  File? profileImage;
  String? fullName;
  String? companyName;
  String? jobTitle;
  String? phone;
  String? mobilePhone;
  String? email;
  String? website;
  String? address;

  Card(
    this.profileImage,
    this.fullName,
    this.companyName,
    this.jobTitle,
    this.phone,
    this.mobilePhone,
    this.email,
    this.website,
    this.address,
  );
}
