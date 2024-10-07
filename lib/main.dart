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
    } else if (buttonText == "+" || buttonText == "-" || buttonText == "/" || buttonText == "X") {
      // Save the current output and prepare for the next input
      if (operand.isNotEmpty) {
        num2 = double.tryParse(output) ?? 0; // Get the second operand safely
        calculateResult(); // Calculate the result of the previous operation
      } else {
        num1 = double.tryParse(output) ?? 0; // Set num1 for the first operation
      }
      operand = buttonText; // Update the current operator
      _output = "0"; // Reset internal output for the next number
      expression = "$num1 $operand "; // Update expression
      isResultDisplayed = false; // Reset the result display flag
    } else if (buttonText == ".") {
      if (_output.contains(".")) {
        return; // Prevent multiple decimals
      } else {
        _output = _output + buttonText; // Append decimal point
      }
    } else if (buttonText == "=") {
      // Only calculate if the result has not been displayed yet
      if (!isResultDisplayed) {
        num2 = double.tryParse(output) ?? 0; // Get the last number safely
        calculateResult(); // Calculate the final result
        isResultDisplayed = true; // Set the flag to indicate result has been displayed
      }
    } else if (isScientific && (buttonText == "sin" || buttonText == "cos" || buttonText == "tan")) {
      num1 = double.tryParse(output) ?? 0; // Get current output for trigonometric functions
      calculateTrigonometric(buttonText); // Calculate the trigonometric result
      isResultDisplayed = false; // Reset the result display flag
    } else {
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
    // Perform calculation based on the operator
    if (operand == "+") {
      _output = (num1 + num2).toString(); // Addition
    }
    if (operand == "-") {
      _output = (num1 - num2).toString(); // Subtraction
    }
    if (operand == "X") {
      _output = (num1 * num2).toString(); // Multiplication
    }
    if (operand == "/") {
      if (num2 == 0) {
        _output = "Undefined"; // Handle division by zero
      } else {
        _output = (num1 / num2).toString(); // Division
      }
    }
    expression = "$expression $num2 ="; // Update expression for display
    num1 = double.tryParse(_output) ?? 0; // Store result for further calculations
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

    expression = "$function($num1)"; // Update expression for display
    isResultDisplayed = false; // Reset the result display flag
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
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            child: Text(expression, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
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
                  SizedBox(width: 16.0),
                  buildButton("8"),
                  SizedBox(width: 16.0),
                  buildButton("9"),
                  SizedBox(width: 16.0),
                  buildButton("/"),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  buildButton("4"),
                  SizedBox(width: 16.0),
                  buildButton("5"),
                  SizedBox(width: 16.0),
                  buildButton("6"),
                  SizedBox(width: 16.0),
                  buildButton("X"),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  buildButton("1"),
                  SizedBox(width: 16.0),
                  buildButton("2"),
                  SizedBox(width: 16.0),
                  buildButton("3"),
                  SizedBox(width: 16.0),
                  buildButton("-"),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  buildButton("."),
                  SizedBox(width: 16.0),
                  buildButton("0"),
                  SizedBox(width: 16.0),
                  buildButton("00"),
                  SizedBox(width: 16.0),
                  buildButton("+"),
                ],
              ),
              SizedBox(height: 16.0),
              if (isScientific) ...[
                Row(
                  children: [
                    buildButton("sin"),
                    SizedBox(width: 16.0),
                    buildButton("cos"),
                    SizedBox(width: 16.0),
                    buildButton("tan"),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    buildButton("log"),
                    SizedBox(width: 16.0),
                    buildButton("ln"),
                    SizedBox(width: 16.0),
                    buildButton("sqrt"),
                  ],
                ),
                SizedBox(height: 16.0),
              ],
              Row(
                children: [
                  buildButton("CLEAR"),
                  SizedBox(width: 16.0),
                  buildButton("="),
                ],
              ),
              SizedBox(height: 16.0), // Bottom gap for CLEAR and = buttons
            ],
          ),
        ],
      ),
    );
  }
}
