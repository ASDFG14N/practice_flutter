import 'package:flutter/material.dart';

class CreateAcountController {
  BuildContext? context;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //NULL SAFETY
  Future? init(BuildContext context) {
    this.context = context;
    return null;
  }

  void goToLoginPage() {
    Navigator.pushNamed(context!, "login_home");
  }
}
