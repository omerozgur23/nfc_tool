import 'dart:io';

class Card {
  int? id;
  // String? profilePhoto;
  File? profileImage;
  String? fullName;
  String? companyName;
  String? jobTitle;
  String? phone;
  String? mobilePhone;
  String? email;
  String? website;
  String? address;
  String? notes;

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
      this.notes);
}
