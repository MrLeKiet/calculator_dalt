import 'package:flutter/material.dart';


void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
  home: CalculatorHome(),
  theme: ThemeData(
    primaryColor: Colors.blueGrey, // Sử dụng primaryColor
  ),
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

  // Phần CSS (Kiểu dáng)
  final ButtonStyle buttonStyle = OutlinedButton.styleFrom(
  padding: EdgeInsets.all(24.0),
  foregroundColor: Colors.white, // Thay primary bằng foregroundColor
  backgroundColor: Colors.grey[850],
  side: BorderSide(color: Colors.grey[700]!),
);

  TextStyle displayStyle = TextStyle(
    fontSize: 48.0,
    fontWeight: FontWeight.bold,
  );

  TextStyle buttonTextStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );

  // Phần Chức Năng
  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "CLEAR") {
        _output = "0";
        num1 = 0.0;
        num2 = 0.0;
        operand = "";
      } else if (buttonText == "DELETE") {
        if (_output.length > 1) {
          _output = _output.substring(0, _output.length - 1);
        } else {
          _output = "0"; // Nếu không còn ký tự nào, đặt lại về 0
        }
      } else if (buttonText == "+" || buttonText == "-" || buttonText == "×" || buttonText == "÷") {
        num1 = double.parse(output);
        operand = buttonText;
        _output = "0";
      } else if (buttonText == ".") {
        if (_output.contains(".")) {
          return; // Nếu đã có dấu chấm thì không cho thêm
        } else {
          _output = _output + buttonText; // Thêm dấu chấm
        }
      } else if (buttonText == "=") {
        num2 = double.parse(output);

        // Tính toán kết quả
        if (operand == "+") {
          _output = (num1 + num2).toString();
        }
        if (operand == "-") {
          _output = (num1 - num2).toString();
        }
        if (operand == "×") {
          _output = (num1 * num2).toString();
        }
        if (operand == "÷") {
          _output = (num1 / num2).toString();
        }

        // Đặt lại các biến
        num1 = 0.0;
        num2 = 0.0;
        operand = "";
      } else {
        // Thêm số vào đầu vào
        if (_output == "0") {
          _output = buttonText; // Thay thế bằng số được nhấn
        } else {
          _output = _output + buttonText; // Cập nhật chuỗi đầu vào
        }
      }

      // Đặt lại kết quả đầu ra
      output = double.parse(_output).toStringAsFixed(2);
      if (output.endsWith(".00")) {
        output = output.substring(0, output.length - 3); // Loại bỏ .00
      }
    });
  }

  Widget buildButton(String buttonText) {
    return Expanded(
      child: OutlinedButton(
        style: buttonStyle,
        child: Text(
          buttonText,
          style: buttonTextStyle,
        ),
        onPressed: () => buttonPressed(buttonText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            child: Text(
              output,
              style: displayStyle,
            ),
          ),
          Expanded(child: Divider()),
          Column(
            children: [
              Row(
                children: [
                  buildButton("7"),
                  buildButton("8"),
                  buildButton("9"),
                  buildButton("÷"),
                ],
              ),
              Row(
                children: [
                  buildButton("4"),
                  buildButton("5"),
                  buildButton("6"),
                  buildButton("×"),
                ],
              ),
              Row(
                children: [
                  buildButton("1"),
                  buildButton("2"),
                  buildButton("3"),
                  buildButton("-"),
                ],
              ),
              Row(
                children: [
                  buildButton("0"),
                  buildButton("."),
                  buildButton("DELETE"), // Nút xóa 1 ký tự
                  buildButton("+"),
                ],
              ),
              Row(
                children: [
                  buildButton("CLEAR"),
                  buildButton("="),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}