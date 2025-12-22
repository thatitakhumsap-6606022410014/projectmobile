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
  List<foodMenu> menu = [];
  int menuCounter = 1; 
  
  void addMenu() {
    setState(() {
      menu.add(foodMenu("เมนู $menuCounter", "100"));
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
            title: Text("เมนูที่ ${index + 1} "),
            subtitle: Text(food.foodname + " ราคา " + food.foodprice + " บาท"),
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

  // List<Widget> getData(int count) {
  //   List<Widget> data = [];
  //   for (var i = 1; i <= count; i++) {
  //     var menu = ListTile(
  //       title: Text("เมนูที่ $i "),
  //       subtitle: Text("ราคาของเมนูที่ $i"),
  //     );
  //     data.add(menu);
  //   }
  //   return data;
  // }
