import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/screens/new_password_screen.dart';
import 'package:nfc_tool/utils/context_extensiton.dart';
import 'package:nfc_tool/utils/custom_page_route.dart';

class EntryPasswordScreen extends StatefulWidget {
  const EntryPasswordScreen({super.key});

  @override
  State<EntryPasswordScreen> createState() => _EntryPasswordScreenState();
}

class _EntryPasswordScreenState extends State<EntryPasswordScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<String> _password = List.filled(6, '');
  bool _wrongPasswordEntered = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    final text = _controller.text;
    if (text.length <= 6) {
      setState(() {
        for (int i = 0; i < _password.length; i++) {
          _password[i] = i < text.length ? text[i] : '';
        }
        _wrongPasswordEntered = false;
      });

      if (_password.every((char) => char.isNotEmpty)) {
        _verifyCurrentPassword(_password.join());
      }
    } else {
      _controller.text = _controller.text.substring(0, 6);
    }
  }

  Future<void> _verifyCurrentPassword(String enteredPassword) async {
    // Firebase ile kullanıcının mevcut şifresini doğrula
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // AuthCredential oluşturarak şifreyi doğrulama
        AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: enteredPassword);
        await user.reauthenticateWithCredential(credential);

        // Şifre doğrulandıysa NewPasswordScreen'e geçiş yap
        navigateToChangePassword(user);
      } catch (e) {
        setState(() {
          _controller.clear();
          _wrongPasswordEntered = true;
          _password.fillRange(0, _password.length, "");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: HexColor(appBarColor),
      iconTheme: IconThemeData(color: HexColor(appBarIconColor)),
      centerTitle: true,
      title: Text(
        "entryPasswordScreen.title".tr(),
        style: TextStyle(color: HexColor(appBarTitleColor)),
      ),
    );
  }

  Column buildBody() {
    return Column(
      children: [
        SizedBox(
          height: context.dynamicHeight(0.12),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                _password.length,
                (index) => Padding(
                      padding: EdgeInsets.all(context.dynamicWidth(0.015)),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: HexColor(black), width: 2.0),
                              color: _password[index].isEmpty
                                  ? Colors.transparent
                                  : HexColor(black)),
                        ),
                      ),
                    ))),
        if (_wrongPasswordEntered)
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: context.dynamicHeight(0.018)),
            child: Text(
              'entryPasswordScreen.errorWrongPassword'.tr(),
              style: TextStyle(
                color: HexColor(red),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        Offstage(
          offstage: true,
          child: TextField(
            focusNode: _focusNode,
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 6,
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
            autofocus: true,
            obscureText: true,
            style: const TextStyle(
              color: Colors.transparent,
              height: 0.01,
            ),
            cursorColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  /***************************************************************** */
  void navigateToChangePassword(User user) async {
    final currentUser = user;

    String? newPassword = await Navigator.of(context).push<String>(
      CustomPageRoute(
        builder: (context) => NewPasswordScreen(
          title: "entryPasswordScreen.newPassword".tr(),
          onSubmitted: (password) => Navigator.of(context).pop(password),
        ),
      ),
    );
    if (newPassword == null) return;

    String? confirmPassword = await Navigator.of(context).push<String>(
      CustomPageRoute(
        builder: (context) => NewPasswordScreen(
            title: "entryPasswordScreen.confirmPassword".tr(),
            onSubmitted: (password) {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop(password);
            }),
      ),
    );
    if (confirmPassword == null || confirmPassword != newPassword) {
      print("Passwords do not match");
      return;
    }

    // Update the password
    try {
      await currentUser.updatePassword(newPassword);
      // print("Password updated successfully");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: HexColor(white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset("assets/gif/success.gif"),
                ],
              ),
              // actionsAlignment: MainAxisAlignment.center,
            );
          });

      await Future.delayed(const Duration(seconds: 3));

      Navigator.of(context).pushNamedAndRemoveUntil(
        '/home',
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Failed to update password: $e");
    }
  }
}
