import 'package:flutter/material.dart';

class ScientificCalculatorLayout extends StatelessWidget {
  final String expression;
  final String output;
  final bool showTrigonometry;
  final GlobalKey trigonometryKey;
  final Function(String) buttonPressed;
  final Function toggleTrigonometry;
  final bool isDegree;
  final Function(bool) onDegreeChange;

  ScientificCalculatorLayout({
    required this.expression,
    required this.output,
    required this.showTrigonometry,
    required this.trigonometryKey,
    required this.buttonPressed,
    required this.toggleTrigonometry,
    required this.isDegree,
    required this.onDegreeChange,
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Text(expression,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
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
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        onDegreeChange(true); // Chọn "Degree"
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDegree ? Colors.blue : Colors.grey,
                      ),
                      child: Text(
                        "Degree",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        onDegreeChange(false); // Chọn "Radian"
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !isDegree ? Colors.blue : Colors.grey,
                      ),
                      child: Text(
                        "Radian",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                  SizedBox(width: 4.0), // Add spacing between buttons
                  Container(
                    width: 80.0,
                    child: ElevatedButton(
                      onPressed: () => buttonPressed("^"), // Call buttonPressed with "^"
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'x',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 103, 80, 164),
                              ),
                            ),
                            WidgetSpan(
                              child: Transform.translate(
                                offset: const Offset(2, -5),
                                child: Text(
                                  'y',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                        buildButton("sin",
                            onPressed: () => buttonPressed("sin")),
                        SizedBox(width: 4.0),
                        buildButton("cos",
                            onPressed: () => buttonPressed("cos")),
                        SizedBox(width: 4.0),
                        buildButton("tan",
                            onPressed: () => buttonPressed("tan")),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        buildButton("log",
                            onPressed: () => buttonPressed("log")),
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

  Widget buildButton(String text, {required Function() onPressed}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: 14.0)),
      ),
    );
  }
}
