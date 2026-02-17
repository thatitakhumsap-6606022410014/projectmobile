import 'package:flutter/material.dart';
import 'rec.dart';
import 'tri.dart';
import 'cir.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // 0 = Area, 1 = Volume

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'Area Calculator' : 'Volume Calculator',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade700],
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
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'เลือกรูปทรงเรขาคณิต',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _selectedIndex == 0
                      ? 'คำนวณพื้นที่'
                      : 'คำนวณปริมาตร',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: ListView(
                    children: [
                      _buildShapeCard(
                        context,
                        'สี่เหลี่ยม',
                        'Rectangle',
                        Icons.crop_square,
                        Colors.orange,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RectanglePage(
                                calculationType: _selectedIndex == 0
                                    ? 'Area'
                                    : 'Volume',
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildShapeCard(
                        context,
                        'สามเหลี่ยม',
                        'Triangle',
                        Icons.change_history,
                        Colors.green,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrianglePage(
                                calculationType: _selectedIndex == 0
                                    ? 'Area'
                                    : 'Volume',
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildShapeCard(
                        context,
                        'วงกลม',
                        'Circle',
                        Icons.circle_outlined,
                        Colors.purple,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CirclePage(
                                calculationType: _selectedIndex == 0
                                    ? 'Area'
                                    : 'Volume',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 16,
        unselectedFontSize: 14,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.square_foot, size: 30),
            label: 'Area (พื้นที่)',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_in_ar, size: 30),
            label: 'Volume (ปริมาตร)',
          ),
        ],
      ),
    );
  }

  Widget _buildShapeCard(
    BuildContext context,
    String titleThai,
    String titleEng,
    IconData icon,
    MaterialColor color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [color.shade100, color.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.shade100.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  size: 50,
                  color: color.shade700,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleThai,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      titleEng,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color.shade700,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}