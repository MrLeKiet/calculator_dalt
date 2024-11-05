import 'package:flutter/material.dart';

import 'button.dart';

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
    if (oldWidget.output != widget.output || oldWidget.currentMode != widget.currentMode) {
      updateCurrentValue();
    }
  }

  bool isButtonEnabled(String buttonText) {
    if (widget.isProgrammer) {
      if (widget.currentMode == 'HEX') {
        return true; // All buttons are enabled in HEX mode
      } else if (widget.currentMode == 'DEC') {
        return !['A', 'B', 'C', 'D', 'E', 'F'].contains(buttonText);
      } else if (widget.currentMode == 'OCT') {
        return !['8', '9', 'A', 'B', 'C', 'D', 'E', 'F'].contains(buttonText);
      } else if (widget.currentMode == 'BIN') {
        return !['2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'].contains(buttonText);
      }
    }
    return true; // All buttons are enabled in other modes
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                    // child: Text(widget.expression,
                    //     style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    child: Text('${widget.expression} =',  // Thêm dấu "=" vào cuối biểu thức
                           style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                    child: Text(widget.output,
                        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
                  ),
                  if (widget.isProgrammer) ...[
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildProgrameButton(
                                "HEX: ${currentValue.toRadixString(16).toUpperCase()}",
                                onPressed: () => widget.changeMode('HEX'),
                                isActive: widget.currentMode == 'HEX',
                                height: 30.0), // Adjust height here
                            SizedBox(height: 4.0),
                            buildProgrameButton("DEC: ${currentValue}",
                                onPressed: () => widget.changeMode('DEC'),
                                isActive: widget.currentMode == 'DEC',
                                height: 30.0), // Adjust height here
                            SizedBox(height: 4.0),
                            buildProgrameButton("OCT: ${currentValue.toRadixString(8)}",
                                onPressed: () => widget.changeMode('OCT'),
                                isActive: widget.currentMode == 'OCT',
                                height: 30.0), // Adjust height here
                            SizedBox(height: 4.0),
                            buildProgrameButton("BIN: ${currentValue.toRadixString(2)}",
                                onPressed: () => widget.changeMode('BIN'),
                                isActive: widget.currentMode == 'BIN',
                                height: 30.0), // Adjust height here
                          ],
                        ),
                      ),
                    ),
                  ],
                  Visibility(
                    visible: widget.isProgrammer && widget.currentMode == 'HEX',
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Row(
                      children: [
                        buildButton("A", onPressed: () => widget.buttonPressed("A"), isEnabled: isButtonEnabled("A")),
                        SizedBox(width: 4.0),
                        buildButton("B", onPressed: () => widget.buttonPressed("B"), isEnabled: isButtonEnabled("B")),
                        SizedBox(width: 4.0),
                        buildButton("C", onPressed: () => widget.buttonPressed("C"), isEnabled: isButtonEnabled("C")),
                        SizedBox(width: 4.0),
                        buildButton("D", onPressed: () => widget.buttonPressed("D"), isEnabled: isButtonEnabled("D")),
                        SizedBox(width: 4.0),
                        buildButton("E", onPressed: () => widget.buttonPressed("E"), isEnabled: isButtonEnabled("E")),
                        SizedBox(width: 4.0),
                        buildButton("F", onPressed: () => widget.buttonPressed("F"), isEnabled: isButtonEnabled("F")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  if (widget.isScientific) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            key: widget.trigonometryKey,
                            onPressed: () => widget.toggleTrigonometry(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.showTrigonometry ? Colors.blue : null,
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
                                  widget.showTrigonometry
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Container(
                          width: 80.0,
                          child: ElevatedButton(
                            onPressed: () => widget.buttonPressed("π"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(0),
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
                  Row(
                    children: [
                      buildButton("7", onPressed: () => widget.buttonPressed("7"), isEnabled: isButtonEnabled("7")),
                      SizedBox(width: 4.0),
                      buildButton("8", onPressed: () => widget.buttonPressed("8"), isEnabled: isButtonEnabled("8")),
                      SizedBox(width: 4.0),
                      buildButton("9", onPressed: () => widget.buttonPressed("9"), isEnabled: isButtonEnabled("9")),
                      SizedBox(width: 4.0),
                      buildButton("÷", onPressed: () => widget.buttonPressed("÷"), isEnabled: isButtonEnabled("÷")),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      buildButton("4", onPressed: () => widget.buttonPressed("4"), isEnabled: isButtonEnabled("4")),
                      SizedBox(width: 4.0),
                      buildButton("5", onPressed: () => widget.buttonPressed("5"), isEnabled: isButtonEnabled("5")),
                      SizedBox(width: 4.0),
                      buildButton("6", onPressed: () => widget.buttonPressed("6"), isEnabled: isButtonEnabled("6")),
                      SizedBox(width: 4.0),
                      buildButton("x", onPressed: () => widget.buttonPressed("x"), isEnabled: isButtonEnabled("x")),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      buildButton("1", onPressed: () => widget.buttonPressed("1"), isEnabled: isButtonEnabled("1")),
                      SizedBox(width: 4.0),
                      buildButton("2", onPressed: () => widget.buttonPressed("2"), isEnabled: isButtonEnabled("2")),
                      SizedBox(width: 4.0),
                      buildButton("3", onPressed: () => widget.buttonPressed("3"), isEnabled: isButtonEnabled("3")),
                      SizedBox(width: 4.0),
                      buildButton("-", onPressed: () => widget.buttonPressed("-"), isEnabled: isButtonEnabled("-")),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      buildButton(".", onPressed: () => widget.buttonPressed("."), isEnabled: isButtonEnabled(".")),
                      SizedBox(width: 4.0),
                      buildButton("0", onPressed: () => widget.buttonPressed("0"), isEnabled: isButtonEnabled("0")),
                      SizedBox(width: 4.0),
                      buildButton("DEL", onPressed: () => widget.buttonPressed("DEL"), isEnabled: isButtonEnabled("DEL")),
                      SizedBox(width: 4.0),
                      buildButton("+", onPressed: () => widget.buttonPressed("+"), isEnabled: isButtonEnabled("+")),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      buildButton("CLEAR", onPressed: () => widget.buttonPressed("CLEAR"), isEnabled: isButtonEnabled("CLEAR")),
                      SizedBox(width: 4.0),
                      buildButton("=", onPressed: () => widget.buttonPressed("="), isEnabled: isButtonEnabled("=")),
                    ],
                  ),
                  SizedBox(height: 4.0),
                ],
              ),
            ),
          ],
        ),
        if (widget.showTrigonometry)
          Positioned(
            top: _getTrigonometryButtonPosition().dy - 30,
            left: 5.0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Container(
                height: 105.0,
                width: 300.0,
                color: const Color.fromARGB(255, 254, 247, 255),
                child: Column(
                  children: [
                    SizedBox(height: 0.0),
                    Row(
                      children: [
                        buildButton("sin", onPressed: () => widget.buttonPressed("sin")),
                        SizedBox(width: 4.0),
                        buildButton("cos", onPressed: () => widget.buttonPressed("cos")),
                        SizedBox(width: 4.0),
                        buildButton("tan", onPressed: () => widget.buttonPressed("tan")),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        buildButton("log", onPressed: () => widget.buttonPressed("log")),
                        SizedBox(width: 4.0),
                        buildButton("ln", onPressed: () => widget.buttonPressed("ln")),
                        SizedBox(width: 4.0),
                        buildButton("√", onPressed: () => widget.buttonPressed("√")),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Offset _getTrigonometryButtonPosition() {
    final RenderBox renderBox =
        widget.trigonometryKey.currentContext?.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }
}