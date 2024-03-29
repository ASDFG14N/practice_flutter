import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ninja_otaku_app/src/widgets/text_input.dart';
import 'package:ninja_otaku_app/src/widgets/widget_divider.dart';

import '../../../utils/my_colors.dart';
import '../../../utils/screen_gradient.dart';
import 'login_controller.dart';

class LoginHomePage extends StatefulWidget {
  const LoginHomePage({super.key});

  @override
  State<LoginHomePage> createState() => _LoginHomePageState();
}

class _LoginHomePageState extends State<LoginHomePage> {
  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final LoginController _con = LoginController();
  @override
  void initState() {
    super.initState();
    //inicializa los controladores
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
                    //textinput password
                    TextInput(
                      hintText: "Constraseña",
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      validator: (text) {
                        return text.isNotEmpty;
                      },
                      obscureText: true,
                      onChanged: (text) {},
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _con.goToForgotPassword,
                        child: Container(
                          margin: const EdgeInsets.only(right: 30, bottom: 5),
                          child: Text(
                            "¿Olvidaste tu contraseña?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyColors.myCustomColorRed,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    _buttonLogin(),
                    SizedBox(height: size.height * 0.01),
                    divider("Conectar con"),
                    SizedBox(height: size.height * 0.01),
                    _socialNetworks(),
                    SizedBox(height: size.height * 0.03),
                    _textDontHaveAccount(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonLogin() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 20,
      ),
      child: ElevatedButton(
        onPressed: _con.login,
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
          "Iniciar Sesión",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _textDontHaveAccount() {
    return Row(
      //centrar el contenido
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "¿Aún no eres parte de NinjaOtaku?",
          style: TextStyle(
            color: MyColors.myCustomColorRed,
          ),
        ),
        //separacion entre los dos textos
        const SizedBox(
          width: 7,
        ),
        GestureDetector(
          onTap: _con.goToRegisterPage, //navegar a la otra pantalla
          child: Text(
            "Registrate",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MyColors.myCustomColorRed,
            ),
          ),
        ),
      ],
    );
  }

  Widget _socialNetworks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, "principal_page", (route) => false);
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.facebook,
                  color: Color.fromARGB(255, 22, 130, 253),
                  size: 55,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, "principal_page", (route) => false);
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // Color de fondo circular
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: Image.asset(
                  "assets/images/logo_google.png",
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
