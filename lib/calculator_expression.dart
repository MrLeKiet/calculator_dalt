import 'dart:math';

class CalculatorExpression {
  String output = "0";
  String _output = "0";
  String _lastOutput = "0"; // Add this variable to store the last output value
  double num1 = 0.0;
  double num2 = 0.0;
  String operand = "";
  String expression = "";
  bool isResultDisplayed = false;
  bool isEqualPressed = false;
  bool isPiPressed = false;
  String currentMode = 'DEC';
  double currentValue = 0.0;
  bool isDegree = true; // Default is Degree

  static const String fullPi = "3.1415926535897932384626433832795";

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
        case "^": // Handle the power operation
          _output = _formatNumber(pow(num1, num2).toDouble());
          break;
      }

      output = _output;
      currentValue = _parseInput(_output);
      isResultDisplayed = true;
      operand = "";
    } catch (e) {
      _output = "Error";
    }
  }

  void calculateTrigonometric(String function) {
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

    // Convert between degrees and radians based on the current mode
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

  void handleSquareRoot() {
    _lastOutput = _output;
    if (operand.isNotEmpty) {
      expression =
          expression.substring(0, expression.lastIndexOf(operand) + 1) +
              " √($_lastOutput)";
    } else {
      expression = "√($_lastOutput)";
    }
    calculateTrigonometric("√");
    isPiPressed = false;
  }

  void handlePi() {
    if (isDegree) {
      _output = "180";
      currentValue = 180.0;
    } else {
      _output = fullPi;
      currentValue = double.parse(fullPi);
    }
    output = _output;
    isPiPressed = true;
  }

  void handleExponent() {
    if (operand.isEmpty) {
      num1 = _parseInput(_output);
      operand = "^";
      expression = _formatNumber(num1) + " ^ ";
      _output = "";
    } else {
      calculateResult();
      num1 = _parseInput(output);
      operand = "^";
      expression = _formatNumber(num1) + " ^ ";
      _output = "";
    }
    isEqualPressed = false;
    isPiPressed = false;
  }

  void handleNumber(String buttonText) {
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
    isEqualPressed = false;
  }

  bool isTrigonometricExpression() {
    return expression.contains("sin") ||
        expression.contains("cos") ||
        expression.contains("tan") ||
        expression.contains("log") ||
        expression.contains("ln") ||
        expression.contains("√");
  }

  void handleTrigonometric(String buttonText) {
    _lastOutput = _output;
    String degreeSymbol = isDegree ? "°" : "";
    if (operand.isNotEmpty) {
      expression =
          expression.substring(0, expression.lastIndexOf(operand) + 1) +
              " $buttonText(${_lastOutput}$degreeSymbol)";
    } else {
      expression = "$buttonText(${_lastOutput}$degreeSymbol)";
    }
    calculateTrigonometric(buttonText);
  }

  void handleOperator(String buttonText) {
    if (operand.isEmpty) {
      num1 = _parseInput(_output);
      operand = buttonText;
      expression = _formatNumber(num1) + " " + buttonText + " ";
      _output = "";
    } else {
      calculateResult();
      num1 = _parseInput(output);
      operand = buttonText;
      expression = _formatNumber(num1) + " " + buttonText + " ";
      _output = "";
    }
    isEqualPressed = false;
    isPiPressed = false;
  }

  void handleEquals() {
    if (!isEqualPressed) {
      if (operand.isNotEmpty) {
        expression += _output;
        calculateResult();
        expression += " =";
      } else if (isTrigonometricExpression()) {
        expression += " =";
      }
      isEqualPressed = true;
    }
    isPiPressed = false;
  }

  void deleteLast() {
    if (_output.length > 1) {
      _output = _output.substring(0, _output.length - 1);
    } else {
      _output = "0";
    }
    output = _output;
    currentValue = _parseInput(_output);
    isPiPressed = false;
  }

  void clearAll() {
    output = "0";
    _output = "0";
    _lastOutput = "0";
    num1 = 0.0;
    num2 = 0.0;
    operand = "";
    expression = "";
    isResultDisplayed = false;
    isEqualPressed = false;
    isPiPressed = false;
    currentValue = 0.0;
  }

  bool isOperator(String buttonText) {
    return buttonText == "+" ||
        buttonText == "-" ||
        buttonText == "x" ||
        buttonText == "÷";
  }

  bool isTrigonometricFunction(String buttonText) {
    return buttonText == "sin" ||
        buttonText == "cos" ||
        buttonText == "tan" ||
        buttonText == "log" ||
        buttonText == "ln";
  }
}