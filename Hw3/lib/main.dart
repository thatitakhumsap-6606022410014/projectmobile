import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Calculator",
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String num1 = "";
  String num2 = "";
  String operator = "";
  String showVal = "0";
  double result = 0.0;

  void inputNumber(String number) {
    setState(() {
      if (operator.isEmpty) {
        num1 += number;
        showVal = num1;
      } else {
        num2 += number;
        showVal = num1 + " " + operator + " " + num2;
      }
    });
  }

  void setOperator(String op) {
    setState(() {
      if (num1.isNotEmpty) {
        operator = op;
        showVal = num1 + " " + op;
      }
    });
  }

  void calculate() {
    setState(() {
      if (num1.isEmpty) return;

      if (operator == "√") {
        double value = double.parse(num1);
        if (value < 0) {
          showVal = "Error";
          return;
        }
        result = sqrt(value);
        showVal = result.toString();
        num1 = result.toString();
        operator = "";
        return;
      }

      if (num2.isEmpty) return;

      double val1 = double.parse(num1);
      double val2 = double.parse(num2);

      if (operator == "+") {
        result = val1 + val2;
      } else if (operator == "-") {
        result = val1 - val2;
      } else if (operator == "*") {
        result = val1 * val2;
      } else if (operator == "/") {
        if (val2 != 0) {
          result = val1 / val2;
        } else {
          showVal = "Error";
          num1 = "";
          num2 = "";
          operator = "";
          return;
        }
      } else if (operator == "%") {
        result = (val1 / 100) * val2;
      } else if (operator == "^") {
        result = pow(val1, val2).toDouble();
      }

      if (result == result.toInt()) {
        showVal = result.toInt().toString();
        num1 = result.toInt().toString();
      } else {
        showVal = result.toString();
        num1 = result.toString();
      }
      num2 = "";
      operator = "";
    });
  }

  void clear() {
    setState(() {
      num1 = "";
      num2 = "";
      operator = "";
      showVal = "0";
      result = 0.0;
    });
  }

  void deleteLastDigit() {
    setState(() {
      if (operator.isEmpty && num1.isNotEmpty) {
        num1 = num1.substring(0, num1.length - 1);
        showVal = num1.isEmpty ? "0" : num1;
      } else if (operator.isNotEmpty && num2.isNotEmpty) {
        num2 = num2.substring(0, num2.length - 1);
        showVal = num2.isEmpty ? "0" : num2;
      }
    });
  }

  void calculateSquareRoot() {
    setState(() {
      if (num1.isEmpty) return;
      double value = double.parse(num1);
      if (value < 0) {
        showVal = "Error";
        return;
      }
      result = sqrt(value);
      if (result == result.toInt()) {
        showVal = result.toInt().toString();
        num1 = result.toInt().toString();
      } else {
        showVal = result.toString();
        num1 = result.toString();
      }
      operator = "";
    });
  }

  Widget buildButton(String text, Color bgColor, Color textColor, VoidCallback onPressed, {double? width}) {
    return SizedBox(
      width: width ?? 70,
      height: 70,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 3,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F0F6),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Calculator",
          style: TextStyle(color: Colors.black87, fontSize: 20),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                constraints: const BoxConstraints(minHeight: 80),
                alignment: Alignment.center,
                child: Text(
                  showVal,
                  style: const TextStyle(
                    fontSize: 48,
                    color: Color(0xFFFF6B6B),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 60),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButton("7", const Color(0xFFE8DEF8), Colors.black87, () => inputNumber("7")),
                const SizedBox(width: 15),
                buildButton("8", const Color(0xFFE8DEF8), Colors.black87, () => inputNumber("8")),
                const SizedBox(width: 15),
                buildButton("9", const Color(0xFFE8DEF8), Colors.black87, () => inputNumber("9")),
                const SizedBox(width: 15),
                buildButton("+", const Color(0xFFE8DEF8), Colors.black87, () => setOperator("+")),
              ],
            ),
            const SizedBox(height: 15),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButton("4", const Color(0xFFE8DEF8), Colors.black87, () => inputNumber("4")),
                const SizedBox(width: 15),
                buildButton("5", const Color(0xFFE8DEF8), Colors.black87, () => inputNumber("5")),
                const SizedBox(width: 15),
                buildButton("6", const Color(0xFFE8DEF8), Colors.black87, () => inputNumber("6")),
                const SizedBox(width: 15),
                buildButton("-", const Color(0xFFE8DEF8), Colors.black87, () => setOperator("-")),
              ],
            ),
            const SizedBox(height: 15),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButton("1", const Color(0xFFE8DEF8), Colors.black87, () => inputNumber("1")),
                const SizedBox(width: 15),
                buildButton("2", const Color(0xFFE8DEF8), Colors.black87, () => inputNumber("2")),
                const SizedBox(width: 15),
                buildButton("3", const Color(0xFFE8DEF8), Colors.black87, () => inputNumber("3")),
                const SizedBox(width: 15),
                buildButton("*", const Color(0xFFE8DEF8), Colors.black87, () => setOperator("*")),
              ],
            ),
            const SizedBox(height: 15),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButton("0", const Color(0xFFE8DEF8), Colors.black87, () => inputNumber("0")),
                const SizedBox(width: 15),
                buildButton("C", const Color(0xFF6750A4), Colors.white, clear),
                const SizedBox(width: 15),
                buildButton("=", const Color(0xFFE8DEF8), Colors.black87, calculate),
                const SizedBox(width: 15),
                buildButton("/", const Color(0xFFE8DEF8), Colors.black87, () => setOperator("/")),
              ],
            ),
            const SizedBox(height: 15),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButton("DEL", const Color(0xFF42A5F5), Colors.white, deleteLastDigit),
                const SizedBox(width: 15),
                buildButton("%", const Color(0xFFFF5252), Colors.white, () => setOperator("%")),
                const SizedBox(width: 15),
                buildButton("^", const Color(0xFFFF5252), Colors.white, () => setOperator("^")),
                const SizedBox(width: 15),
                buildButton("√", const Color(0xFFFF5252), Colors.white, calculateSquareRoot),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}