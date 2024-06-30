// authentication_type.dart
enum WifiAuthenticationType {
  open,
  wpaPersonal,
  shared,
  wpaEnterprise,
  wpa2Enterprise,
  wpa2Personal,
  wpaWpa2Personal,
}

extension WifiAuthenticationTypeExtension on WifiAuthenticationType {
  String get displayName {
    switch (this) {
      case WifiAuthenticationType.open:
        return "Open";
      case WifiAuthenticationType.wpaPersonal:
        return "WPA-Personal";
      case WifiAuthenticationType.shared:
        return "Shared";
      case WifiAuthenticationType.wpaEnterprise:
        return "WPA-Enterprise";
      case WifiAuthenticationType.wpa2Enterprise:
        return "WPA2-Enterprise";
      case WifiAuthenticationType.wpa2Personal:
        return "WPA2-Personal";
      case WifiAuthenticationType.wpaWpa2Personal:
        return "WPA/WPA2-Personal";
      default:
        return "";
    }
  }
}
