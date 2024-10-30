import 'package:flutter/material.dart';

import 'button.dart';

class CalculatorLayout extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
              child: Text(expression,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              child: Text(output,
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
            ),
            if (isProgrammer) ...[
              Flexible(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildProgrameButton(
                          "HEX: ${currentValue.toRadixString(16).toUpperCase()}",
                          onPressed: () => changeMode('HEX'),
                          isActive: currentMode == 'HEX'),
                      SizedBox(height: 4.0),
                      buildProgrameButton("DEC: ${currentValue}",
                          onPressed: () => changeMode('DEC'),
                          isActive: currentMode == 'DEC'),
                      SizedBox(height: 4.0),
                      buildProgrameButton("OCT: ${currentValue.toRadixString(8)}",
                          onPressed: () => changeMode('OCT'),
                          isActive: currentMode == 'OCT'),
                      SizedBox(height: 4.0),
                      buildProgrameButton("BIN: ${currentValue.toRadixString(2)}",
                          onPressed: () => changeMode('BIN'),
                          isActive: currentMode == 'BIN'),
                    ],
                  ),
                ),
              ),
            ],
            if (isScientific) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      key: trigonometryKey,
                      onPressed: () => toggleTrigonometry(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: showTrigonometry ? Colors.blue : null,
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
                    width: 80.0,
                    child: ElevatedButton(
                      onPressed: () => buttonPressed("π"),
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
            Visibility(
              visible: isProgrammer && currentMode == 'HEX',
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Row(
                children: [
                  buildButton("A", onPressed: () => buttonPressed("A")),
                  SizedBox(width: 4.0),
                  buildButton("B", onPressed: () => buttonPressed("B")),
                  SizedBox(width: 4.0),
                  buildButton("C", onPressed: () => buttonPressed("C")),
                  SizedBox(width: 4.0),
                  buildButton("D", onPressed: () => buttonPressed("D")),
                  SizedBox(width: 4.0),
                  buildButton("E", onPressed: () => buttonPressed("E")),
                  SizedBox(width: 4.0),
                  buildButton("F", onPressed: () => buttonPressed("F")),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    buildButton("7", onPressed: () => buttonPressed("7")),
                    SizedBox(width: 4.0),
                    buildButton("8", onPressed: () => buttonPressed("8")),
                    SizedBox(width: 4.0),
                    buildButton("9", onPressed: () => buttonPressed("9")),
                    SizedBox(width: 4.0),
                    buildButton("÷", onPressed: () => buttonPressed("÷")),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    buildButton("4", onPressed: () => buttonPressed("4")),
                    SizedBox(width: 4.0),
                    buildButton("5", onPressed: () => buttonPressed("5")),
                    SizedBox(width: 4.0),
                    buildButton("6", onPressed: () => buttonPressed("6")),
                    SizedBox(width: 4.0),
                    buildButton("x", onPressed: () => buttonPressed("x")),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    buildButton("1", onPressed: () => buttonPressed("1")),
                    SizedBox(width: 4.0),
                    buildButton("2", onPressed: () => buttonPressed("2")),
                    SizedBox(width: 4.0),
                    buildButton("3", onPressed: () => buttonPressed("3")),
                    SizedBox(width: 4.0),
                    buildButton("-", onPressed: () => buttonPressed("-")),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    buildButton(".", onPressed: () => buttonPressed(".")),
                    SizedBox(width: 4.0),
                    buildButton("0", onPressed: () => buttonPressed("0")),
                    SizedBox(width: 4.0),
                    buildButton("DEL", onPressed: () => buttonPressed("DEL")),
                    SizedBox(width: 4.0),
                    buildButton("+", onPressed: () => buttonPressed("+")),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    buildButton("CLEAR", onPressed: () => buttonPressed("CLEAR")),
                    SizedBox(width: 4.0),
                    buildButton("=", onPressed: () => buttonPressed("=")),
                  ],
                ),
                SizedBox(height: 4.0),
              ],
            ),
          ],
        ),
        if (showTrigonometry)
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
                        buildButton("sin", onPressed: () => buttonPressed("sin")),
                        SizedBox(width: 4.0),
                        buildButton("cos", onPressed: () => buttonPressed("cos")),
                        SizedBox(width: 4.0),
                        buildButton("tan", onPressed: () => buttonPressed("tan")),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        buildButton("log", onPressed: () => buttonPressed("log")),
                        SizedBox(width: 4.0),
                        buildButton("ln", onPressed: () => buttonPressed("ln")),
                        SizedBox(width: 4.0),
                        buildButton("√", onPressed: () => buttonPressed("√")),
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
        trigonometryKey.currentContext?.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }
}