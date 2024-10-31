import 'dart:math'; // Import this for mathematical functions
import 'package:flutter/services.dart'; // Import này để sử dụng KeyboardListener
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
  bool isProgrammer = false; // Track programmer mode
  bool isResultDisplayed = false; // Flag to check if result is displayed
  bool isEqualPressed = false; // Prevent multiple equals presses
  bool showTrigonometry = false; // Track visibility of trigonometric buttons
  String currentMode = 'DEC'; // Track current mode (HEX, DEC, OCT, BIN)
  int currentValue = 0; // Store the current value for conversion

  final GlobalKey _trigonometryKey = GlobalKey(); // Key for Trigonometry button

  buttonPressed(String buttonText) {
    if (currentMode == 'BIN' &&
        int.tryParse(buttonText) != null &&
        int.parse(buttonText) > 1) {
      return; // Không làm gì khi người dùng nhấn các nút không hợp lệ trong chế độ BIN
    }
    if (currentMode == 'OCT' &&
        int.tryParse(buttonText) != null &&
        int.parse(buttonText) > 7) {
      return; // Không làm gì khi người dùng nhấn các nút không hợp lệ trong chế độ OCT
    }
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
      currentValue = 0; // Reset current value
    } else if (buttonText == "DEL") {
      if (_output.length > 1) {
        _output =
            _output.substring(0, _output.length - 1); // Delete last character
      } else {
        _output = "0"; // If only one character left, reset to 0
      }
      currentValue =
          int.tryParse(_output, radix: getRadix()) ?? 0; // Update current value
    } else if (buttonText == "+" ||
        buttonText == "-" ||
        buttonText == "÷" ||
        buttonText == "x") {
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
      expression =
          "${formatNumber(num1)} $operand "; // Update expression with formatted number
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
          // Corrected condition
          return; // If no operand is set, do nothing on equals press
        }
        calculateResult(); // Calculate the final result
        isResultDisplayed =
            true; // Set the flag to indicate result has been displayed
        isEqualPressed = true; // Prevent multiple equals presses
      }
    } else if (isScientific &&
        (buttonText == "sin" ||
            buttonText == "cos" ||
            buttonText == "tan" ||
            buttonText == "log" ||
            buttonText == "ln" ||
            buttonText == "√" ||
            buttonText == "π")) {
      num1 = double.tryParse(output) ??
          0; // Get current output for trigonometric functions
      calculateTrigonometric(buttonText); // Calculate the trigonometric result
      isResultDisplayed = false; // Reset the result display flag
      setState(() {
        showTrigonometry = false; // Close the overlay
      });
    } else if (isProgrammer &&
        (buttonText == "A" ||
            buttonText == "B" ||
            buttonText == "C" ||
            buttonText == "D" ||
            buttonText == "E" ||
            buttonText == "F")) {
      if (currentMode == 'HEX') {
        _output = _output + buttonText; // Append HEX characters
      }
      currentValue =
          int.tryParse(_output, radix: 16) ?? 0; // Update current value
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
      currentValue =
          int.tryParse(_output, radix: getRadix()) ?? 0; // Update current value
      isResultDisplayed = false; // Reset the result display flag
    }

    setState(() {
      output = _output; // Update displayed output
    });
  }

  int getRadix() {
    switch (currentMode) {
      case 'HEX':
        return 16;
      case 'OCT':
        return 8;
      case 'BIN':
        return 2;
      default:
        return 10;
    }
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
    currentValue = result.toInt(); // Update current value
  }

  void calculateTrigonometric(String function) {
    // Convert degrees to radians
    double radians = num1 * (pi / 180);

    if (function == "sin") {
      _output = (sin(radians))
          .toString(); // Sine calculation, format to 2 decimal places
    } else if (function == "cos") {
      _output = (cos(radians))
          .toString(); // Cosine calculation, format to 2 decimal places
    } else if (function == "tan") {
      // Handle special cases for tan
      if (num1 == 90 || num1 == 270) {
        _output = "Undefined"; // Handle tan(90) and tan(270)
      } else {
        _output = (tan(radians))
            .toString(); // Tangent calculation, format to 2 decimal places
      }
    } else if (function == "log") {
      _output = (log(num1) / log(10)).toString(); // Logarithm base 10
    } else if (function == "ln") {
      _output = log(num1).toString(); // Natural logarithm
    } else if (function == "√") {
      _output = sqrt(num1).toString(); // Square root
    } else if (function == "π") {
      _output = pi.toString(); // Pi value
    }

    expression =
        "$function(${formatNumber(num1)})"; // Update expression for display
    isResultDisplayed = false; // Reset the result display flag
  }

  String formatNumber(double number) {
    return number.truncateToDouble() == number
        ? number.toStringAsFixed(0)
        : number.toString();
  }

  Widget buildButton(String buttonText,
      {VoidCallback? onPressed, Key? key, bool isActive = false}) {
    // Kiểm tra nếu nút cần bị disabled trong chế độ BIN và OCT
    bool isDisabledInBinary = currentMode == 'BIN' &&
        int.tryParse(buttonText) != null &&
        int.parse(buttonText) > 1;
    bool isDisabledInOctal = currentMode == 'OCT' &&
        int.tryParse(buttonText) != null &&
        int.parse(buttonText) > 7;

    return Expanded(
      child: ElevatedButton(
        key: key,
        onPressed: (isDisabledInBinary || isDisabledInOctal)
            ? null
            : onPressed ?? () => buttonPressed(buttonText),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isActive ? Colors.blue : null, // Highlight active button
        ),
        child: Text(buttonText,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void toggleCalculatorType(String type) {
    setState(() {
      isScientific = type == 'Scientific'; // Toggle calculator type
      isProgrammer = type == 'Programmer'; // Toggle programmer mode
      showTrigonometry = false; // Reset trigonometry buttons visibility

      if (!isProgrammer) {
      currentMode = 'DEC'; // Reset current mode to DEC when not in Programmer mode
    }
    });
    Navigator.pop(context); // Close the drawer
  }

  void toggleTrigonometry() {
    setState(() {
      showTrigonometry = !showTrigonometry; // Toggle trigonometry buttons
    });
  }

  void changeMode(String mode) {
    setState(() {
      currentMode = mode; // Change current mode
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
              onTap: () =>
                  toggleCalculatorType('Standard'), // Change to Standard mode
            ),
            ListTile(
              leading: Icon(Icons.science),
              title: Text('Scientific', style: TextStyle(fontSize: 18)),
              onTap: () => toggleCalculatorType(
                  'Scientific'), // Change to Scientific mode
            ),
            ListTile(
              leading: Icon(Icons.code),
              title: Text('Programmer', style: TextStyle(fontSize: 18)),
              onTap: () => toggleCalculatorType(
                  'Programmer'), // Change to Programmer mode
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 12.0), // Reduced vertical padding
                child: Text(expression,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                child: Text(output,
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
              ),
              if (isProgrammer) ...[
                Flexible(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildButton(
                            "HEX: ${currentValue.toRadixString(16).toUpperCase()}",
                            onPressed: () => changeMode('HEX'),
                            isActive: currentMode == 'HEX'),
                        buildButton("DEC: ${currentValue}",
                            onPressed: () => changeMode('DEC'),
                            isActive: currentMode == 'DEC'),
                        buildButton("OCT: ${currentValue.toRadixString(8)}",
                            onPressed: () => changeMode('OCT'),
                            isActive: currentMode == 'OCT'),
                        buildButton("BIN: ${currentValue.toRadixString(2)}",
                            onPressed: () => changeMode('BIN'),
                            isActive: currentMode == 'BIN'),
                      ],
                    ),
                  ),
                ),
              ],
              Expanded(
                child: Divider(),
              ),
              if (isScientific) ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        key: _trigonometryKey,
                        onPressed: toggleTrigonometry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: showTrigonometry
                              ? Colors.blue
                              : null, // Highlight active button
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Trigonometry",
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              showTrigonometry
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 4.0),
                    Container(
                      width: 80.0, // Set the width of the π button
                      child: ElevatedButton(
                        onPressed: () => buttonPressed("π"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(0), // Remove padding
                        ),
                        child: Text(
                          "π",
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (isProgrammer && currentMode == 'HEX') ...[
                Row(
                  children: [
                    buildButton("A"),
                    SizedBox(width: 4.0),
                    buildButton("B"),
                    SizedBox(width: 4.0),
                    buildButton("C"),
                    SizedBox(width: 4.0),
                    buildButton("D"),
                    SizedBox(width: 4.0),
                    buildButton("E"),
                    SizedBox(width: 4.0),
                    buildButton("F"),
                  ],
                ),
              ],
              Column(
                children: [
                  Row(
                    children: [
                      buildButton("7"),
                      SizedBox(width: 4.0),
                      buildButton("8"),
                      SizedBox(width: 4.0),
                      buildButton("9"),
                      SizedBox(width: 4.0),
                      buildButton("÷"),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      buildButton("4"),
                      SizedBox(width: 4.0),
                      buildButton("5"),
                      SizedBox(width: 4.0),
                      buildButton("6"),
                      SizedBox(width: 4.0),
                      buildButton("x"),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      buildButton("1"),
                      SizedBox(width: 4.0),
                      buildButton("2"),
                      SizedBox(width: 4.0),
                      buildButton("3"),
                      SizedBox(width: 4.0),
                      buildButton("-"),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      buildButton("."),
                      SizedBox(width: 4.0),
                      buildButton("0"),
                      SizedBox(width: 4.0),
                      buildButton("DEL"),
                      SizedBox(width: 4.0),
                      buildButton("+"),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      buildButton("CLEAR"),
                      SizedBox(width: 4.0),
                      buildButton("="),
                    ],
                  ),
                  SizedBox(height: 4.0), // Bottom gap for CLEAR and = buttons
                ],
              ),
            ],
          ),
          if (showTrigonometry)
            Positioned(
              top: _getTrigonometryButtonPosition().dy -
                  30, // Adjust the position as needed
              left: 5.0, // Move to the right by 5.0
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Container(
                  height: 105.0, // Height of the overlay
                  width: 300.0, // Set the desired width here
                  color: const Color.fromARGB(255, 254, 247, 255),
                  // color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 0.0),
                      Row(
                        children: [
                          buildButton("sin"),
                          SizedBox(width: 4.0),
                          buildButton("cos"),
                          SizedBox(width: 4.0),
                          buildButton("tan"),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          buildButton("log"),
                          SizedBox(width: 4.0),
                          buildButton("ln"),
                          SizedBox(width: 4.0),
                          buildButton("√"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Offset _getTrigonometryButtonPosition() {
    final RenderBox renderBox =
        _trigonometryKey.currentContext?.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }
}
