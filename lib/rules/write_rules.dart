import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:nfc_tool/exceptions/business_exception.dart';
import 'package:nfc_tool/constants/business_exception_messages.dart';

class WriteRules {
  static void checkNfcTagWritable(NFCTag tag) {
    if (tag.ndefWritable != true) {
      throw BusinessException(Messages.notWritable);
    }
  }

  static void checkVCardSize(int vCardSize, int ndefCapacity) {
    if (vCardSize > ndefCapacity) {
      throw BusinessException(Messages.overCapacity);
    }
  }

  static Future<bool> checkNfcAvailable() async {
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      return false;
    }
    return true;
  }
}
