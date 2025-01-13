import 'package:flutter/material.dart';

import 'calculator_expression.dart';
import 'calculator_layout.dart'; // Add this line

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  final CalculatorExpression calculatorExpression = CalculatorExpression();
  bool isScientific = false;
  bool isProgrammer = false;
  bool showTrigonometry = false;
  final GlobalKey _trigonometryKey = GlobalKey();

  void buttonPressed(String buttonText) {
    setState(() {
      calculatorExpression.isProgrammer = isProgrammer; // Cập nhật trạng thái
      if (buttonText == "CLEAR") {
        calculatorExpression.clearAll();
      } else if (buttonText == "DEL") {
        calculatorExpression.deleteLast();
      } else if (buttonText == "=") {
        calculatorExpression.handleEquals();
      } else if (calculatorExpression.isOperator(buttonText)) {
        calculatorExpression.handleOperator(buttonText);
      } else if (calculatorExpression.isTrigonometricFunction(buttonText)) {
        calculatorExpression.handleTrigonometric(buttonText);
      } else if (buttonText == "√") {
        calculatorExpression.handleSquareRoot();
      } else if (buttonText == "π") {
        calculatorExpression.handlePi();
      } else if (buttonText == "^") {
        calculatorExpression.handleExponent();
      } else {
        calculatorExpression.handleNumber(buttonText);
      }
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
      calculatorExpression.changeMode(mode);
    });
  }

  void updatePiValueOnModeChange() {
    setState(() {
      if (calculatorExpression.isDegree &&
          calculatorExpression.output == CalculatorExpression.fullPi) {
        calculatorExpression.output = "180";
        calculatorExpression.currentValue = 180.0;
      } else if (!calculatorExpression.isDegree &&
          calculatorExpression.output == "180") {
        calculatorExpression.output = CalculatorExpression.fullPi;
        calculatorExpression.currentValue =
            double.parse(CalculatorExpression.fullPi);
      }
      calculatorExpression.output = calculatorExpression.output;
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
          expression: calculatorExpression.expression,
          output: calculatorExpression.output,
          currentMode: calculatorExpression.currentMode,
          currentValue:
              calculatorExpression.currentValue.toInt(), // Convert to int
          trigonometryKey: _trigonometryKey,
          buttonPressed: buttonPressed,
          toggleTrigonometry: toggleTrigonometry,
          changeMode: changeMode,
          isDegree: calculatorExpression.isDegree,
          onDegreeChange: (value) {
            setState(() {
              calculatorExpression.isDegree = value;
              updatePiValueOnModeChange();
            });
          },
        ),
      ),
    );
  }
}
