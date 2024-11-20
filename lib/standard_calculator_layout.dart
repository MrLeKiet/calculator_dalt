import 'package:flutter/material.dart';

class StandardCalculatorLayout extends StatelessWidget {
  final String expression;
  final String output;
  final Function(String) buttonPressed;

  StandardCalculatorLayout({
    required this.expression,
    required this.output,
    required this.buttonPressed,
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
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
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
        ),
      ],
    );
  }

  Widget buildButton(String text, {required Function() onPressed}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}