import 'package:flutter/material.dart';

Widget fondoPantalla() {
  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          Color(0xFF000b31),
          Color(0xFF394988),
        ],
      ),
    ),
  );
}
