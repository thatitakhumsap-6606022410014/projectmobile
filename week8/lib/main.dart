import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'List Example'),
    );
  }
}

// 1. ปรับ Model ให้เก็บข้อมูลพื้นฐานและรูปภาพที่เลือก
class Data {
  int id;
  String name;
  DateTime t;
  String imgPath;
  Data(this.id, this.name, this.t, this.imgPath);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String txt = 'N/A';
  List<Data> mylist = []; 
  int selectedIndex = 0;

  final List<String> imageOptions = [
    'assets/images/ig.png',
    'assets/images/line.png',
    'assets/images/avenger.png',
    'assets/images/maverl.jpg',
    'assets/images/rocket.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(imageOptions.length, (index) {
              return Row(
                children: [
                  Radio(
                    value: index,
                    groupValue: selectedIndex,
                    onChanged: (int? value) {
                      setState(() {
                        selectedIndex = value!;
                      });
                    },
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(imageOptions[index]),
                  ),
                  const SizedBox(width: 10),
                ],
              );
            }),
          ),
          
          const SizedBox(height: 20),
          
          ElevatedButton(
            onPressed: () {
              setState(() {
                txt = "Add item Success";
                mylist.add(Data(
                  mylist.length + 1,
                  'Name ${mylist.length + 1}',
                  DateTime.now(),
                  imageOptions[selectedIndex],
                ));
              });
            },
            child: const Text('Add Item'),
          ),

          const SizedBox(height: 10),
          Text(txt, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Divider(),

          Expanded(
            child: ListView.builder(
              itemCount: mylist.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    color: Colors.primaries[index % Colors.primaries.length],
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(mylist[index].imgPath),
                      ),
                      title: Text(
                        'Title Text (${mylist[index].id})',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        mylist[index].t.toString(),
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_rounded, color: Colors.black45),
                        onPressed: () {
                          setState(() {
                            txt = "Title Text (${mylist[index].id}) is remove";
                            mylist.removeAt(index);
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}