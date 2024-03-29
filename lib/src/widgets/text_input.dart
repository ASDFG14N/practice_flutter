import 'package:flutter/material.dart';
import 'package:ninja_otaku_app/src/utils/my_colors.dart';

class TextInput extends StatefulWidget {
  final Widget prefixIcon;
  final bool Function(String) validator;
  final bool obscureText;
  final void Function(String) onChanged;
  final String hintText;

  const TextInput({
    super.key,
    required this.validator,
    required this.prefixIcon,
    this.obscureText = false,
    required this.onChanged,
    required this.hintText,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool _isOk = false;
  late bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _validate(String text) {
    _isOk = widget.validator(text);
    setState(() {});
    widget.onChanged(text);
  }

  void _onVisibleChange() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: MyColors.colorrCelesteLogo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        obscureText: _obscureText,
        onChanged: _validate,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscureText
                ? IconButton(
                    onPressed: _onVisibleChange,
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility
                          : Icons.visibility_off_rounded,
                      color: Colors.grey,
                    ))
                : Icon(
                    Icons.check_circle_rounded,
                    color: _isOk ? Colors.green : Colors.grey,
                  )),
      ),
    );
  }
}
