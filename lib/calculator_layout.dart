import 'package:flutter/material.dart';

import 'programmer_calculator_layout.dart';
import 'scientific_calculator_layout.dart';
import 'standard_calculator_layout.dart';

class CalculatorLayout extends StatefulWidget {
  final bool isScientific;
  final bool isProgrammer;
  final bool showTrigonometry;
  final String expression;
  final String output;
  final String currentMode;
  final int currentValue;
  final GlobalKey trigonometryKey;
  final Function(String) buttonPressed;
  final Function toggleTrigonometry;
  final Function(String) changeMode;
  final bool isDegree;
  final Function(bool) onDegreeChange;

  CalculatorLayout({
    required this.isScientific,
    required this.isProgrammer,
    required this.showTrigonometry,
    required this.expression,
    required this.output,
    required this.currentMode,
    required this.currentValue,
    required this.trigonometryKey,
    required this.buttonPressed,
    required this.toggleTrigonometry,
    required this.changeMode,
    required this.isDegree,
    required this.onDegreeChange,
  });

  @override
  _CalculatorLayoutState createState() => _CalculatorLayoutState();
}

class _CalculatorLayoutState extends State<CalculatorLayout> {
  late int currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.currentValue;
    updateCurrentValue();
  }

  void updateCurrentValue() {
    try {
      if (widget.currentMode == 'HEX') {
        currentValue = int.parse(widget.output, radix: 16);
      } else if (widget.currentMode == 'OCT') {
        currentValue = int.parse(widget.output, radix: 8);
      } else if (widget.currentMode == 'BIN') {
        currentValue = int.parse(widget.output, radix: 2);
      } else {
        currentValue = int.parse(widget.output);
      }
    } catch (e) {
      currentValue = 0; // Default value if parsing fails
    }
  }

  @override
  void didUpdateWidget(CalculatorLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.output != widget.output ||
        oldWidget.currentMode != widget.currentMode) {
      updateCurrentValue();
    }
  }

  //Random comment, monkey


  bool isButtonEnabled(String buttonText) {
    if (widget.isProgrammer) {
      if (widget.currentMode == 'HEX') {
        return true; // All buttons are enabled in HEX mode
      } else if (widget.currentMode == 'DEC') {
        return !['A', 'B', 'C', 'D', 'E', 'F'].contains(buttonText);
      } else if (widget.currentMode == 'OCT') {
        return !['8', '9', 'A', 'B', 'C', 'D', 'E', 'F'].contains(buttonText);
      } else if (widget.currentMode == 'BIN') {
        return ![
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          'A',
          'B',
          'C',
          'D',
          'E',
          'F'
        ].contains(buttonText);
      }
    }
    return true; // All buttons are enabled in other modes
  }

  void onButtonPressed(String buttonText) {
    setState(() {
      // Handle button press logic here
      // Ensure the output is updated correctly based on the current mode
      if (widget.isProgrammer && widget.currentMode == 'HEX') {
        // Handle HEX mode logic
        widget.buttonPressed(buttonText);
      } else if (widget.isProgrammer && widget.currentMode == 'OCT') {
        // Handle OCT mode logic
        widget.buttonPressed(buttonText);
      } else if (widget.isProgrammer && widget.currentMode == 'BIN') {
        // Handle BIN mode logic
        widget.buttonPressed(buttonText);
      } else {
        // Handle DEC mode logic (standard/scientific)
        // Example: if buttonText is a digit or operator, update the expression/output
        widget.buttonPressed(buttonText);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ensure the mode is set to DEC when in standard or scientific mode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isProgrammer && widget.currentMode != 'DEC') {
        widget.changeMode('DEC');
      }
    });

    if (widget.isProgrammer) {
      return ProgrammerCalculatorLayout(
        expression: widget.expression,
        output: widget.output,
        currentMode: widget.currentMode,
        currentValue: currentValue,
        buttonPressed: widget.buttonPressed,
        changeMode: widget.changeMode,
      );
    } else if (widget.isScientific) {
      return ScientificCalculatorLayout(
        expression: widget.expression,
        output: widget.output,
        showTrigonometry: widget.showTrigonometry,
        trigonometryKey: widget.trigonometryKey,
        buttonPressed: widget.buttonPressed,
        toggleTrigonometry: widget.toggleTrigonometry,
        isDegree: widget.isDegree,
        onDegreeChange: widget.onDegreeChange,
      );
    } else {
      return StandardCalculatorLayout(
        expression: widget.expression,
        output: widget.output,
        buttonPressed: widget.buttonPressed,
      );
    }
  }
}