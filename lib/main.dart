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

 buttonPressed(String buttonText) {
  if (buttonText == "CLEAR") {
    _output = "0";
    num1 = 0.0;
    num2 = 0.0;
    operand = "";
  }else if (buttonText == "DELETE") {
      if (_output.length > 1) {
        _output = _output.substring(0, _output.length - 1); // Xóa ký tự cuối
      } else {
        _output = "0"; // Nếu không còn ký tự nào, đặt lại về 0
      }} 
  else if (buttonText == "+" || buttonText == "-" || buttonText == "×" || buttonText == "÷") {
    // Nếu đã có phép toán trước đó, tính toán trước
    if (operand.isNotEmpty) {
      num2 = double.parse(output);
      _output = _calculate(num1, num2, operand).toString();
      num1 = double.parse(_output); // lưu kết quả để tính toán tiếp
    } 
    else {
      num1 = double.parse(output);
    }

    operand = buttonText;
    _output = "0";
  } else if (buttonText == "=") {
    num2 = double.parse(output);
    _output = _calculate(num1, num2, operand).toString();

    num1 = 0.0;
    num2 = 0.0;
    operand = "";
  } else if (buttonText == ".") {
    if (_output.contains(".")) {
      return;
    } else {
      _output = _output + buttonText;
    }
  } else {
    if (_output == "0") {
      _output = buttonText;
    } else {
      if (_output == "0") {
        _output = buttonText; // Nếu đầu vào là 0, thay thế bằng số được nhấn
      } else {
        _output = _output + buttonText; // Cập nhật chuỗi đầu vào
      }
    }
  }

  setState(() {
    output = _output;
  });
}

// Hàm tính toán đơn giản
double _calculate(double num1, double num2, String operand) {
  switch (operand) {
    case "+":
      return num1 + num2;
    case "-":
      return num1 - num2;
    case "×":
      return num1 * num2;
    case "÷":
      return num1 / num2;
    default:
      return num1;
  }
}




  Widget buildButton(String buttonText) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(24.0), // Đặt padding ở đây
        ),
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
              ),
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
                  buildButton("."),
                  buildButton("0"),
                  buildButton("00"),
                  buildButton("+"),
                ],
              ),
              Row(
                children: [
                  buildButton("DELETE"), // Nút xóa 1 ký tự
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