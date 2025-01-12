import 'package:calculator/button.dart';
import 'package:flutter/material.dart';

class ProgrammerCalculatorLayout extends StatelessWidget {
  final String expression;
  final String output;
  final String currentMode;
  final int currentValue;
  final Function(String) buttonPressed;
  final Function(String) changeMode;

  ProgrammerCalculatorLayout({
    required this.expression,
    required this.output,
    required this.currentMode,
    required this.currentValue,
    required this.buttonPressed,
    required this.changeMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(expression,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                child: Wrap(
                  children: [
                    Text(output,
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  children: [
                    buildModeButton(
                        "HEX: ${currentValue.toRadixString(16).toUpperCase()}",
                        'HEX'),
                    buildModeButton("DEC: ${currentValue}", 'DEC'),
                    buildModeButton(
                        "OCT: ${currentValue.toRadixString(8)}", 'OCT'),
                    buildModeButton(
                        "BIN: ${currentValue.toRadixString(2)}", 'BIN'),
                  ],
                ),
              ),
              Visibility(
                visible: currentMode == 'HEX',
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Row(
                  children: [
                    buildButton("A",
                        onPressed: () => buttonPressed("A"),
                        isEnabled: isButtonEnabled("A")),
                    SizedBox(width: 4.0),
                    buildButton("B",
                        onPressed: () => buttonPressed("B"),
                        isEnabled: isButtonEnabled("B")),
                    SizedBox(width: 4.0),
                    buildButton("C",
                        onPressed: () => buttonPressed("C"),
                        isEnabled: isButtonEnabled("C")),
                    SizedBox(width: 4.0),
                    buildButton("D",
                        onPressed: () => buttonPressed("D"),
                        isEnabled: isButtonEnabled("D")),
                    SizedBox(width: 4.0),
                    buildButton("E",
                        onPressed: () => buttonPressed("E"),
                        isEnabled: isButtonEnabled("E")),
                    SizedBox(width: 4.0),
                    buildButton("F",
                        onPressed: () => buttonPressed("F"),
                        isEnabled: isButtonEnabled("F")),
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
              Row(
                children: [
                  buildButton("7",
                      onPressed: () => buttonPressed("7"),
                      isEnabled: isButtonEnabled("7")),
                  SizedBox(width: 4.0),
                  buildButton("8",
                      onPressed: () => buttonPressed("8"),
                      isEnabled: isButtonEnabled("8")),
                  SizedBox(width: 4.0),
                  buildButton("9",
                      onPressed: () => buttonPressed("9"),
                      isEnabled: isButtonEnabled("9")),
                  SizedBox(width: 4.0),
                  buildButton("÷", onPressed: () => buttonPressed("÷")),
                ],
              ),
              SizedBox(height: 4.0),
              Row(
                children: [
                  buildButton("4",
                      onPressed: () => buttonPressed("4"),
                      isEnabled: isButtonEnabled("4")),
                  SizedBox(width: 4.0),
                  buildButton("5",
                      onPressed: () => buttonPressed("5"),
                      isEnabled: isButtonEnabled("5")),
                  SizedBox(width: 4.0),
                  buildButton("6",
                      onPressed: () => buttonPressed("6"),
                      isEnabled: isButtonEnabled("6")),
                  SizedBox(width: 4.0),
                  buildButton("x", onPressed: () => buttonPressed("x")),
                ],
              ),
              SizedBox(height: 4.0),
              Row(
                children: [
                  buildButton("1",
                      onPressed: () => buttonPressed("1"),
                      isEnabled: isButtonEnabled("1")),
                  SizedBox(width: 4.0),
                  buildButton("2",
                      onPressed: () => buttonPressed("2"),
                      isEnabled: isButtonEnabled("2")),
                  SizedBox(width: 4.0),
                  buildButton("3",
                      onPressed: () => buttonPressed("3"),
                      isEnabled: isButtonEnabled("3")),
                  SizedBox(width: 4.0),
                  buildButton("-", onPressed: () => buttonPressed("-")),
                ],
              ),
              SizedBox(height: 4.0),
              Row(
                children: [
                  buildButton(".",
                      onPressed: () => buttonPressed("."),
                      isEnabled: isButtonEnabled(".")),
                  SizedBox(width: 4.0),
                  buildButton("0",
                      onPressed: () => buttonPressed("0"),
                      isEnabled: isButtonEnabled("0")),
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
        ),
      ],
    );
  }

  Widget buildModeButton(String text, String mode) {
    String displayText = text;
    if (mode == 'BIN') {
      String value = displayText.split(": ")[1];
      if (value == "0") {
        displayText = displayText.split(": ")[0] + ": 0";
      } else {
        displayText = displayText.split(": ")[0] + ": " + _formatBinary(value);
      }
    }
    return GestureDetector(
      onTap: () => changeMode(mode),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: currentMode == mode ? Colors.blue : Colors.transparent,
              width: 5.0,
            ),
          ),
        ),
        child: Text(
          displayText,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: currentMode == mode ? Colors.blue : Colors.black,
          ),
        ),
      ),
    );
  }

  String _formatBinary(String binary) {
    return binary
        .padLeft((binary.length + 3) ~/ 4 * 4, '0')
        .replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ")
        .trim();
  }

  bool isButtonEnabled(String buttonText) {
    if (currentMode == 'HEX') {
      return !['.'].contains(buttonText);
    } else if (currentMode == 'DEC') {
      return !['.', 'A', 'B', 'C', 'D', 'E', 'F'].contains(buttonText);
    } else if (currentMode == 'OCT') {
      return !['.', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F']
          .contains(buttonText);
    } else if (currentMode == 'BIN') {
      return ['0', '1'].contains(buttonText);
    }
    return true; // All buttons are enabled in other modes
  }
}
