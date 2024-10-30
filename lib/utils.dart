import 'dart:math';

String formatNumber(double number) {
  return number.truncateToDouble() == number
      ? number.toStringAsFixed(0)
      : number.toString();
}

int getRadix(String currentMode) {
  switch (currentMode) {
    case 'HEX':
      return 16;
    case 'OCT':
      return 8;
    case 'BIN':
      return 2;
    default:
      return 10;
  }
}