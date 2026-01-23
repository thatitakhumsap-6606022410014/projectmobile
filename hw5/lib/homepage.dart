import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'result.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _digit1Controller = TextEditingController();
  final TextEditingController _digit2Controller = TextEditingController();
  final TextEditingController _digit3Controller = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final FocusNode _digit1Focus = FocusNode();
  final FocusNode _digit2Focus = FocusNode();
  final FocusNode _digit3Focus = FocusNode();
  final FocusNode _amountFocus = FocusNode();

  @override
  void dispose() {
    _digit1Controller.dispose();
    _digit2Controller.dispose();
    _digit3Controller.dispose();
    _amountController.dispose();
    _digit1Focus.dispose();
    _digit2Focus.dispose();
    _digit3Focus.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  void _checkLottery() {
    if (_digit1Controller.text.isEmpty ||
        _digit2Controller.text.isEmpty ||
        _digit3Controller.text.isEmpty ||
        _amountController.text.isEmpty) {
      _showErrorDialog('กรุณากรอกข้อมูลให้ครบทุกช่อง');
      return;
    }

    final digit1 = int.tryParse(_digit1Controller.text);
    final digit2 = int.tryParse(_digit2Controller.text);
    final digit3 = int.tryParse(_digit3Controller.text);
    final amount = int.tryParse(_amountController.text);

    if (digit1 == null || digit2 == null || digit3 == null || amount == null) {
      _showErrorDialog('กรุณากรอกตัวเลขที่ถูกต้อง');
      return;
    }

    if (amount <= 0) {
      _showErrorDialog('กรุณากรอกจำนวนเงินมากกว่า 0');
      return;
    }

    final userNumber = '$digit1$digit2$digit3';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          userNumber: userNumber,
          amount: amount,
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ข้อผิดพลาด'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ตรวจสอบ'),
          ),
        ],
      ),
    );
  }

  Widget _buildDigitTextField({
    required TextEditingController controller,
    required FocusNode currentFocus,
    FocusNode? nextFocus,
    required String label,
  }) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            focusNode: currentFocus,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(width: 2, color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(width: 2, color: Colors.blue),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && nextFocus != null) {
                nextFocus.requestFocus();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ระบบออกรางวัลเลขท้าย 3 หลัก',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.stars,
                        size: 64,
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'เลือกเลขท้าย 3 หลัก',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDigitTextField(
                            controller: _digit1Controller,
                            currentFocus: _digit1Focus,
                            nextFocus: _digit2Focus,
                            label: 'หลักที่ 3',
                          ),
                          _buildDigitTextField(
                            controller: _digit2Controller,
                            currentFocus: _digit2Focus,
                            nextFocus: _digit3Focus,
                            label: 'หลักที่ 2',
                          ),
                          _buildDigitTextField(
                            controller: _digit3Controller,
                            currentFocus: _digit3Focus,
                            nextFocus: _amountFocus,
                            label: 'หลักที่ 1',
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'จำนวนเงินที่ต้องการซื้อ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            child: TextField(
                              controller: _amountController,
                              focusNode: _amountFocus,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                                hintText: '300',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'บาท',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: _checkLottery,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'คลิก ตรวจรางวัล',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}