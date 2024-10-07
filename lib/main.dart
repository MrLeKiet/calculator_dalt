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
  String output = "0";
  String _output = "0";
  double num1 = 0.0;
  double num2 = 0.0;
  String operand = "";
  String expression = "";
  bool isScientific = false;

  buttonPressed(String buttonText) {
    if (buttonText == "CLEAR") {
      _output = "0";
      num1 = 0.0;
      num2 = 0.0;
      operand = "";
      expression = "";
    } else if (buttonText == "+" || buttonText == "-" || buttonText == "/" || buttonText == "X") {
      num1 = double.parse(output);
      operand = buttonText;
      _output = "0";
      expression = "$num1 $operand";
    } else if (buttonText == ".") {
      if (_output.contains(".")) {
        return;
      } else {
        _output = _output + buttonText;
      }
    } else if (buttonText == "=") {
      num2 = double.parse(output);

      if (operand == "+") {
        _output = (num1 + num2).toString();
      }
      if (operand == "-") {
        _output = (num1 - num2).toString();
      }
      if (operand == "X") {
        _output = (num1 * num2).toString();
      }
      if (operand == "/") {
        _output = (num1 / num2).toString();
      }

      expression = "$expression $num2 =";
      num1 = 0.0;
      num2 = 0.0;
      operand = "";
    } else {
      _output = _output + buttonText;
    }

    setState(() {
      output = double.parse(_output).toStringAsFixed(2);
    });
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
      isScientific = type == 'Scientific';
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
                  image: AssetImage('assets/drawer_header_background.jpg'),
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