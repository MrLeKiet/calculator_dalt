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
  String _lastOutput = "0"; // Add this variable to store the last output value
  double num1 = 0.0;
  double num2 = 0.0;
  String operand = "";
  String expression = "";
  bool isScientific = false;
  bool isProgrammer = false;
  bool isResultDisplayed = false;
  bool isEqualPressed = false;
  bool isPiPressed = false;
  bool showTrigonometry = false;
  String currentMode = 'DEC';
  double currentValue = 0.0;
  bool isDegree = true; // Mặc định là Degree

  final GlobalKey _trigonometryKey = GlobalKey();

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "CLEAR") {
        output = "0";
        _output = "0";
        _lastOutput = "0"; // Reset the last output value
        num1 = 0.0;
        num2 = 0.0;
        operand = "";
        expression = "";
        isResultDisplayed = false;
        isEqualPressed = false;
        currentValue = 0.0;
        isPiPressed = false;
      } else if (buttonText == "DEL") {
        if (_output.length > 1) {
          _output = _output.substring(0, _output.length - 1);
        } else {
          _output = "0";
        }
        output = _output;
        currentValue = _parseInput(_output);
        isPiPressed = false;
      } else if (buttonText == "=") {
        if (!isEqualPressed) {
          if (operand.isNotEmpty) {
            expression +=
                _output; // Append the second operand to the expression
            calculateResult();
            expression += " ="; // Update expression with the result
          } else if (expression.contains("sin") ||
              expression.contains("cos") ||
              expression.contains("tan") ||
              expression.contains("log") ||
              expression.contains("ln") ||
              expression.contains("√")) {
            expression += " ="; // Update expression for trigonometric functions
          }
          isEqualPressed = true;
        }
        isPiPressed = false;
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "x" ||
          buttonText == "÷") {
        if (operand.isEmpty) {
          num1 = _parseInput(_output);
          operand = buttonText;
          expression = _formatNumber(num1) + " " + buttonText + " ";
          _output = "";
        } else {
          calculateResult();
          num1 = _parseInput(
              output); // Update num1 to the result of the previous operation
          operand = buttonText;
          expression = _formatNumber(num1) + " " + buttonText + " ";
          _output = "";
        }
        isEqualPressed =
            false; // Reset isEqualPressed when an operand is pressed
        isPiPressed = false;
      } else if (buttonText == "sin" ||
          buttonText == "cos" ||
          buttonText == "tan" ||
          buttonText == "log" ||
          buttonText == "ln") {
        // Store the last output value before updating the expression
        _lastOutput = _output;

        String degreeSymbol =
            isDegree ? "°" : ""; // Add degree symbol conditionally

        // Update expression for trigonometric functions with degree symbol
        if (operand.isNotEmpty) {
          expression =
              expression.substring(0, expression.lastIndexOf(operand) + 1) +
                  " $buttonText(${_lastOutput}$degreeSymbol)";
        } else {
          expression = "$buttonText(${_lastOutput}$degreeSymbol)";
        }
        calculateTrigonometric(buttonText);
        isPiPressed = false;
      } else if (buttonText == "√") {
        // Handle square root separately without degree symbol
        _lastOutput = _output;
        if (operand.isNotEmpty) {
          expression =
              expression.substring(0, expression.lastIndexOf(operand) + 1) +
                  " $buttonText($_lastOutput)";
        } else {
          expression = "$buttonText($_lastOutput)";
        }
        calculateTrigonometric(buttonText);
        isPiPressed = false;
      } else if (buttonText == "π") {
        if (isDegree) {
          // Nếu đang ở chế độ Degree, gán giá trị π = 180
          _output = "180";
          currentValue = 180.0;
        } else {
          // Nếu đang ở chế độ Radian, gán giá trị π = 3.14159...
          _output = fullPi;
          currentValue = double.parse(fullPi);
        }
        output = _output;
        isPiPressed = true;
      } else {
        if (isResultDisplayed || isPiPressed) {
          _output = buttonText;
          isResultDisplayed = false;
          isPiPressed = false;
        } else {
          if (_output == "0") {
            _output = buttonText;
          } else {
            _output += buttonText;
          }
        }
        output = _output;
        currentValue = _parseInput(_output);
        // Do not update expression when a number is pressed
        isEqualPressed = false; // Reset isEqualPressed when a number is pressed
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
        value = double.parse(_lastOutput); // Use _lastOutput instead of _output
        valueStr = _lastOutput; // Use _lastOutput instead of _output
      }
      double result = 0.0; // Initialize result with a default value
      bool isValid = true; // Flag to check if the input is valid

      // Chuyển đổi giữa độ và radian dựa trên chế độ hiện tại
      double angle = isDegree ? value * pi / 180 : value;

      switch (function) {
        case "sin":
          result = sin(angle);
          break;
        case "cos":
          result = cos(angle);
          break;
        case "tan":
          if (value % 180 == 90 && isDegree) {
            isValid = false;
          } else {
            result = tan(angle);
          }
          break;
        case "log":
          if (value <= 0) {
            isValid = false;
          } else {
            result = log(value) / log(10); // Log base 10
          }
          break;
        case "ln":
          if (value <= 0) {
            isValid = false;
          } else {
            result = log(value); // Natural log
          }
          break;
        case "√":
          if (value < 0) {
            isValid = false;
          } else {
            result = sqrt(value); // Square root
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
      isResultDisplayed = true;
    });
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
      if (currentMode != mode) {
        try {
          if (currentMode == 'HEX') {
            currentValue = int.parse(_output, radix: 16).toDouble();
          } else if (currentMode == 'OCT') {
            currentValue = int.parse(_output, radix: 8).toDouble();
          } else if (currentMode == 'BIN') {
            currentValue = int.parse(_output, radix: 2).toDouble();
          } else {
            currentValue = double.parse(_output);
          }

          if (mode == 'HEX') {
            output = currentValue.toInt().toRadixString(16).toUpperCase();
          } else if (mode == 'OCT') {
            output = currentValue.toInt().toRadixString(8);
          } else if (mode == 'BIN') {
            output = currentValue.toInt().toRadixString(2);
          } else {
            output = currentValue.toInt().toString();
          }
        } catch (e) {
          output = "0"; // Default value if parsing fails
        }
        _output = output;
        currentMode = mode;
      }
    });
  }

  void _hideTrigonometryPanel() {
    if (showTrigonometry) {
      setState(() {
        showTrigonometry = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _hideTrigonometryPanel,
      child: Scaffold(
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
          isDegree: isDegree,
          onDegreeChange: (value) {
            setState(() {
              isDegree = value;
            });
          },
        ),
      ),
    );
  }
}