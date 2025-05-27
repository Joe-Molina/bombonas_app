import 'package:flutter/material.dart';

InputDecoration inputStyle(String title) {
  return InputDecoration(
    label: Text(title, style: TextStyle(color: Colors.white)),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.white,
        width: 2.0,
      ), // ¡Aquí cambias el color!
      borderRadius: BorderRadius.circular(10.0),
    ),
    border: const OutlineInputBorder(),
    focusColor: Colors.white,
    hintStyle: TextStyle(color: Colors.white70),
  );
}
