import 'package:flutter/material.dart';
import 'package:ninja_otaku_app/src/pages/user_auth/forgot_pasword/forgot_password_page.dart';
import 'package:ninja_otaku_app/src/pages/user_auth/loginHome/login_home_page.dart';
import 'package:ninja_otaku_app/src/pages/user_auth/register/create_acount.dart';
import 'package:ninja_otaku_app/src/routes/root_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Ninja Otaku App",
      initialRoute: "login_home",
      routes: {
        "login_home": (BuildContext context) => const LoginHomePage(),
        "create_acount": (BuildContext context) => const RegisterPage(),
        "principal_page": (BuildContext context) => const RootApp(),
        "forgotPassword": (BuildContext context) => const ForgotPasswordPage(),
      },
    );
  }
}
