import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app/utils/app_utils.dart';

class RegistrationScreenController with ChangeNotifier {
  bool isLoading = false;
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;
  bool _isConformPasswordVisible = false;
  bool get isConformPasswordVisible => _isConformPasswordVisible;
  Future<void> onRegistration(
      {required String email,
      required String password,
      required BuildContext context}) async {
    isLoading = true;
    notifyListeners();
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user?.uid != null) {
        AppUtils.showOneTimeSnackBar(
            bg: Colors.green,
            context: context,
            message: "Registration successful");
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        AppUtils.showOneTimeSnackBar(
            context: context, message: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        AppUtils.showOneTimeSnackBar(
            context: context,
            message: "The account already exists for that email.");
      }
    } catch (e) {
      AppUtils.showOneTimeSnackBar(
        context: context,
        message: e.toString(),
      );
    }
    isLoading = false;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfomPasswordVisibility() {
    _isConformPasswordVisible = !_isConformPasswordVisible;
    notifyListeners();
  }
}
