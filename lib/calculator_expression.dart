import 'dart:math';

class CalculatorExpression {
  // Các thuộc tính dùng để lưu trữ kết quả, toán tử, biểu thức, và trạng thái
  String output = "0"; // Chuỗi đầu ra hiển thị
  String _output = "0"; // Chuỗi lưu giá trị tạm thời trong tính toán
  String _lastOutput = "0"; // Lưu giá trị đầu ra trước đó
  double num1 = 0.0; // Toán hạng thứ nhất
  double num2 = 0.0; // Toán hạng thứ hai
  String operand = ""; // Lưu toán tử hiện tại
  String expression = ""; // Biểu thức đầy đủ để hiển thị
  bool isResultDisplayed = false; // Trạng thái đã hiển thị kết quả chưa
  bool isEqualPressed = false; // Trạng thái đã nhấn "=" chưa
  bool isPiPressed = false; // Trạng thái đã nhấn nút Pi chưa
  bool modeChanged = false; // Cờ đánh dấu nếu chế độ (HEX, DEC, ...) thay đổi
  String currentMode = 'DEC'; // Chế độ hiện tại (thập phân, nhị phân, ...)
  double currentValue = 0.0; // Giá trị hiện tại của kết quả
  bool isDegree = true; // Trạng thái Độ (Degree) hoặc Radian
  static const String fullPi =
      "3.1415926535897932384626433832795"; // Giá trị Pi đầy đủ

  double _parseInput(String input) {
    if (currentMode == 'HEX') {
      return int.parse(input, radix: 16).toDouble();
    } else if (currentMode == 'OCT') {
      return int.parse(input, radix: 8).toDouble();
    } else if (currentMode == 'BIN') {
      return int.parse(input, radix: 2).toDouble();
    } else if (input == "Infinity" ||
        input == "Error: Division by zero" ||
        input == "Error") {
      throw FormatException("Invalid input");
    } else {
      return double.parse(input);
    }
  }

  // Phương thức định dạng kết quả thành chuỗi theo chế độ hiện tại
  String _formatNumber(double number) {
    if (currentMode == 'HEX') {
      return number.toInt().toRadixString(16).toUpperCase(); // Định dạng HEX
    } else if (currentMode == 'OCT') {
      return number.toInt().toRadixString(8); // Định dạng OCT
    } else if (currentMode == 'BIN') {
      return number.toInt().toRadixString(2); // Định dạng BIN
    } else {
      return number == number.toInt()
          ? number.toInt().toString()
          : number.toString(); // Định dạng thập phân
    }
  }

  void calculateResult() {
    try {
      num2 = _parseInput(
          _output); // Chuyển _output thành số để làm toán hạng thứ hai
      switch (operand) {
        case "+":
          _output = _formatResultNumber(num1 + num2); // Phép cộng
          break;
        case "-":
          _output = _formatResultNumber(num1 - num2); // Phép trừ
          break;
        case "x":
          _output = _formatResultNumber(num1 * num2); // Phép nhân
          break;
        case "÷":
          if (num2 == 0) {
            _output = "Infinity"; // Xử lý chia cho 0
          } else {
            _output = _formatResultNumber(num1 / num2); // Phép chia
          }
          break;
        case "^":
          _output =
              _formatResultNumber(pow(num1, num2).toDouble()); // Phép lũy thừa
          break;
      }

      // Định dạng kết quả theo chế độ hiện tại
      if (currentMode == 'HEX') {
        output = int.parse(_output).toRadixString(16).toUpperCase();
      } else if (currentMode == 'OCT') {
        output = int.parse(_output).toRadixString(8);
      } else if (currentMode == 'BIN') {
        output = int.parse(_output).toRadixString(2);
      } else {
        output = _output; // Định dạng thập phân
      }

      currentValue = _parseInput(output); // Cập nhật giá trị hiện tại
      isResultDisplayed = true; // Đánh dấu đã hiển thị kết quả
      operand = ""; // Reset toán tử
    } catch (e) {
      _output = "Error"; // Xử lý ngoại lệ
    }
  }

  String _formatResultNumber(double number) {
    return number
        .toStringAsFixed(10)
        .replaceAll(RegExp(r"0+$"), "")
        .replaceAll(RegExp(r"\.$"), "");
  }

  void calculateTrigonometric(String function) {
    double value; // Giá trị cần tính
    String valueStr; // Chuỗi biểu diễn giá trị

    // Kiểm tra nếu _output là giá trị của Pi
    if (_output == fullPi) {
      value = double.parse(fullPi);
      valueStr = fullPi;
    } else {
      value = double.parse(_lastOutput); // Sử dụng giá trị từ _lastOutput
      valueStr = _lastOutput;
    }

    double result = 0.0; // Kết quả tính toán
    bool isValid = true; // Cờ kiểm tra tính hợp lệ của input

    // Chuyển đổi giữa Độ và Radian
    double angle = isDegree ? value * pi / 180 : value;

    // Thực hiện phép toán dựa trên function
    switch (function) {
      case "sin":
        result = sin(angle); // Tính sin
        break;
      case "cos":
        result = cos(angle); // Tính cos
        break;
      case "tan":
        if (value % 180 == 90 && isDegree) {
          isValid = false; // Tan(90° hoặc π/2) không xác định
        } else {
          result = tan(angle);
        }
        break;
      case "log":
        if (value <= 0) {
          isValid = false; // Log không xác định với input <= 0
        } else {
          result = log(value) / log(10); // Log cơ số 10
        }
        break;
      case "ln":
        if (value <= 0) {
          isValid = false; // Log tự nhiên không xác định với input <= 0
        } else {
          result = log(value);
        }
        break;
      case "√":
        if (value < 0) {
          isValid = false; // Căn bậc hai không xác định với số âm
        } else {
          result = sqrt(value);
        }
        break;
    }

    // Định dạng kết quả hoặc hiển thị lỗi
    if (isValid) {
      if (result.abs() < 1e-10) result = 0.0; // Gần bằng 0 thì gán = 0
      _output = _formatResult(result); // Định dạng kết quả
    } else {
      _output = "Invalid input"; // Thông báo lỗi
    }

    output = _output; // Cập nhật đầu ra
    isResultDisplayed = true; // Đánh dấu đã hiển thị kết quả
  }

  String _formatResult(double result) {
    if (result == result.toInt()) {
      return result.toInt().toString();
    } else {
      return result
          .toStringAsFixed(20)
          .replaceAll(RegExp(r'0*$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }
  }

  void handleSquareRoot() {
    _lastOutput = _output; // Lưu lại giá trị đầu ra hiện tại
    if (operand.isNotEmpty) {
      // Nếu đã có toán tử, cập nhật biểu thức bằng cách thêm căn bậc hai
      expression =
          expression.substring(0, expression.lastIndexOf(operand) + 1) +
              " √($_lastOutput)";
    } else {
      // Nếu chưa có toán tử, chỉ thêm căn bậc hai vào biểu thức
      expression = "√($_lastOutput)";
    }
    calculateTrigonometric("√"); // Tính căn bậc hai
    isPiPressed = false; // Reset trạng thái Pi
  }

  void handlePi() {
    if (isDegree) {
      // Nếu chế độ là Degree, gán giá trị Pi tương ứng là 180°
      _output = "180";
      currentValue = 180.0;
    } else {
      // Nếu chế độ là Radian, gán giá trị Pi đầy đủ
      _output = fullPi;
      currentValue = double.parse(fullPi);
    }
    output = _output; // Cập nhật kết quả đầu ra
    isPiPressed = true; // Đánh dấu trạng thái Pi đã được nhấn
  }

  void handleExponent() {
    if (operand.isEmpty) {
      // Nếu chưa có toán tử, gán giá trị hiện tại làm toán hạng thứ nhất
      num1 = _parseInput(_output);
      operand = "^"; // Gán toán tử là "^"
      expression = _formatNumber(num1) + " ^ "; // Cập nhật biểu thức
      _output = ""; // Reset đầu ra
    } else {
      // Nếu đã có toán tử, tính toán kết quả trước
      calculateResult();
      num1 = _parseInput(output); // Cập nhật kết quả làm toán hạng thứ nhất
      operand = "^"; // Gán toán tử là "^"
      expression = _formatNumber(num1) + " ^ ";
      _output = ""; // Reset đầu ra
    }
    isEqualPressed = false; // Reset trạng thái "="
    isPiPressed = false; // Reset trạng thái Pi
  }

  void changeMode(String mode) {
    if (currentMode != mode) {
      try {
        // Chuyển giá trị đầu ra hiện tại về dạng thập phân
        if (currentMode == 'HEX') {
          currentValue = int.parse(output, radix: 16).toDouble();
        } else if (currentMode == 'OCT') {
          currentValue = int.parse(output, radix: 8).toDouble();
        } else if (currentMode == 'BIN') {
          currentValue = int.parse(output, radix: 2).toDouble();
        } else {
          currentValue = double.parse(output);
        }

        // Định dạng kết quả theo chế độ mới
        if (mode == 'HEX') {
          output = currentValue.toInt().toRadixString(16).toUpperCase();
        } else if (mode == 'OCT') {
          output = currentValue.toInt().toRadixString(8);
        } else if (mode == 'BIN') {
          output = currentValue.toInt().toRadixString(2);
        } else {
          output = currentValue.toInt().toString();
        }
      } catch (e) {
        output = "0"; // Reset đầu ra nếu có lỗi
      }
      currentMode = mode; // Cập nhật chế độ hiện tại
      modeChanged = true; // Đánh dấu chế độ đã thay đổi
      expression = ""; // Reset biểu thức
    }
  }

  void handleNumber(String buttonText) {
    if (isResultDisplayed || isPiPressed || modeChanged) {
      // Nếu đã hiển thị kết quả hoặc thay đổi chế độ, reset đầu ra
      _output = buttonText;
      isResultDisplayed = false;
      isPiPressed = false;
      modeChanged = false;
    } else {
      // Nếu đầu ra hiện tại là 0 và nhấn nút ., thay thế bằng 0.
      if (_output == "0" && buttonText == ".") {
        _output = "0.";
      } else if (_output == "0") {
        _output = buttonText;
      } else {
        _output += buttonText; // Thêm số vào chuỗi hiện tại
      }
    }
    output = _output; // Cập nhật kết quả đầu ra
    currentValue = _parseInput(_output); // Cập nhật giá trị hiện tại
    isEqualPressed = false; // Reset trạng thái "="
  }

  bool isTrigonometricExpression() {
    return expression.contains("sin") ||
        expression.contains("cos") ||
        expression.contains("tan") ||
        expression.contains("log") ||
        expression.contains("ln") ||
        expression.contains("√");
  }

  void handleTrigonometric(String buttonText) {
    _lastOutput = _output;
    String degreeSymbol = isDegree ? "°" : "";
    if (operand.isNotEmpty) {
      expression =
          expression.substring(0, expression.lastIndexOf(operand) + 1) +
              " $buttonText(${_lastOutput}$degreeSymbol)";
    } else {
      expression = "$buttonText(${_lastOutput}$degreeSymbol)";
    }
    calculateTrigonometric(buttonText);
  }

  void handleOperator(String buttonText) {
    if (operand.isEmpty) {
      // Nếu chưa có toán tử, gán giá trị hiện tại làm toán hạng thứ nhất
      num1 = currentValue;
      operand = buttonText; // Lưu toán tử
      expression =
          _formatNumber(num1) + " " + buttonText + " "; // Cập nhật biểu thức
      _output = ""; // Reset đầu ra
    } else {
      // Nếu đã có toán tử, tính kết quả trước đó
      calculateResult();
      num1 = _parseInput(output); // Cập nhật kết quả làm toán hạng thứ nhất
      operand = buttonText; // Lưu toán tử mới
      expression = _formatNumber(num1) + " " + buttonText + " ";
      _output = ""; // Reset đầu ra
    }
    isEqualPressed = false; // Reset trạng thái "="
    isPiPressed = false; // Reset trạng thái Pi
  }

  void handleEquals() {
    if (!isEqualPressed) {
      // Nếu toán tử không rỗng, thêm đầu ra vào biểu thức
      if (operand.isNotEmpty) {
        expression += _output;
        calculateResult(); // Tính kết quả phép toán
        expression += " ="; // Thêm dấu "=" vào biểu thức
      } else if (isTrigonometricExpression()) {
        // Nếu là biểu thức lượng giác, chỉ thêm dấu "="
        expression += " =";
      }
      isEqualPressed = true; // Đánh dấu trạng thái "=" đã nhấn
    }
    isPiPressed = false; // Reset trạng thái Pi
  }

  void deleteLast() {
    if (_output.length > 1) {
      // Nếu chuỗi có nhiều hơn 1 ký tự, xóa ký tự cuối
      _output = _output.substring(0, _output.length - 1);
    } else {
      // Nếu chỉ còn 1 ký tự, reset về 0
      _output = "0";
    }
    output = _output; // Cập nhật đầu ra
    currentValue = _parseInput(_output); // Cập nhật giá trị hiện tại
    isPiPressed = false; // Reset trạng thái Pi
  }

  void clearAll() {
    output = "0"; // Reset đầu ra
    _output = "0"; // Reset đầu ra tạm thời
    _lastOutput = "0"; // Reset giá trị đầu ra trước đó
    num1 = 0.0; // Reset toán hạng thứ nhất
    num2 = 0.0; // Reset toán hạng thứ hai
    operand = ""; // Reset toán tử
    expression = ""; // Reset biểu thức
    isResultDisplayed = false; // Reset trạng thái hiển thị kết quả
    isEqualPressed = false; // Reset trạng thái "="
    isPiPressed = false; // Reset trạng thái Pi
    currentValue = 0.0; // Reset giá trị hiện tại
  }

  bool isOperator(String buttonText) {
    return buttonText == "+" ||
        buttonText == "-" ||
        buttonText == "x" ||
        buttonText == "÷";
  }

  bool isTrigonometricFunction(String buttonText) {
    return buttonText == "sin" ||
        buttonText == "cos" ||
        buttonText == "tan" ||
        buttonText == "log" ||
        buttonText == "ln";
  }
}
