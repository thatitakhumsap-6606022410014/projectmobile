import 'package:flutter/material.dart';
import 'dart:math';

class TrianglePage extends StatefulWidget {
  final String calculationType; // 'Area' or 'Volume'

  const TrianglePage({super.key, required this.calculationType});

  @override
  State<TrianglePage> createState() => _TrianglePageState();
}

class _TrianglePageState extends State<TrianglePage> {
  final TextEditingController _baseController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _depthController = TextEditingController();
  String _result = '';

  void _calculate() {
    final base = double.tryParse(_baseController.text);
    final height = double.tryParse(_heightController.text);

    if (widget.calculationType == 'Area') {
      if (base != null && height != null) {
        final area = 0.5 * base * height;
        setState(() {
          _result = 'พื้นที่ = ${area.toStringAsFixed(2)} ตารางหน่วย';
        });
      } else {
        setState(() {
          _result = 'กรุณากรอกข้อมูลให้ครบถ้วน';
        });
      }
    } else {
      // Volume calculation (Triangular Prism)
      final depth = double.tryParse(_depthController.text);
      if (base != null && height != null && depth != null) {
        final volume = 0.5 * base * height * depth;
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
    _baseController.clear();
    _heightController.clear();
    _depthController.clear();
    setState(() {
      _result = '';
    });
  }

  @override
  void dispose() {
    _baseController.dispose();
    _heightController.dispose();
    _depthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.calculationType == 'Area'
              ? 'คำนวณพื้นที่สามเหลี่ยม'
              : 'คำนวณปริมาตรสามเหลี่ยม',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade400, Colors.green.shade700],
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
            colors: [Colors.green.shade50, Colors.white],
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
                          Icons.change_history,
                          size: 80,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.calculationType == 'Area'
                              ? 'สูตร: พื้นที่ = ½ × ฐาน × สูง'
                              : 'สูตร: ปริมาตร = ½ × ฐาน × สูง × ความลึก',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.calculationType == 'Volume'
                              ? '(Triangular Prism)'
                              : '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildInputField(
                  controller: _baseController,
                  label: 'ความยาวฐาน (Base)',
                  icon: Icons.horizontal_rule,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: _heightController,
                  label: 'ความสูง (Height)',
                  icon: Icons.height,
                ),
                if (widget.calculationType == 'Volume') ...[
                  const SizedBox(height: 20),
                  _buildInputField(
                    controller: _depthController,
                    label: 'ความลึก (Depth)',
                    icon: Icons.layers,
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
                          backgroundColor: Colors.green.shade700,
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
                    color: Colors.green.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green.shade700,
                            size: 50,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'ผลลัพธ์',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade900,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _result,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
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
          color: Colors.green.shade700,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green.shade200, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green.shade700, width: 2),
        ),
      ),
    );
  }
}