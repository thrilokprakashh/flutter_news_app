import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/utils/app_utils.dart';

class ForgotPasswordController with ChangeNotifier {
  bool isLoading = false;

  Future<void> sendPasswordResetEmail({
    required String email,
    required BuildContext context,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      AppUtils.showOneTimeSnackBar(
        bg: Colors.green,
        context: context,
        message: "Password reset email sent successfully",
      );
      log("Password reset email sent to: $email");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AppUtils.showOneTimeSnackBar(
          context: context,
          message: "No user found with that email.",
        );
      } else if (e.code == 'invalid-email') {
        AppUtils.showOneTimeSnackBar(
          context: context,
          message: "Invalid email address provided.",
        );
      } else {
        AppUtils.showOneTimeSnackBar(
          context: context,
          message: e.message ?? "An error occurred. Please try again.",
        );
      }
      log("Error: ${e.message}");
    } catch (e) {
      AppUtils.showOneTimeSnackBar(
        context: context,
        message: "An unexpected error occurred. Please try again later.",
      );
      log("Unexpected error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
