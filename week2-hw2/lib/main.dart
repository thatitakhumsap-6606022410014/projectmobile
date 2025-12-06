import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static double spacing_size = 16.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String expression = ''; // สมการที่กำลังพิมพ์
  String result = ''; // ผลลัพธ์
  String firstNumber = '';
  String operator = '';
  bool startNewNumber = false;

  // ฟังก์ชันกดปุ่มตัวเลข
  void onNumberPressed(int number) {
    setState(() {
      if (startNewNumber) {
        expression = number.toString();
        startNewNumber = false;
      } else {
        expression += number.toString();
      }
      result = ''; // ล้างผลลัพธ์เมื่อพิมพ์ใหม่
    });
  }

  // ฟังก์ชันกดปุ่มโอเปอเรเตอร์
  void onOperatorPressed(String op) {
    setState(() {
      if (expression.isEmpty) return;
      
      // ถ้ามีโอเปอเรเตอร์อยู่แล้ว ให้คำนวณก่อน
      if (operator.isNotEmpty && !startNewNumber) {
        calculateResult();
        expression = result + ' ' + op + ' ';
      } else {
        expression += ' ' + op + ' ';
      }
      
      operator = op;
      startNewNumber = false;
      result = ''; // ล้างผลลัพธ์ชั่วคราว
    });
  }

  // ฟังก์ชันคำนวณผลลัพธ์
  void calculateResult() {
    try {
      // แยกสมการออกเป็นส่วนๆ
      List<String> parts = expression.split(' ');
      if (parts.length < 3) return;

      double num1 = double.tryParse(parts[0]) ?? 0;
      String op = parts[1];
      double num2 = double.tryParse(parts[2]) ?? 0;
      double calcResult = 0;

      switch (op) {
        case '+':
          calcResult = num1 + num2;
          break;
        case '—':
        case '-':
          calcResult = num1 - num2;
          break;
        case '×':
        case '*':
          calcResult = num1 * num2;
          break;
        case '÷':
        case '/':
          if (num2 != 0) {
            calcResult = num1 / num2;
          } else {
            result = 'Error';
            return;
          }
          break;
        case '%':
          calcResult = num1 % num2;
          break;
      }

      result = _formatResult(calcResult);
    } catch (e) {
      result = 'Error';
    }
  }

  // ฟังก์ชันกดปุ่ม =
  void onEqualsPressed() {
    setState(() {
      if (expression.isEmpty) return;
      
      calculateResult();
      
      // เก็บผลลัพธ์ไว้สำหรับคำนวณต่อ
      if (result.isNotEmpty && result != 'Error') {
        startNewNumber = true;
        operator = '';
      }
    });
  }

  // ฟังก์ชันจัดรูปแบบผลลัพธ์
  String _formatResult(double value) {
    if (value.isInfinite || value.isNaN) {
      return 'Error';
    }
    
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    
    String formatted = value.toStringAsFixed(8);
    formatted = formatted.replaceAll(RegExp(r'0*$'), '');
    formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    return formatted;
  }

  // ฟังก์ชันกดปุ่มจุดทศนิยม
  void onDecimalPressed() {
    setState(() {
      if (expression.isEmpty || startNewNumber) {
        expression = '0.';
        startNewNumber = false;
      } else {
        // หาตัวเลขสุดท้าย
        List<String> parts = expression.split(RegExp(r'[\+\-\×\÷\—\s]'));
        String lastNum = parts.isNotEmpty ? parts.last : '';
        
        if (!lastNum.contains('.')) {
          expression += '.';
        }
      }
      result = '';
    });
  }

  // ฟังก์ชันกดปุ่ม %
  void onPercentPressed() {
    setState(() {
      if (expression.isEmpty) return;
      
      try {
        double num = double.tryParse(expression.split(' ').last) ?? 0;
        num = num / 100;
        
        List<String> parts = expression.split(' ');
        if (parts.length >= 3) {
          parts[parts.length - 1] = _formatResult(num);
          expression = parts.join(' ');
        } else {
          expression = _formatResult(num);
        }
        result = '';
      } catch (e) {
        result = 'Error';
      }
    });
  }

  // ฟังก์ชันล้างหน้าจอ (Clear)
  void onClearPressed() {
    setState(() {
      expression = '';
      result = '';
      firstNumber = '';
      operator = '';
      startNewNumber = false;
    });
  }

  // ฟังก์ชันลบตัวอักษรทีละตัว (Backspace)
  void onBackspacePressed() {
    setState(() {
      if (expression.isNotEmpty) {
        expression = expression.substring(0, expression.length - 1);
        result = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Calculator',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 29, 190, 86),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        color: const Color(0xFF1E1E2E),
        child: Column(
          children: <Widget>[
            Expanded(
              child: DisplaySection(
                expression: expression.isEmpty ? '0' : expression,
                result: result,
              ),
            ),
            SizedBox(height: MyApp.spacing_size),
            ButtonSection(
              onNumberPressed: onNumberPressed,
              onOperatorPressed: onOperatorPressed,
              onEqualsPressed: onEqualsPressed,
              onClearPressed: onClearPressed,
              onBackspacePressed: onBackspacePressed,
              onDecimalPressed: onDecimalPressed,
              onPercentPressed: onPercentPressed,
            ),
          ],
        ),
      ),
    );
  }
}

// หน้าจอแสดงผล - แสดงทั้งสมการและผลลัพธ์
class DisplaySection extends StatelessWidget {
  final String expression;
  final String result;
  
  const DisplaySection({
    super.key,
    required this.expression,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // สมการที่กำลังพิมพ์ (สีแดง)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Text(
              expression,
              style: TextStyle(
                fontSize: 36,
                color: Colors.red[300],
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 8),
          // ผลลัพธ์ (สีน้ำเงิน)
          if (result.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                result,
                style: TextStyle(
                  fontSize: 48,
                  color: Colors.blue[300],
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ส่วนปุ่มทั้งหมด
class ButtonSection extends StatelessWidget {
  final Function(int) onNumberPressed;
  final Function(String) onOperatorPressed;
  final VoidCallback onEqualsPressed;
  final VoidCallback onClearPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback onDecimalPressed;
  final VoidCallback onPercentPressed;

  const ButtonSection({
    super.key,
    required this.onNumberPressed,
    required this.onOperatorPressed,
    required this.onEqualsPressed,
    required this.onClearPressed,
    required this.onBackspacePressed,
    required this.onDecimalPressed,
    required this.onPercentPressed,
  });

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: MyApp.spacing_size,
      crossAxisSpacing: MyApp.spacing_size,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: FunctionBtn(text: 'C', onTap: onClearPressed),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: FunctionBtn(text: '⌫', onTap: onBackspacePressed),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: OperatorBtn(symbol: '%', onTap: onPercentPressed),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 5,
          child: OperatorsColumn(
            onOperatorPressed: onOperatorPressed,
            onEqualsPressed: onEqualsPressed,
          ),
        ),
        
        // ปุ่มตัวเลข 7, 8, 9
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: NumberBtn(number: 7, onTap: () => onNumberPressed(7)),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: NumberBtn(number: 8, onTap: () => onNumberPressed(8)),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: NumberBtn(number: 9, onTap: () => onNumberPressed(9)),
        ),
        
        // ปุ่มตัวเลข 4, 5, 6
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: NumberBtn(number: 4, onTap: () => onNumberPressed(4)),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: NumberBtn(number: 5, onTap: () => onNumberPressed(5)),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: NumberBtn(number: 6, onTap: () => onNumberPressed(6)),
        ),
        
        // ปุ่มตัวเลข 1, 2, 3
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: NumberBtn(number: 1, onTap: () => onNumberPressed(1)),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: NumberBtn(number: 2, onTap: () => onNumberPressed(2)),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: NumberBtn(number: 3, onTap: () => onNumberPressed(3)),
        ),
        
        // แถวล่างสุด
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 1,
          child: NumberBtn(number: 0, onTap: () => onNumberPressed(0)),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: FunctionBtn(text: '•', onTap: onDecimalPressed),
        ),
      ],
    );
  }
}

// ปุ่มตัวเลข
class NumberBtn extends StatelessWidget {
  final int number;
  final VoidCallback? onTap;
  
  const NumberBtn({super.key, required this.number, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C3E),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '$number',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ปุ่มฟังก์ชัน
class FunctionBtn extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  
  const FunctionBtn({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF505050),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ปุ่มโอเปอเรเตอร์
class OperatorBtn extends StatelessWidget {
  final String symbol;
  final VoidCallback? onTap;
  
  const OperatorBtn({super.key, required this.symbol, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFF9500),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            symbol,
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// คอลัมน์โอเปอเรเตอร์
class OperatorsColumn extends StatelessWidget {
  final Function(String) onOperatorPressed;
  final VoidCallback onEqualsPressed;
  
  const OperatorsColumn({
    super.key,
    required this.onOperatorPressed,
    required this.onEqualsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 1,
      mainAxisSpacing: MyApp.spacing_size,
      crossAxisSpacing: MyApp.spacing_size,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: OperatorBtn(symbol: '÷', onTap: () => onOperatorPressed('÷')),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: OperatorBtn(symbol: '×', onTap: () => onOperatorPressed('×')),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: OperatorBtn(symbol: '—', onTap: () => onOperatorPressed('—')),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: OperatorBtn(symbol: '+', onTap: () => onOperatorPressed('+')),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: OperatorBtn(symbol: '=', onTap: onEqualsPressed),
        ),
      ],
    );
  }
}