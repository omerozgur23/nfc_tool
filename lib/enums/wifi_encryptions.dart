enum WifiEncryptionsType { none, wep, txip, aes, aesTkip }

extension WifiEncryptionsTypeExtension on WifiEncryptionsType {
  String get displayName {
    switch (this) {
      case WifiEncryptionsType.none:
        return "None";
      case WifiEncryptionsType.wep:
        return "WEP";
      case WifiEncryptionsType.txip:
        return "TXIP";
      case WifiEncryptionsType.aes:
        return "AES";
      case WifiEncryptionsType.aesTkip:
        return "AES/TKIP";
      default:
        return "";
    }
  }
}
