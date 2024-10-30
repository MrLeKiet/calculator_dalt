import 'package:flutter/material.dart';

Widget buildButton(String buttonText,
    {required VoidCallback onPressed, Key? key, bool isActive = false}) {
  return Expanded(
    child: ElevatedButton(
      key: key,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.blue : null,
      ),
      child: Text(buttonText,
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
    ),
  );
}

Widget buildProgrameButton(String buttonText,
    {required VoidCallback onPressed, Key? key, bool isActive = false}) {
  return Expanded(
    child: ElevatedButton(
      key: key,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.blue : null,
      ),
      child: Text(buttonText,
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
    ),
  );
}