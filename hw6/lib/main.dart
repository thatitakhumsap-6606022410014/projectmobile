import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grade Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const GradeCalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GradeCalculatorScreen extends StatefulWidget {
  const GradeCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<GradeCalculatorScreen> createState() => _GradeCalculatorScreenState();
}

class _GradeCalculatorScreenState extends State<GradeCalculatorScreen> {
  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _midtermController = TextEditingController();
  final TextEditingController _assignmentController = TextEditingController();
  final TextEditingController _finalController = TextEditingController();

  String _selectedMajor = 'INE';
  String? _selectedSubject;
  
  String _resultName = '';
  String _resultScores = '';
  String _resultTotal = '';
  String _resultGrade = '';
  bool _showResult = false;

  // Subject list
  final List<String> _subjects = [
    'CS101 - English',
    'CS201 - Mobile',
    'CS301 - Network Programming',
    'CS401 - Cybersecurity',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _midtermController.dispose();
    _assignmentController.dispose();
    _finalController.dispose();
    super.dispose();
  }

  String _calculateGrade(double totalScore) {
    if (totalScore >= 80) return 'A';
    if (totalScore >= 70) return 'B';
    if (totalScore >= 60) return 'C';
    if (totalScore >= 50) return 'D';
    return 'F';
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.deepOrange;
      case 'F':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _calculateResult() {
    // Validation
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      _showErrorDialog('กรุณากรอกชื่อและนามสกุล');
      return;
    }

    if (_selectedSubject == null) {
      _showErrorDialog('กรุณาเลือกรหัสวิชา');
      return;
    }

    if (_assignmentController.text.isEmpty ||
        _midtermController.text.isEmpty ||
        _finalController.text.isEmpty) {
      _showErrorDialog('กรุณากรอกคะแนนให้ครบทุกช่อง');
      return;
    }

    // Parse scores
    double assignmentScore = double.tryParse(_assignmentController.text) ?? 0;
    double midtermScore = double.tryParse(_midtermController.text) ?? 0;
    double finalScore = double.tryParse(_finalController.text) ?? 0;

    // Validate score range
    if (assignmentScore < 0 || assignmentScore > 50) {
      _showErrorDialog('คะแนนเก็บต้องอยู่ระหว่าง 0-50');
      return;
    }
    if (midtermScore < 0 || midtermScore > 25) {
      _showErrorDialog('คะแนนกลางภาคต้องอยู่ระหว่าง 0-25');
      return;
    }
    if (finalScore < 0 || finalScore > 25) {
      _showErrorDialog('คะแนนปลายภาคต้องอยู่ระหว่าง 0-25');
      return;
    }

    // Calculate total and grade
    double totalScore = assignmentScore + midtermScore + finalScore;
    String grade = _calculateGrade(totalScore);

    // Update result
    setState(() {
      _resultName = '${_firstNameController.text} ${_lastNameController.text}';
      _resultScores = 'คะแนนเก็บ: ${assignmentScore.toStringAsFixed(1)} | '
          'กลางภาค: ${midtermScore.toStringAsFixed(1)} | '
          'ปลายภาค: ${finalScore.toStringAsFixed(1)}';
      _resultTotal = 'คะแนนรวม: ${totalScore.toStringAsFixed(1)}';
      _resultGrade = grade;
      _showResult = true;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('แจ้งเตือน'),
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

  void _resetForm() {
    setState(() {
      _firstNameController.clear();
      _lastNameController.clear();
      _midtermController.clear();
      _assignmentController.clear();
      _finalController.clear();
      _selectedMajor = 'INE';
      _selectedSubject = null;
      _showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('คำนวณเกรด'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.school, size: 50, color: Colors.blue[700]),
                    const SizedBox(height: 8),
                    Text(
                      'ระบบคำนวณเกรดนักศึกษา',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Student Information Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ข้อมูลนักศึกษา',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),

                    // First Name
                    TextField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'ชื่อ',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Last Name
                    TextField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'นามสกุล',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Major Selection
                    Text(
                      'สาขาวิชา',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('INE'),
                            value: 'INE',
                            groupValue: _selectedMajor,
                            onChanged: (value) {
                              setState(() {
                                _selectedMajor = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('INET'),
                            value: 'INET',
                            groupValue: _selectedMajor,
                            onChanged: (value) {
                              setState(() {
                                _selectedMajor = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Course Selection Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'รายวิชา',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),

                    // Subject Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedSubject,
                      decoration: const InputDecoration(
                        labelText: 'เลือกรหัสวิชา',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.book),
                      ),
                      items: _subjects.map((String subject) {
                        return DropdownMenuItem<String>(
                          value: subject,
                          child: Text(subject),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSubject = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Score Input Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'คะแนน',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),

                    // Assignment Score
                    TextField(
                      controller: _assignmentController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'คะแนนเก็บ (0-50)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.assignment),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Midterm Score
                    TextField(
                      controller: _midtermController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'คะแนนกลางภาค (0-25)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.edit_note),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Final Score
                    TextField(
                      controller: _finalController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'คะแนนปลายภาค (0-25)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.quiz),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Calculate Button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _calculateResult,
                    icon: const Icon(Icons.calculate),
                    label: const Text('คำนวณเกรด'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _resetForm,
                    icon: const Icon(Icons.refresh),
                    label: const Text('ล้างข้อมูล'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Result Section
            if (_showResult)
              Card(
                elevation: 4,
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.stars, color: Colors.blue[700], size: 28),
                          const SizedBox(width: 8),
                          Text(
                            'ผลการคำนวณ',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      // Student Name
                      _buildResultRow(
                        Icons.person,
                        'ชื่อ-นามสกุล',
                        _resultName,
                      ),
                      const SizedBox(height: 12),

                      // Major
                      _buildResultRow(
                        Icons.school,
                        'สาขา',
                        _selectedMajor,
                      ),
                      const SizedBox(height: 12),

                      // Subject
                      _buildResultRow(
                        Icons.book,
                        'รายวิชา',
                        _selectedSubject ?? '',
                      ),
                      const SizedBox(height: 12),

                      // Scores
                      _buildResultRow(
                        Icons.assessment,
                        'คะแนน',
                        _resultScores,
                      ),
                      const SizedBox(height: 12),

                      // Total Score
                      _buildResultRow(
                        Icons.calculate,
                        'รวม',
                        _resultTotal,
                      ),
                      const SizedBox(height: 20),

                      // Grade Display
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: _getGradeColor(_resultGrade),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'เกรด',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                _resultGrade,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blue[700]),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}