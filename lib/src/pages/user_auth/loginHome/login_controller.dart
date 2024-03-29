import 'package:flutter/material.dart';

class LoginController {
  BuildContext? context;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //NULL SAFETY
  Future? init(BuildContext context) {
    this.context = context;
    return null;
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context!, "create_acount");
  }

  void goToForgotPassword() {
    Navigator.pushNamed(context!, "forgotPassword");
  }

  void login() {
    Navigator.pushNamedAndRemoveUntil(
        context!, "principal_page", (route) => false);
    //String email = emailController.text.trim();
    //String password = passwordController.text.trim();
  }
}
