import 'package:flutter/material.dart';
import 'dart:math';

class ResultPage extends StatefulWidget {
  final String userNumber;
  final int amount;

  const ResultPage({
    super.key,
    required this.userNumber,
    required this.amount,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late String winningNumber;
  late bool isWinner;
  late int prizeAmount;

  @override
  void initState() {
    super.initState();
    _generateResult();
  }

  void _generateResult() {
    final random = Random();
    final randomNum = random.nextInt(1000);
    winningNumber = randomNum.toString().padLeft(3, '0');

    isWinner = winningNumber == widget.userNumber;

    prizeAmount = isWinner ? widget.amount * 100 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ผลการออกรางวัล',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isWinner
                ? [Colors.amber.shade50, Colors.orange.shade50]
                : [Colors.blue.shade50, Colors.white],
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
                  side: BorderSide(
                    color: isWinner ? Colors.amber.shade700 : Colors.blue.shade200,
                    width: 2,
                  ),
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        isWinner ? Icons.celebration : Icons.sentiment_dissatisfied,
                        size: 80,
                        color: isWinner ? Colors.amber.shade700 : Colors.grey.shade600,
                      ),
                      const SizedBox(height: 24),

                      Text(
                        isWinner ? 'ยินดีด้วย! คุณถูกรางวัล' : 'เสียใจด้วย',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isWinner ? Colors.green.shade700 : Colors.red.shade700,
                        ),
                      ),
                      const SizedBox(height: 32),

                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                              icon: Icons.confirmation_number,
                              label: 'เลขที่คุณซื้อ คือ',
                              value: widget.userNumber,
                              valueColor: Colors.blue.shade900,
                            ),
                            const SizedBox(height: 16),
                            _buildInfoRow(
                              icon: Icons.money,
                              label: 'จำนวนเงินที่คุณซื้อ คือ',
                              value: '${widget.amount} บาท',
                              valueColor: Colors.black87,
                            ),
                            const Divider(height: 32, thickness: 2),
                            _buildInfoRow(
                              icon: Icons.stars,
                              label: 'เลขที่ออก คือ',
                              value: winningNumber,
                              valueColor: Colors.red.shade700,
                            ),
                            if (isWinner) ...[
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                icon: Icons.emoji_events,
                                label: 'ยินดีด้วยคุณถูกรางวัล',
                                value: '',
                                valueColor: Colors.green.shade700,
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                icon: Icons.account_balance_wallet,
                                label: 'รับเงินรางวัล',
                                value: '${prizeAmount.toString().replaceAllMapped(
                                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                  (Match m) => '${m[1]},',
                                )} บาท',
                                valueColor: Colors.green.shade700,
                                isHighlight: true,
                              ),
                            ] else ...[
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                icon: Icons.cancel,
                                label: 'เสียใจด้วย คุณไม่ถูกรางวัล',
                                value: '',
                                valueColor: Colors.red.shade700,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text(
                          'คลิก กลับหน้าหลัก',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 4,
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
    bool isHighlight = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 24,
          color: valueColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (value.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isHighlight ? 24 : 20,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}