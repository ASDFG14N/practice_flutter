import 'package:flutter/material.dart';
import 'package:ninja_otaku_app/src/utils/my_colors.dart';

Widget divider(String text) {
  return Container(
    width: double.infinity,
    alignment: Alignment.bottomCenter,
    margin: const EdgeInsets.symmetric(
      horizontal: 30,
      vertical: 10,
    ),
    child: Row(
      children: [
        Expanded(
          child: Divider(
            color: MyColors.myCustomColorRed,
            height: 2,
            thickness: 2, // Grosor de la línea
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: MyColors.myCustomColorRed,
            thickness: 2, // Grosor de la línea
          ),
        ),
      ],
    ),
  );
}
