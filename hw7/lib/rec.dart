import 'package:flutter/material.dart';

class RectanglePage extends StatefulWidget {
  final String calculationType; // 'Area' or 'Volume'

  const RectanglePage({super.key, required this.calculationType});

  @override
  State<RectanglePage> createState() => _RectanglePageState();
}

class _RectanglePageState extends State<RectanglePage> {
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _result = '';

  void _calculate() {
    final width = double.tryParse(_widthController.text);
    final length = double.tryParse(_lengthController.text);

    if (widget.calculationType == 'Area') {
      if (width != null && length != null) {
        final area = width * length;
        setState(() {
          _result = 'พื้นที่ = ${area.toStringAsFixed(2)} ตารางหน่วย';
        });
      } else {
        setState(() {
          _result = 'กรุณากรอกข้อมูลให้ครบถ้วน';
        });
      }
    } else {
      // Volume calculation
      final height = double.tryParse(_heightController.text);
      if (width != null && length != null && height != null) {
        final volume = width * length * height;
        setState(() {
          _result = 'ปริมาตร = ${volume.toStringAsFixed(2)} ลูกบาศก์หน่วย';
        });
      } else {
        setState(() {
          _result = 'กรุณากรอกข้อมูลให้ครบถ้วน';
        });
      }
    }
  }

  void _clear() {
    _widthController.clear();
    _lengthController.clear();
    _heightController.clear();
    setState(() {
      _result = '';
    });
  }

  @override
  void dispose() {
    _widthController.dispose();
    _lengthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.calculationType == 'Area'
              ? 'คำนวณพื้นที่สี่เหลี่ยม'
              : 'คำนวณปริมาตรสี่เหลี่ยม',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade400, Colors.orange.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.crop_square,
                          size: 80,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.calculationType == 'Area'
                              ? 'สูตร: พื้นที่ = กว้าง × ยาว'
                              : 'สูตร: ปริมาตร = กว้าง × ยาว × สูง',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildInputField(
                  controller: _widthController,
                  label: 'ความกว้าง (Width)',
                  icon: Icons.width_full,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: _lengthController,
                  label: 'ความยาว (Length)',
                  icon: Icons.height,
                ),
                if (widget.calculationType == 'Volume') ...[
                  const SizedBox(height: 20),
                  _buildInputField(
                    controller: _heightController,
                    label: 'ความสูง (Height)',
                    icon: Icons.vertical_align_top,
                  ),
                ],
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _calculate,
                        icon: const Icon(Icons.calculate, size: 24),
                        label: const Text(
                          'คำนวณ',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _clear,
                        icon: const Icon(Icons.clear, size: 24),
                        label: const Text(
                          'ล้าง',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                if (_result.isNotEmpty)
                  Card(
                    elevation: 4,
                    color: Colors.orange.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.orange.shade700,
                            size: 50,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'ผลลัพธ์',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade900,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _result,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.orange.shade700,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: Colors.orange.shade700),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orange.shade200, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orange.shade700, width: 2),
        ),
      ),
    );
  }
}