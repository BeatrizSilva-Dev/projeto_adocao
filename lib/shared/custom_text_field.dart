import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onTap;
  final Color cursorColor;
  final Color underlineColor;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.hintText = '',
    this.onTap,
    this.cursorColor = const Color(0xFF4359E8),
    this.underlineColor = const Color(0xFF4359E8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: cursorColor,
      decoration: InputDecoration(
        hintText: hintText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: underlineColor),
        ),
      ),
      onTap: onTap,
    );
  }
}
