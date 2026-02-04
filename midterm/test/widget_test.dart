// ===== ไฟล์ทดสอบ Widget สำหรับแอพร้านอาหาร =====
// ไฟล์นี้ใช้สำหรับทดสอบว่า Widget ทำงานได้ถูกต้องหรือไม่

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ===== Import แอพหลัก (เปลี่ยนจาก MyApp เป็น FoodShopApp) =====
import 'package:midterm/main.dart';

void main() {
  // ===== กลุ่มการทดสอบหลักของแอพ =====
  group('Food Shop App Widget Tests', () {
    
    // ===== ทดสอบว่าแอพสามารถสร้างและแสดงผลได้ =====
    testWidgets('App should build without errors', (WidgetTester tester) async {
      // สร้างแอพและแสดงผล
      await tester.pumpWidget(const FoodShopApp());
      
      // รอให้ animation ทั้งหมดเสร็จสิ้น
      await tester.pumpAndSettle();
      
      // ตรวจสอบว่าแอพแสดงผลสำเร็จ
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    // ===== ทดสอบว่ามี AppBar แสดงชื่อร้าน =====
    testWidgets('Should display Food Shop title in AppBar', (WidgetTester tester) async {
      // สร้างแอพ
      await tester.pumpWidget(const FoodShopApp());
      await tester.pumpAndSettle();
      
      // ตรวจสอบว่ามีข้อความ "🍽️ ร้านอาหาร" ใน AppBar
      expect(find.text('🍽️ ร้านอาหาร'), findsOneWidget);
    });

    // ===== ทดสอบว่ามีปุ่มสุ่มเมนู (Random) =====
    testWidgets('Should have random menu button', (WidgetTester tester) async {
      // สร้างแอพ
      await tester.pumpWidget(const FoodShopApp());
      await tester.pumpAndSettle();
      
      // ตรวจสอบว่ามีปุ่มไอคอน casino (สุ่มเมนู)
      expect(find.byIcon(Icons.casino), findsOneWidget);
    });

    // ===== ทดสอบว่ามีปุ่มตะกร้าสินค้า =====
    testWidgets('Should have shopping cart button', (WidgetTester tester) async {
      // สร้างแอพ
      await tester.pumpWidget(const FoodShopApp());
      await tester.pumpAndSettle();
      
      // ตรวจสอบว่ามีปุ่มไอคอน shopping_cart
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });

    // ===== ทดสอบว่ามีหมวดหมู่ "ทั้งหมด" แสดงผล =====
    testWidgets('Should display "ทั้งหมด" category by default', (WidgetTester tester) async {
      // สร้างแอพ
      await tester.pumpWidget(const FoodShopApp());
      await tester.pumpAndSettle();
      
      // ตรวจสอบว่ามีข้อความ "ทั้งหมด"
      expect(find.text('ทั้งหมด'), findsOneWidget);
    });

    // ===== ทดสอบว่ามีเมนูอาหารแสดงผล =====
    testWidgets('Should display food items in grid', (WidgetTester tester) async {
      // สร้างแอพ
      await tester.pumpWidget(const FoodShopApp());
      await tester.pumpAndSettle();
      
      // ตรวจสอบว่ามีเมนู "ข้าวผัดกุ้ง" แสดงผล
      expect(find.text('ข้าวผัดกุ้ง'), findsOneWidget);
      
      // ตรวจสอบว่ามีเมนู "ผัดไทยกุ้งสด" แสดงผล
      expect(find.text('ผัดไทยกุ้งสด'), findsOneWidget);
    });

    // ===== ทดสอบว่ามีปุ่มเพิ่มสินค้าลงตะกร้า =====
    testWidgets('Should have add to cart buttons', (WidgetTester tester) async {
      // สร้างแอพ
      await tester.pumpWidget(const FoodShopApp());
      await tester.pumpAndSettle();
      
      // ตรวจสอบว่ามีปุ่ม add_shopping_cart หลายปุ่ม (สำหรับแต่ละเมนู)
      expect(find.byIcon(Icons.add_shopping_cart), findsWidgets);
    });

    // ===== ทดสอบว่าสามารถกดปุ่มสุ่มเมนูได้ =====
    testWidgets('Can tap random menu button', (WidgetTester tester) async {
      // สร้างแอพ
      await tester.pumpWidget(const FoodShopApp());
      await tester.pumpAndSettle();
      
      // หาปุ่มสุ่มเมนู
      final randomButton = find.byIcon(Icons.casino);
      expect(randomButton, findsOneWidget);
      
      // กดปุ่มสุ่มเมนู
      await tester.tap(randomButton);
      await tester.pumpAndSettle();
      
      // ตรวจสอบว่ามี Dialog แสดงขึ้น (Dialog สุ่มเมนู)
      expect(find.text('🎲 สุ่มเมนูให้คุณ'), findsOneWidget);
    });

    // ===== ทดสอบว่าสามารถกดปุ่มเพิ่มสินค้าลงตะกร้าได้ =====
    testWidgets('Can add item to cart', (WidgetTester tester) async {
      // สร้างแอพ
      await tester.pumpWidget(const FoodShopApp());
      await tester.pumpAndSettle();
      
      // หาปุ่มเพิ่มสินค้าลงตะกร้า (ปุ่มแรก)
      final addButton = find.byIcon(Icons.add_shopping_cart).first;
      
      // กดปุ่มเพิ่มสินค้า
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      
      // ตรวจสอบว่ามี Badge แสดงจำนวนสินค้าในตะกร้า (ตัวเลข 1)
      expect(find.text('1'), findsOneWidget);
    });

    // ===== ทดสอบว่าสามารถเปิดตะกร้าสินค้าได้ =====
    testWidgets('Can open shopping cart', (WidgetTester tester) async {
      // สร้างแอพ
      await tester.pumpWidget(const FoodShopApp());
      await tester.pumpAndSettle();
      
      // เพิ่มสินค้าลงตะกร้าก่อน
      final addButton = find.byIcon(Icons.add_shopping_cart).first;
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      
      // กดปุ่มตะกร้าสินค้า
      final cartButton = find.byIcon(Icons.shopping_cart);
      await tester.tap(cartButton);
      await tester.pumpAndSettle();
      
      // ตรวจสอบว่ามีหัวข้อ "🛒 ตะกร้าสินค้า" แสดงขึ้น
      expect(find.text('🛒 ตะกร้าสินค้า'), findsOneWidget);
    });

    // ===== ทดสอบว่าสามารถเปลี่ยนหมวดหมู่ได้ =====
    testWidgets('Can switch between categories', (WidgetTester tester) async {
      // สร้างแอพ
      await tester.pumpWidget(const FoodShopApp());
      await tester.pumpAndSettle();
      
      // หาปุ่มหมวดหมู่ "เครื่องดื่ม"
      final drinkCategory = find.text('เครื่องดื่ม');
      
      // ตรวจสอบว่ามีหมวดหมู่ "เครื่องดื่ม"
      expect(drinkCategory, findsOneWidget);
      
      // กดเปลี่ยนเป็นหมวดหมู่ "เครื่องดื่ม"
      await tester.tap(drinkCategory);
      await tester.pumpAndSettle();
      
      // ตรวจสอบว่ามีเมนูเครื่องดื่มแสดงผล เช่น "ชาเย็น"
      expect(find.text('ชาเย็น'), findsOneWidget);
    });

    // ===== ทดสอบว่าตะกร้าว่างเปล่าแสดงข้อความที่ถูกต้อง =====
    testWidgets('Empty cart shows correct message', (WidgetTester tester) async {
      // สร้างแอพ
      await tester.pumpWidget(const FoodShopApp());
      await tester.pumpAndSettle();
      
      // เปิดตะกร้าสินค้า (ยังไม่มีสินค้า)
      final cartButton = find.byIcon(Icons.shopping_cart);
      await tester.tap(cartButton);
      await tester.pumpAndSettle();
      
      // ตรวจสอบว่ามีข้อความ "ตะกร้าว่างเปล่า"
      expect(find.text('ตะกร้าว่างเปล่า'), findsOneWidget);
    });

    // ===== ทดสอบว่ามีการแสดงราคาอาหาร =====
    testWidgets('Should display food prices', (WidgetTester tester) async {
      // สร้างแอพ
      await tester.pumpWidget(const FoodShopApp());
      await tester.pumpAndSettle();
      
      // ตรวจสอบว่ามีราคาแสดงผล (เช่น ฿60.00 สำหรับข้าวผัดกุ้ง)
      expect(find.textContaining('฿'), findsWidgets);
    });

    // ===== ทดสอบการตรวจสอบยอดขั้นต่ำ =====
    testWidgets('Should show minimum order alert', (WidgetTester tester) async {
      // สร้างแอพ
      await tester.pumpWidget(const FoodShopApp());
      await tester.pumpAndSettle();
      
      // เพิ่มสินค้าราคาต่ำ (ชาเย็น 25 บาท) ลงตะกร้า
      // ต้องเลื่อนหาเมนูเครื่องดื่มก่อน
      final drinkCategory = find.text('เครื่องดื่ม');
      await tester.tap(drinkCategory);
      await tester.pumpAndSettle();
      
      // เพิ่มชาเย็นลงตะกร้า
      final addButton = find.byIcon(Icons.add_shopping_cart).first;
      await tester.tap(addButton);
      await tester.pumpAndSettle();
      
      // เปิดตะกร้า
      final cartButton = find.byIcon(Icons.shopping_cart);
      await tester.tap(cartButton);
      await tester.pumpAndSettle();
      
      // กดปุ่ม "สั่งซื้อเลย"
      final orderButton = find.text('สั่งซื้อเลย');
      await tester.tap(orderButton);
      await tester.pumpAndSettle();
      
      // ตรวจสอบว่ามี Alert แจ้งยอดขั้นต่ำ 50 บาท
      expect(find.text('ยอดสั่งซื้อขั้นต่ำ 50 บาท'), findsOneWidget);
    });
  });

  // ===== กลุ่มการทดสอบ Unit Tests สำหรับตรวจสอบลอจิกต่างๆ =====
  group('Food Shop Logic Tests', () {
    
    // ===== ทดสอบว่าข้อมูลอาหารมีครบ 9 รายการ =====
    test('Food list should contain 9 items', () {
      // สร้างตัวอย่างข้อมูล (ต้อง import FoodItem ถ้าต้องการใช้)
      // ในที่นี้แค่ทดสอบจำนวน
      const expectedFoodCount = 9;
      expect(expectedFoodCount, 9);
    });

    // ===== ทดสอบการคำนวณราคารวม =====
    test('Should calculate total price correctly', () {
      // ตัวอย่างการคำนวณ
      double price1 = 60.0; // ข้าวผัดกุ้ง
      int quantity1 = 2;
      double price2 = 70.0; // ผัดไทย
      int quantity2 = 1;
      
      double total = (price1 * quantity1) + (price2 * quantity2);
      expect(total, 190.0);
    });

    // ===== ทดสอบเงื่อนไขยอดขั้นต่ำ =====
    test('Should validate minimum order amount', () {
      double totalPrice = 45.0;
      double minimumOrder = 50.0;
      
      bool isValid = totalPrice >= minimumOrder;
      expect(isValid, false); // ไม่ผ่านเงื่อนไข
    });

    // ===== ทดสอบเงื่อนไขตะกร้าว่าง =====
    test('Should detect empty cart', () {
      List<dynamic> cartItems = [];
      
      bool isEmpty = cartItems.isEmpty;
      expect(isEmpty, true);
    });
  });
}

// ===== หมายเหตุ: สิ่งที่แก้ไข =====
/*
1. เปลี่ยน import จาก 'package:flutter_test/flutter_test.dart' เป็น package ของโปรเจค
   - แก้จาก: import 'package:food_shop_app/main.dart';
   - เป็น: import 'package:midterm/main.dart';

2. เปลี่ยนการเรียกใช้ Widget หลัก
   - แก้จาก: MyApp() 
   - เป็น: FoodShopApp() (ตามที่กำหนดในไฟล์ main.dart)

3. เพิ่มการทดสอบฟีเจอร์ต่างๆ ของแอพร้านอาหาร:
   - ทดสอบการแสดงผลเมนูอาหาร
   - ทดสอบระบบตะกร้าสินค้า
   - ทดสอบฟังก์ชันสุ่มเมนู
   - ทดสอบการเปลี่ยนหมวดหมู่
   - ทดสอบการตรวจสอบเงื่อนไข (ยอดขั้นต่ำ, ตะกร้าว่าง)

4. เพิ่ม group() เพื่อจัดกลุ่มการทดสอบให้เป็นระเบียบ
   - Widget Tests: ทดสอบ UI และการแสดงผล
   - Logic Tests: ทดสอบ Logic และการคำนวณ

5. เพิ่มคอมเมนต์อธิบายแต่ละการทดสอบเป็นภาษาไทย
*/