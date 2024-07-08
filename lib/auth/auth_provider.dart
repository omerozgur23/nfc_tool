import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/screens/language_screen.dart';
import 'package:nfc_tool/utils/page_route/custom_page_route.dart';
import 'package:hexcolor/hexcolor.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/home',
        (Route<dynamic> route) => false,
      );
    } /*on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorDialog(context, 'User not found');
      } else if (e.code == 'wrong-password') {
        showErrorDialog(context, 'Wrong password');
      } else {
        showErrorDialog(context, 'Sign in failed');
      }
    }*/
    catch (e) {
      showErrorDialog(context, 'loginScreen.errorLoginMessage');
      print('Sign in error: $e');
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        CustomPageRoute(builder: (context) => const LanguageScreen()),
        (route) => false,
      );
    } catch (e) {
      // Handle sign out errors
      print('Sign out error: $e');
    }
  }

  Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showErrorDialog(context, 'Password reset email sent');
    } catch (e) {
      showErrorDialog(context, 'Error sending password reset email');
      print('Password reset error: $e');
    }
  }

  Future<dynamic> showErrorDialog(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: HexColor(frameColor),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset("assets/gif/error.gif"),
                const SizedBox(
                  height: 20,
                ),
                Text(message.tr()),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor(buttonColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                      style: TextStyle(color: HexColor(buttonTextColor)),
                      "loginScreen.errorDialogOkButton".tr()))
            ],
          );
        });
  }
}
