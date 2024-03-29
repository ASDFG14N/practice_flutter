import 'package:flutter/material.dart';
import 'package:ninja_otaku_app/src/utils/my_colors.dart';
import 'package:ninja_otaku_app/src/widgets/text_input.dart';

import '../../../utils/screen_gradient.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            fondoPantalla(),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo_ninja_otaku.png",
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(height: size.height * 0.06),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 5,
                      ),
                      child: const Text(
                        "Te enviaremos a tu correo un mensaje para que puedas modificar tu contraseña",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    //Textinput email
                    TextInput(
                      hintText: "Correo electrónico",
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      validator: (text) {
                        return emailRegExp.hasMatch(text);
                      },
                      onChanged: (text) {},
                    ),
                    SizedBox(height: size.height * 0.02),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        child: Container(
                          margin: const EdgeInsets.only(right: 30, bottom: 5),
                          child: _buttonSend(size),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonSend(Size size) {
    return SizedBox(
      width: size.width * 0.3,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.myCustomColorRed,
          //redondear el boton
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
        ),
        child: const Text(
          "Enviar",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
