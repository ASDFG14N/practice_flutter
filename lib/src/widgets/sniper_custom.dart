import 'package:flutter/material.dart';
import 'package:ninja_otaku_app/src/utils/my_colors.dart';

Widget spinnerCustom() {
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(MyColors.myCustomColorRed),
    backgroundColor: Colors.grey,
    strokeWidth: 5,
  );
}
