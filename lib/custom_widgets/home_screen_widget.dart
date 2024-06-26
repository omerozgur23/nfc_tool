import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/utils/context_extensiton.dart';

class HomeScreenWidget {
  Padding buildAppBarButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    double? leftPadding,
    double? rightPadding,
    double? topPadding,
    double? bottomPadding,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        leftPadding ?? 0.0,
        topPadding ?? 0.0,
        rightPadding ?? 0.0,
        bottomPadding ?? 0.0,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            backgroundColor: HexColor(appBarButtonColor),
            padding:
                EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.02)),
            minimumSize: const Size(0, 0)),
        child: Text(
          text.tr(),
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: HexColor(white)),
        ),
      ),
    );
  }

  Row buildButtonRow(
      {required BuildContext context, required List<ElevatedButton> buttons}) {
    List<Widget> buttonWidgets = [];
    double sizedBoxWidth = context.dynamicWidth(0.02);

    for (var button in buttons) {
      buttonWidgets.add(Expanded(child: button));
      buttonWidgets.add(SizedBox(width: sizedBoxWidth));
    }

    // Son eklenen SizedBox'i kaldırmak için son elemanı kontrol ediyoruz
    if (buttonWidgets.isNotEmpty) {
      buttonWidgets.removeLast();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttonWidgets,
    );
  }

  ElevatedButton buildButton(
      {required BuildContext context,
      required String buttonText,
      required VoidCallback onPressed,
      required IconData icon,
      double? minimumSize,
      bool useRowWidget = false}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          minimumSize:
              Size.fromHeight(minimumSize ?? context.dynamicHeight(0.2)),
          backgroundColor: HexColor(homeScreenButtonColor)),
      onPressed: onPressed,
      child: useRowWidget
          ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                icon,
                size: context.dynamicHeight(0.045),
                color: HexColor(white),
              ),
              SizedBox(width: context.dynamicWidth(0.08)),
              Text(
                  style:
                      TextStyle(fontSize: 15, color: HexColor(buttonTextColor)),
                  buttonText.tr()),
            ])
          : Column(children: [
              Icon(
                icon,
                size: context.dynamicHeight(0.045),
                color: HexColor(white),
              ),
              SizedBox(height: context.dynamicHeight(0.01)),
              Text(
                  style:
                      TextStyle(fontSize: 15, color: HexColor(buttonTextColor)),
                  buttonText.tr()),
            ]),
    );
  }
}
