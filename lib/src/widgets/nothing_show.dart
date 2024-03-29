import 'package:flutter/material.dart';

Widget nothingToShow(IconData icon, String description) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 150,
          color: Colors.grey,
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 25, right: 25),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
