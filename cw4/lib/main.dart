import 'package:flutter/material.dart';
import 'food.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'CW4'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<foodMenu> menu = [
    foodMenu("กุ้งเผา", "500", "เผา"),
    foodMenu("กระเพราหมู", "80", "ทอด"),
    foodMenu("ผัดไทย", "60", "ทอด"),
    foodMenu("ก๋วยเตี๋ยวต้มยำ", "40", "ต้ม"),
    foodMenu("หมูกระทะ", "300", "ย่าง"),
    foodMenu("เนื้อย่าง", "400", "ย่าง"),
    foodMenu("ต้มยำกุ้ง", "150", "ต้ม"),
    foodMenu("ไก่ทอด", "120", "ทอด"),
    foodMenu("หมูปิ้ง", "50", "ย่าง"),
    foodMenu("ข้าวมันไก่", "45", "นึ่ง"),
    foodMenu("ข้าวผัด", "50", "ทอด"),
    foodMenu("ส้มตำ", "40", "อื่นๆ"),
    foodMenu("ปลาเผา", "200", "เผา"),
    foodMenu("ปลานึ่งมะนาว", "180", "นึ่ง"),
    foodMenu("แกงเขียวหวาน", "90", "ต้ม"),
    foodMenu("ยำวุ้นเส้น", "70", "อื่นๆ"),
    foodMenu("ไก่ย่าง", "150", "ย่าง"),
    foodMenu("หมูทอด", "100", "ทอด"),
    foodMenu("ไข่เจียว", "30", "ทอด"),
    foodMenu("ปลาทอด", "120", "ทอด"),
  ];
  
  int menuCounter = 21;
  List<String> selectedMenus = [];
  int totalPrice = 0;

  void addMenu() {
    setState(() {
      menu.add(foodMenu("เมนู $menuCounter", "100", "อื่นๆ"));
      menuCounter++;
    });
  }

  void removeMenu() {
    setState(() {
      if (menu.isNotEmpty) {
        menu.removeLast();
      }
    });
  }

  void selectMenu(foodMenu food) {
    setState(() {
      selectedMenus.add(food.foodname);
      totalPrice += int.parse(food.foodprice);
    });
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("เลือกเมนู"),
          content: Text(
            "คุณเลือก: ${food.foodname}\n\n"
            "จำนวนจานที่เลือก: ${selectedMenus.length} จาน\n"
            "ราคารวม: $totalPrice บาท"
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("ตะกร้า"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("CW4"),
      ),
      body: ListView.builder(
        itemCount: menu.length,
        itemBuilder: (BuildContext context, int index) {
          foodMenu food = menu[index];
          return ListTile(
            title: Text("เมนูที่ ${index + 1} ${food.foodname}"),
            subtitle: Text("ประเภท: ${food.foodtype} | ราคา ${food.foodprice} บาท"),
            onTap: () {
              selectMenu(food);
            },
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: removeMenu,
            tooltip: 'ลบเมนู',
            child: Icon(Icons.remove),
            heroTag: 'removeButton',
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: addMenu,
            tooltip: 'เพิ่มเมนู',
            child: Icon(Icons.add),
            heroTag: 'addButton',
          ),
        ],
      ),
    );
  }
}