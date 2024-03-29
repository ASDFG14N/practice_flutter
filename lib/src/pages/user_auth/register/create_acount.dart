import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ninja_otaku_app/src/pages/user_auth/register/create_acount_controller.dart';
import 'package:ninja_otaku_app/src/widgets/text_input.dart';
import 'package:ninja_otaku_app/src/widgets/widget_divider.dart';
import 'package:ninja_otaku_app/src/widgets/widget_social_networks.dart';

import '../../../utils/my_colors.dart';
import '../../../utils/screen_gradient.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final CreateAcountController _con = CreateAcountController();
  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

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
                    SizedBox(height: size.height * 0.1),
                    TextInput(
                      hintText: "Usuario",
                      prefixIcon: const Icon(
                        Icons.person_3_rounded,
                        color: Colors.white,
                      ),
                      validator: (text) {
                        return text.contains("");
                      },
                      onChanged: (text) {},
                    ),
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
                    TextInput(
                      hintText: "Constraseña",
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      validator: (text) {
                        return text.contains("");
                      },
                      obscureText: true,
                      onChanged: (text) {},
                    ),
                    SizedBox(height: size.height * 0.01),
                    _buttonCreateAcount(),
                    SizedBox(height: size.height * 0.001),
                    divider("Registrarse con"),
                    SizedBox(height: size.height * 0.01),
                    socialNetworks(),
                    SizedBox(height: size.height * 0.03),
                    _textHaveAccount(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonCreateAcount() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 20,
      ),
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
          "Registrarse",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _textHaveAccount() {
    return Row(
      //centrar el contenido
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "¿Ya eres parte de NinjaOtaku?",
          style: TextStyle(
            color: MyColors.myCustomColorRed,
          ),
        ),
        //separacion entre los dos textos
        const SizedBox(
          width: 7,
        ),
        GestureDetector(
          onTap: _con.goToLoginPage,
          child: Text(
            "Iniciar Sessión",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MyColors.myCustomColorRed,
            ),
          ),
        ),
      ],
    );
  }
}
