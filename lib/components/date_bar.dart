import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Padding dateBar() => Padding(
  padding: const EdgeInsets.all(16.0),
  child: Container(
    width: double.infinity,
    height: 40,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 20, 20, 20),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            DateFormat('dd/MM/yy').format(DateTime.now()),
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    ),
  ),
);
