import 'package:nfc_tool/models/card.dart';

class VCardCreator {
  final Card createCard;

  VCardCreator(this.createCard);

  String generateVCard() {
    final vCardBuffer = StringBuffer()
      ..write("BEGIN:VCARD\n")
      ..write("VERSION:3.0\n")
      ..writeField("FN", createCard.fullName)
      ..writeField("ORG", createCard.companyName)
      ..writeField("TITLE", createCard.jobTitle)
      ..writeField("TEL;TYPE=WORK,VOICE", createCard.phone)
      ..writeField("TEL;TYPE=CELL,VOICE", createCard.mobilePhone)
      ..writeField("EMAIL;TYPE=WORK", createCard.email)
      ..writeField("URL", createCard.website)
      ..writeField("ADR;TYPE=WORK,PREF", createCard.address)
      ..write("END:VCARD");
    return vCardBuffer.toString();
  }
}

extension StringBufferExtension on StringBuffer {
  void writeField(String fieldName, String? fieldValue) {
    if (fieldValue != null && fieldValue.isNotEmpty) {
      write("$fieldName:$fieldValue\n");
    }
  }
}
