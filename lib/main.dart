import 'dart:math'; // Import this for mathematical functions

import 'package:flutter/material.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String output = "0"; // Display output
  String _output = "0"; // Internal output
  double num1 = 0.0; // First operand
  double num2 = 0.0; // Second operand
  String operand = ""; // Current operation
  String expression = ""; // Expression for display
  bool isScientific = false; // Track calculator type
  bool isResultDisplayed = false; // Flag to check if result is displayed
  bool isEqualPressed = false; // Prevent multiple equals presses

  buttonPressed(String buttonText) {
    // If output is "Undefined", prevent further input
    if (output == "Undefined" && buttonText != "CLEAR") {
      return; // Ignore all inputs except CLEAR
    }

    if (buttonText == "CLEAR") {
      _output = "0"; // Reset output
      num1 = 0.0; // Reset num1
      num2 = 0.0; // Reset num2
      operand = ""; // Reset operator
      expression = ""; // Reset expression
      isResultDisplayed = false; // Reset result display flag
      isEqualPressed = false; // Reset equal flag
    } else if (buttonText == "+" || buttonText == "-" || buttonText == "÷" || buttonText == "x") {
      // If there is already a result from pressing equals, reset before new operation
      if (isEqualPressed) {
        num1 = double.tryParse(output) ?? 0;
        isEqualPressed = false;
      }

      // Save the current output and prepare for the next input
      if (operand.isNotEmpty) {
        num2 = double.tryParse(output) ?? 0; // Get the second operand safely
        calculateResult(); // Calculate the result of the previous operation
      } else {
        num1 = double.tryParse(output) ?? 0; // Set num1 for the first operation
      }
      operand = buttonText; // Update the current operator
      _output = "0"; // Reset internal output for the next number
      expression = "${formatNumber(num1)} $operand "; // Update expression with formatted number
      isResultDisplayed = false; // Reset the result display flag
    } else if (buttonText == ".") {
      if (_output.contains(".")) {
        return; // Prevent multiple decimals
      } else {
        _output = _output + buttonText; // Append decimal point
      }
    } else if (buttonText == "=") {
      // Prevent repeated equals calculation
      if (isEqualPressed) {
        return; // Do nothing if `=` was already pressed
      }

      // Only calculate if the result has not been displayed yet
      if (!isResultDisplayed) {
        num2 = double.tryParse(output) ?? 0; // Get the last number safely
        if (operand.isEmpty) {
          return; // If no operand is set, do nothing on equals press
        }
        calculateResult(); // Calculate the final result
        isResultDisplayed = true; // Set the flag to indicate result has been displayed
        isEqualPressed = true; // Prevent multiple equals presses
      }
    } else if (isScientific && (buttonText == "sin" || buttonText == "cos" || buttonText == "tan")) {
      num1 = double.tryParse(output) ?? 0; // Get current output for trigonometric functions
      calculateTrigonometric(buttonText); // Calculate the trigonometric result
      isResultDisplayed = false; // Reset the result display flag
    } else {
      // If result was displayed and a new number is pressed, reset the output
      if (isResultDisplayed || isEqualPressed) {
        _output = ""; // Clear the output if a result was displayed
        isResultDisplayed = false; // Reset the result flag
        isEqualPressed = false; // Reset equal flag
      }

      // If _output is "0", replace it; otherwise, just append the buttonText
      if (_output == "0") {
        _output = buttonText;
      } else {
        _output = _output + buttonText; // Append the number
      }
      isResultDisplayed = false; // Reset the result display flag
    }

    setState(() {
      output = _output; // Update displayed output
    });
  }

  void calculateResult() {
    double result = 0.0;

    // Perform calculation based on the operator
    if (operand == "+") {
      result = num1 + num2; // Addition
    }
    if (operand == "-") {
      result = num1 - num2; // Subtraction
    }
    if (operand == "x") {
      result = num1 * num2; // Multiplication
    }
    if (operand == "÷") {
      if (num2 == 0) {
        _output = "Undefined"; // Handle division by zero
        expression = "Undefined";
        return;
      } else {
        result = num1 / num2; // Division
      }
    }

    // Format the result and expression
    _output = formatNumber(result);
    expression = "${formatNumber(num1)} $operand ${formatNumber(num2)} =";

    num1 = result; // Store result for further calculations
    num2 = 0.0; // Reset num2 for the next operation
    operand = ""; // Reset operator
  }

  void calculateTrigonometric(String function) {
    // Convert degrees to radians
    double radians = num1 * (pi / 180);

    if (function == "sin") {
      _output = (sin(radians)).toStringAsFixed(2); // Sine calculation, format to 2 decimal places
    } else if (function == "cos") {
      _output = (cos(radians)).toStringAsFixed(2); // Cosine calculation, format to 2 decimal places
    } else if (function == "tan") {
      // Handle special cases for tan
      if (num1 == 90 || num1 == 270) {
        _output = "Undefined"; // Handle tan(90) and tan(270)
      } else {
        _output = (tan(radians)).toStringAsFixed(2); // Tangent calculation, format to 2 decimal places
      }
    }

    expression = "$function(${formatNumber(num1)})"; // Update expression for display
    isResultDisplayed = false; // Reset the result display flag
  }

  String formatNumber(double number) {
    return number.truncateToDouble() == number ? number.toStringAsFixed(0) : number.toString();
  }

  Widget buildButton(String buttonText) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => buttonPressed(buttonText),
        child: Text(buttonText, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void toggleCalculatorType(String type) {
    setState(() {
      isScientific = type == 'Scientific'; // Toggle calculator type
    });
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
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
              onTap: () => toggleCalculatorType('Standard'), // Change to Standard mode
            ),
            ListTile(
              leading: Icon(Icons.science),
              title: Text('Scientific', style: TextStyle(fontSize: 18)),
              onTap: () => toggleCalculatorType('Scientific'), // Change to Scientific mode
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0), // Reduced vertical padding
            child: Text(expression, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            child: Text(output, style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Divider(),
          ),
          Column(
            children: [
              Row(
                children: [
                  buildButton("7"),
                  SizedBox(width: 8.0),
                  buildButton("8"),
                  SizedBox(width: 8.0),
                  buildButton("9"),
                  SizedBox(width: 8.0),
                  buildButton("÷"),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  buildButton("4"),
                  SizedBox(width: 8.0),
                  buildButton("5"),
                  SizedBox(width: 8.0),
                  buildButton("6"),
                  SizedBox(width: 8.0),
                  buildButton("x"),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  buildButton("1"),
                  SizedBox(width: 8.0),
                  buildButton("2"),
                  SizedBox(width: 8.0),
                  buildButton("3"),
                  SizedBox(width: 8.0),
                  buildButton("-"),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  buildButton("."),
                  SizedBox(width: 8.0),
                  buildButton("0"),
                  SizedBox(width: 8.0),
                  buildButton("00"),
                  SizedBox(width: 8.0),
                  buildButton("+"),
                ],
              ),
              SizedBox(height: 8.0),
              if (isScientific) ...[
                Row(
                  children: [
                    buildButton("sin"),
                    SizedBox(width: 8.0),
                    buildButton("cos"),
                    SizedBox(width: 8.0),
                    buildButton("tan"),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    buildButton("log"),
                    SizedBox(width: 8.0),
                    buildButton("ln"),
                    SizedBox(width: 8.0),
                    buildButton("sqrt"),
                  ],
                ),
                SizedBox(height: 8.0),
              ],
              Row(
                children: [
                  buildButton("CLEAR"),
                  SizedBox(width: 8.0),
                  buildButton("="),
                ],
              ),
              SizedBox(height: 8.0), // Bottom gap for CLEAR and = buttons
            ],
          ),
        ],
      ),
    );
  }
}