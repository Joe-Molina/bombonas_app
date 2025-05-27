import 'package:flutter/material.dart';

AppBar appBarComponent(String title) {
  return AppBar(
    title: Text(title, style: TextStyle(color: Colors.white)),
    backgroundColor: const Color.fromARGB(255, 27, 27, 27),
    foregroundColor: Colors.white,
  );
}
