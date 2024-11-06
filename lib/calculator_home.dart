import 'dart:math';

import 'package:flutter/material.dart';

import 'calculator_layout.dart';

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

const String fullPi = "3.1415926535897932384626433832795";

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
  double currentValue = 0.0;

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
        currentValue = 0.0;
      } else if (buttonText == "DEL") {
        if (_output.length > 1) {
          _output = _output.substring(0, _output.length - 1);
        } else {
          _output = "0";
        }
        output = _output;
        currentValue = _parseInput(_output);
      } else if (buttonText == "=") {
        calculateResult();
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "x" ||
          buttonText == "÷") {
        if (operand.isEmpty) {
          num1 = _parseInput(_output);
          operand = buttonText;
          expression = _formatNumber(num1) + " " + buttonText;
          _output = "";
        } else {
          calculateResult();
          num1 = _parseInput(
              output); // Update num1 to the result of the previous operation
          operand = buttonText;
          expression = _formatNumber(num1) + " " + buttonText;
          _output = "";
        }
      } else if (buttonText == "sin" ||
          buttonText == "cos" ||
          buttonText == "tan" ||
          buttonText == "log" ||
          buttonText == "ln" ||
          buttonText == "√") {
        calculateTrigonometric(buttonText);
      } else if (buttonText == "π") {
        if (isResultDisplayed) {
          _output = fullPi;
          isResultDisplayed = false;
        } else {
          if (_output == "0") {
            _output = fullPi;
          } else {
            _output += fullPi;
          }
        }
        output = _output;
        currentValue = double.parse(fullPi);
      } else {
        if (isResultDisplayed) {
          _output = buttonText;
          isResultDisplayed = false;
        } else {
          if (_output == "0") {
            _output = buttonText;
          } else {
            _output += buttonText;
          }
        }
        output = _output;
        currentValue = _parseInput(_output);
      }
    });
  }

  double _parseInput(String input) {
    if (currentMode == 'HEX') {
      return int.parse(input, radix: 16).toDouble();
    } else if (currentMode == 'OCT') {
      return int.parse(input, radix: 8).toDouble();
    } else if (currentMode == 'BIN') {
      return int.parse(input, radix: 2).toDouble();
    } else if (input == "Infinity" ||
        input == "Error: Division by zero" ||
        input == "Error") {
      throw FormatException("Invalid input");
    } else {
      return double.parse(input);
    }
  }

  String _formatNumber(double number) {
    if (currentMode == 'HEX') {
      return number.toInt().toRadixString(16).toUpperCase();
    } else if (currentMode == 'OCT') {
      return number.toInt().toRadixString(8);
    } else if (currentMode == 'BIN') {
      return number.toInt().toRadixString(2);
    } else {
      return number == number.toInt()
          ? number.toInt().toString()
          : number.toString();
    }
  }

  void calculateResult() {
    setState(() {
      try {
        num2 = _parseInput(_output);
        switch (operand) {
          case "+":
            _output = _formatNumber(num1 + num2);
            break;
          case "-":
            _output = _formatNumber(num1 - num2);
            break;
          case "x":
            _output = _formatNumber(num1 * num2);
            break;
          case "÷":
            if (num2 == 0) {
              _output = "Infinity";
            } else {
              _output = _formatNumber(num1 / num2);
            }
            break;
        }
        output = _output;
        currentValue = _parseInput(_output);
        isResultDisplayed = true;
        isEqualPressed = true;
        operand = "";
      } catch (e) {
        _output = "Error";
      }
    });
  }

  void calculateTrigonometric(String function) {
    setState(() {
      double value;
      String valueStr;
      if (_output == fullPi) {
        value = double.parse(fullPi);
        valueStr = fullPi;
      } else {
        value = double.parse(_output);
        valueStr = _output;
      }
      double result = 0.0; // Initialize result with a default value
      bool isValid = true; // Flag to check if the input is valid
      switch (function) {
        case "sin":
          result = sin(value * pi / 180); // Convert degrees to radians
          expression += "sin(" + valueStr + ")";
          break;
        case "cos":
          result = cos(value * pi / 180); // Convert degrees to radians
          expression += "cos(" + valueStr + ")";
          break;
        case "tan":
          if (value % 180 == 90) {
            // Check for undefined tan values
            isValid = false;
            expression += "tan(" + valueStr + ")";
          } else {
            result = tan(value * pi / 180); // Convert degrees to radians
            expression += "tan(" + valueStr + ")";
          }
          break;
        case "log":
          if (value <= 0) {
            // Check for invalid log values
            isValid = false;
            expression += "log(" + valueStr + ")";
          } else {
            result = log(value) / log(10); // Log base 10
            expression += "log(" + valueStr + ")";
          }
          break;
        case "ln":
          if (value <= 0) {
            // Check for invalid ln values
            isValid = false;
            expression += "ln(" + valueStr + ")";
          } else {
            result = log(value); // Natural log
            expression += "ln(" + valueStr + ")";
          }
          break;
        case "√":
          if (value < 0) {
            // Check for invalid sqrt values
            isValid = false;
            expression += "√(" + valueStr + ")";
          } else {
            result = sqrt(value); // Square root
            expression += "√(" + valueStr + ")";
          }
          break;
      }
      if (isValid) {
        // Check if the result is close enough to 0
        if (result.abs() < 1e-10) {
          result = 0.0;
        }
        _output = _formatResult(result);
      } else {
        _output = "Invalid input";
      }
      output = _output;
      // currentValue = _parseInput(_output);
      isResultDisplayed = true;
    });
  }

// Example button press handler
  void onTrigonometricButtonPressed(String function) {
    calculateTrigonometric(function);
  }

  String _formatResult(double result) {
    if (result == result.toInt()) {
      return result.toInt().toString();
    } else {
      return result
          .toStringAsFixed(20)
          .replaceAll(RegExp(r'0*$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }
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
      output = _formatNumber(currentValue);
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
        currentValue: currentValue.toInt(), // Convert to int
        trigonometryKey: _trigonometryKey,
        buttonPressed: buttonPressed,
        toggleTrigonometry: toggleTrigonometry,
        changeMode: changeMode,
      ),
    );
  }
}