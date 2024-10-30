import 'package:flutter/material.dart';

Widget buildButton(String buttonText,
    {required VoidCallback onPressed, Key? key, bool isActive = false, bool isEnabled = true}) {
  return Expanded(
    child: ElevatedButton(
      key: key,
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? (isActive ? Colors.blue : null) : Colors.grey,
      ),
      child: Text(buttonText,
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
    ),
  );
}

Widget buildProgrameButton(String buttonText,
    {required VoidCallback onPressed, Key? key, bool isActive = false, double height = 40.0}) {
  return Container(
    height: height,
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