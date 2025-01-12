import 'package:flutter/material.dart';

Widget buildButton(String text,
    {required Function() onPressed, bool isEnabled = true}) {
  return Expanded(
    child: ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          // color: Colors.blue,
        ),
      ),
    ),
  );
}