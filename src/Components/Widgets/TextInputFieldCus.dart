// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputFieldCus extends StatelessWidget {
  final TextEditingController texteditingcontroller;
  final bool ispass;
  final TextInputType textInputType;
  final String hintText;
  const TextInputFieldCus(
      {Key? key,
      required this.texteditingcontroller,
      this.ispass = false,
      required this.textInputType,
      required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      controller: texteditingcontroller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        fillColor: const Color(0xff1A1A1A),
      ),
      keyboardType: textInputType,
      obscureText: ispass,
    );
  }
}
