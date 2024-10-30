import 'dart:math';

import 'package:flutter/material.dart';

import 'calculator_layout.dart';
import 'utils.dart';

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String output = "0";
  String _output = "0";
  double num1 = 0.0;
  double num2 = 0.0;
  String operand = "";
  String expression = "";
  bool isScientific = false;
  bool isProgrammer = false;
  bool isResultDisplayed = false;
  bool isEqualPressed = false;
  bool showTrigonometry = false;
  String currentMode = 'DEC';
  int currentValue = 0;

  final GlobalKey _trigonometryKey = GlobalKey();

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "CLEAR") {
        output = "0";
        _output = "0";
        num1 = 0.0;
        num2 = 0.0;
        operand = "";
        expression = "";
        isResultDisplayed = false;
        isEqualPressed = false;
      } else if (buttonText == "DEL") {
        if (_output.length > 1) {
          _output = _output.substring(0, _output.length - 1);
        } else {
          _output = "0";
        }
        output = _output;
      } else if (buttonText == "=") {
        calculateResult();
      } else if (buttonText == "sin" || buttonText == "cos" || buttonText == "tan" || buttonText == "log" || buttonText == "ln" || buttonText == "√") {
        calculateTrigonometric(buttonText);
      } else {
        if (isResultDisplayed) {
          _output = buttonText;
          isResultDisplayed = false;
        } else {
          _output += buttonText;
        }
        output = _output;
      }
    });
  }

  void calculateResult() {
    setState(() {
      num2 = double.parse(_output);
      switch (operand) {
        case "+":
          _output = (num1 + num2).toString();
          break;
        case "-":
          _output = (num1 - num2).toString();
          break;
        case "x":
          _output = (num1 * num2).toString();
          break;
        case "÷":
          _output = (num1 / num2).toString();
          break;
      }
      output = formatNumber(double.parse(_output));
      isResultDisplayed = true;
      isEqualPressed = true;
    });
  }

  void calculateTrigonometric(String function) {
    setState(() {
      double value = double.parse(_output);
      switch (function) {
        case "sin":
          _output = sin(value).toString();
          break;
        case "cos":
          _output = cos(value).toString();
          break;
        case "tan":
          _output = tan(value).toString();
          break;
        case "log":
          _output = (log(value) / log(10)).toString();
          break;
        case "ln":
          _output = log(value).toString();
          break;
        case "√":
          _output = sqrt(value).toString();
          break;
      }
      output = formatNumber(double.parse(_output));
      isResultDisplayed = true;
    });
  }

  void toggleCalculatorType(String type) {
    setState(() {
      isScientific = type == 'Scientific';
      isProgrammer = type == 'Programmer';
      showTrigonometry = false;
    });
    Navigator.pop(context);
  }

  void toggleTrigonometry() {
    setState(() {
      showTrigonometry = !showTrigonometry;
    });
  }

  void changeMode(String mode) {
    setState(() {
      currentMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isScientific
            ? 'Scientific'
            : isProgrammer
                ? 'Programmer'
                : 'Standard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage('assets/drawer_header_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Text(
                'Calculator Type',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text('Standard', style: TextStyle(fontSize: 18)),
              onTap: () => toggleCalculatorType('Standard'),
            ),
            ListTile(
              leading: Icon(Icons.science),
              title: Text('Scientific', style: TextStyle(fontSize: 18)),
              onTap: () => toggleCalculatorType('Scientific'),
            ),
            ListTile(
              leading: Icon(Icons.code),
              title: Text('Programmer', style: TextStyle(fontSize: 18)),
              onTap: () => toggleCalculatorType('Programmer'),
            ),
          ],
        ),
      ),
      body: CalculatorLayout(
        isScientific: isScientific,
        isProgrammer: isProgrammer,
        showTrigonometry: showTrigonometry,
        expression: expression,
        output: output,
        currentMode: currentMode,
        currentValue: currentValue,
        trigonometryKey: _trigonometryKey,
        buttonPressed: buttonPressed,
        toggleTrigonometry: toggleTrigonometry,
        changeMode: changeMode,
      ),
    );
  }
}