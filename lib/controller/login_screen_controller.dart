import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:news_app/utils/app_utils.dart';

class LoginScreenController with ChangeNotifier {
  bool isLoading = false;
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;
  Future<void> onLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      log(credential.user?.email.toString() ?? "no data");
      AppUtils.showOneTimeSnackBar(
          bg: Colors.green, context: context, message: "Login successful");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        AppUtils.showOneTimeSnackBar(
            context: context, message: "No user found for that email.");
      } else if (e.code == 'invalid-credential') {
        AppUtils.showOneTimeSnackBar(
            context: context,
            message: "Wrong password provided for that user.");
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
}
