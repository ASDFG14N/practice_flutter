import 'package:flutter/material.dart';
import 'package:ninja_otaku_app/src/widgets/sniper_custom.dart';

Widget loadAnimes() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        spinnerCustom(),
      ],
    ),
  );
}
