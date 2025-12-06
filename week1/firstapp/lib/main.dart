import 'package:flutter/material.dart';

void main() {
  runApp (MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My App",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text('10014  Tharita'),
      ),
      body: Center(
        child: Image(image: NetworkImage('https://scontent.fbkk5-6.fna.fbcdn.net/v/t39.30808-6/483708903_3613292592303038_5888830699347274744_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=833d8c&_nc_eui2=AeFt13nXGHVgIsE8_X6pTNEfY1EjHiyEtuhjUSMeLIS26OmrsXL-IEAu4TBO9xsEfSZvEe9ZD6eZyYNpSpVIfYky&_nc_ohc=phhzS-abbi4Q7kNvwECt2bG&_nc_oc=AdlD5y1jNkpBFGZFlpk1fvb0Eakn7ecQ6XCiNwGqumNc9H0kgBNMZ_joizl3GHlb6oU&_nc_zt=23&_nc_ht=scontent.fbkk5-6.fna&_nc_gid=Da-QgJdsp9hBYv4FwjVCzA&oh=00_AfjXsicGuz4Tjr4BNBYkN-QdayiQghmtKZEzZl7XQyhvDQ&oe=6933680A')),
      ),
    ),
    theme: ThemeData(primarySwatch: Colors.cyan),
    );
  }
}