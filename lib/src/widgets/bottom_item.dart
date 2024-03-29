import 'package:flutter/material.dart';

class BottomItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final void Function() onPressed;
  const BottomItem(
      {super.key,
      required this.icon,
      this.isActive = false,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.white : Colors.grey[700],
            size: 30,
          ),
          isActive
              ? Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: 12,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
