import 'package:flutter/material.dart';

Widget socialNetworks() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: GestureDetector(
          onTap: () {
            // Aquí puedes agregar la acción que desees cuando se toque el contenedor
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
                size: 55, // Tamaño del ícono dentro del círculo
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: GestureDetector(
          onTap: () {
            // Aquí puedes agregar la acción que desees cuando se toque el contenedor
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
