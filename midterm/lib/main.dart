import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const FoodShopApp());
}

// ===== Widget หลักของแอพพลิเคชัน =====
class FoodShopApp extends StatelessWidget {
  const FoodShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ร้านอาหาร',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const FoodShopHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ===== โมเดลข้อมูลอาหาร =====
class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imagePath;
  final String category;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.category,
  });
}

// ===== โมเดลสินค้าในตะกร้า =====
class CartItem {
  final FoodItem food;
  int quantity;

  CartItem({
    required this.food,
    this.quantity = 1,
  });

  // ฟังก์ชันคำนวณราคารวมของสินค้าในตะกร้า
  double get totalPrice => food.price * quantity;
}

// ===== หน้าหลักของร้านอาหาร =====
class FoodShopHomePage extends StatefulWidget {
  const FoodShopHomePage({super.key});

  @override
  State<FoodShopHomePage> createState() => _FoodShopHomePageState();
}

class _FoodShopHomePageState extends State<FoodShopHomePage> {
  // ===== ตัวแปรเก็บข้อมูล =====
  List<CartItem> cartItems = []; // เก็บสินค้าในตะกร้า
  String selectedCategory = 'ทั้งหมด'; // หมวดหมู่ที่เลือก
  final Random random = Random(); // ตัวสุ่มสำหรับฟังก์ชัน Random

  // ===== ข้อมูลเมนูอาหารทั้งหมด =====
  final List<FoodItem> allFoods = [
    // อาหารจานหลัก
    FoodItem(
      id: '1',
      name: 'ข้าวผัดกุ้ง',
      description: 'ข้าวผัดกุ้งสดใหม่ รสชาติเข้มข้น',
      price: 60.0,
      imagePath: 'assets/imgs/m1.jpg',
      category: 'อาหารจานหลัก',
    ),
    FoodItem(
      id: '2',
      name: 'ผัดไทยกุ้งสด',
      description: 'ผัดไทยรสชาติต้นตำรับ',
      price: 70.0,
      imagePath: 'assets/imgs/pad_thai.jpg',
      category: 'อาหารจานหลัก',
    ),
    FoodItem(
      id: '3',
      name: 'ต้มยำกุ้ง',
      description: 'ต้มยำกุ้งรสจัดจ้าน',
      price: 120.0,
      imagePath: 'assets/imgs/tom_yum.jpg',
      category: 'อาหารจานหลัก',
    ),
    FoodItem(
      id: '4',
      name: 'ส้มตำไทย',
      description: 'ส้มตำรสชาติแซ่บ',
      price: 50.0,
      imagePath: 'assets/imgs/som_tam.jpg',
      category: 'อาหารจานหลัก',
    ),
    
    // เครื่องดื่ม
    FoodItem(
      id: '5',
      name: 'ชาเย็น',
      description: 'ชาเย็นหอมกรุ่น',
      price: 25.0,
      imagePath: 'assets/imgs/thai_tea.jpg',
      category: 'เครื่องดื่ม',
    ),
    FoodItem(
      id: '6',
      name: 'น้ำมะพร้าว',
      description: 'น้ำมะพร้าวสดชื่นใจ',
      price: 30.0,
      imagePath: 'assets/imgs/coconut_water.jpg',
      category: 'เครื่องดื่ม',
    ),
    FoodItem(
      id: '7',
      name: 'กาแฟเย็น',
      description: 'กาแฟเย็นหอมกรุ่น',
      price: 35.0,
      imagePath: 'assets/imgs/iced_coffee.jpg',
      category: 'เครื่องดื่ม',
    ),
    
    // ของหวาน
    FoodItem(
      id: '8',
      name: 'ข้าวเหนียวมะม่วง',
      description: 'ของหวานไทยโบราณ',
      price: 60.0,
      imagePath: 'assets/imgs/mango_sticky_rice.jpg',
      category: 'ของหวาน',
    ),
    FoodItem(
      id: '9',
      name: 'บัวลอย',
      description: 'บัวลอยน้ำกะทิหอมหวาน',
      price: 40.0,
      imagePath: 'assets/imgs/bua_loy.jpg',
      category: 'ของหวาน',
    ),
  ];

  // ===== ฟังก์ชันดึงรายการหมวดหมู่ทั้งหมด =====
  List<String> get categories {
    Set<String> cats = {'ทั้งหมด'};
    for (var food in allFoods) {
      cats.add(food.category);
    }
    return cats.toList();
  }

  // ===== ฟังก์ชันกรองอาหารตามหมวดหมู่ =====
  List<FoodItem> get filteredFoods {
    if (selectedCategory == 'ทั้งหมด') {
      return allFoods;
    }
    return allFoods.where((food) => food.category == selectedCategory).toList();
  }

  // ===== ฟังก์ชันเพิ่มสินค้าในตะกร้า =====
  void addToCart(FoodItem food) {
    setState(() {
      // ตรวจสอบว่ามีสินค้านี้ในตะกร้าแล้วหรือไม่
      var existingItem = cartItems.firstWhere(
        (item) => item.food.id == food.id,
        orElse: () => CartItem(food: food, quantity: 0),
      );

      if (existingItem.quantity > 0) {
        // ถ้ามีแล้วให้เพิ่มจำนวน
        existingItem.quantity++;
      } else {
        // ถ้ายังไม่มีให้เพิ่มรายการใหม่
        cartItems.add(CartItem(food: food));
      }
    });

    // แสดง Snackbar แจ้งเตือน
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เพิ่ม ${food.name} ลงตะกร้าแล้ว'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }

  // ===== ฟังก์ชันลบสินค้าออกจากตะกร้า =====
  void removeFromCart(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  // ===== ฟังก์ชันเพิ่มจำนวนสินค้าในตะกร้า =====
  void increaseQuantity(int index) {
    setState(() {
      cartItems[index].quantity++;
    });
  }

  // ===== ฟังก์ชันลดจำนวนสินค้าในตะกร้า =====
  void decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      } else {
        // ถ้าจำนวนเป็น 1 และลดอีกให้ลบออกจากตะกร้า
        removeFromCart(index);
      }
    });
  }

  // ===== ฟังก์ชันคำนวณราคารวมทั้งหมด =====
  double get totalPrice {
    double total = 0;
    for (var item in cartItems) {
      total += item.totalPrice;
    }
    return total;
  }

  // ===== ฟังก์ชันนับจำนวนสินค้าทั้งหมดในตะกร้า =====
  int get totalItems {
    int count = 0;
    for (var item in cartItems) {
      count += item.quantity;
    }
    return count;
  }

  // ===== ฟังก์ชัน Random เมนูอาหาร =====
  void randomFood() {
    if (filteredFoods.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ไม่มีเมนูในหมวดหมู่นี้'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // สุ่มเลือกอาหารจากรายการที่กรองแล้ว
    final randomIndex = random.nextInt(filteredFoods.length);
    final selectedFood = filteredFoods[randomIndex];

    // เพิ่มลงตะกร้า
    addToCart(selectedFood);

    // แสดง Dialog แจ้งเมนูที่สุ่มได้
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎲 สุ่มเมนูให้คุณ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                selectedFood.imagePath,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Icon(Icons.restaurant, size: 60),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              selectedFood.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(selectedFood.description),
            const SizedBox(height: 8),
            Text(
              '฿${selectedFood.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  // ===== ฟังก์ชันยืนยันการสั่งซื้อ =====
  void confirmOrder() {
    // ตรวจสอบว่ามีสินค้าในตะกร้าหรือไม่
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ กรุณาเลือกสินค้าก่อนสั่งซื้อ'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // ตรวจสอบราคารวมขั้นต่ำ (เช่น 50 บาท)
    if (totalPrice < 50) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('⚠️ แจ้งเตือน'),
          content: const Text('ยอดสั่งซื้อขั้นต่ำ 50 บาท'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ตกลง'),
            ),
          ],
        ),
      );
      return;
    }

    // แสดงข้อมูลการสั่งซื้อ
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('✅ ยืนยันการสั่งซื้อ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('รายการสินค้า:'),
            const SizedBox(height: 8),
            ...cartItems.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '${item.food.name} x${item.quantity} = ฿${item.totalPrice.toStringAsFixed(2)}',
              ),
            )),
            const Divider(),
            Text(
              'ยอดรวมทั้งหมด: ฿${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                cartItems.clear(); // ล้างตะกร้า
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ สั่งซื้อสำเร็จ! ขอบคุณที่ใช้บริการ'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('ยืนยันการสั่งซื้อ'),
          ),
        ],
      ),
    );
  }

  // ===== ฟังก์ชันแสดงตะกร้าสินค้า =====
  void showCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // หัวข้อตะกร้า
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '🛒 ตะกร้าสินค้า',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$totalItems รายการ',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              // รายการสินค้าในตะกร้า
              Expanded(
                child: cartItems.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_outlined,
                                size: 80, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'ตะกร้าว่างเปล่า',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  // รูปสินค้า
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      item.food.imagePath,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.restaurant),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  
                                  // ข้อมูลสินค้า
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.food.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '฿${item.food.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // ปุ่มควบคุมจำนวน
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle),
                                        color: Colors.red,
                                        onPressed: () {
                                          setState(() {
                                            decreaseQuantity(index);
                                          });
                                          Navigator.pop(context);
                                          showCart();
                                        },
                                      ),
                                      Text(
                                        '${item.quantity}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle),
                                        color: Colors.green,
                                        onPressed: () {
                                          setState(() {
                                            increaseQuantity(index);
                                          });
                                          Navigator.pop(context);
                                          showCart();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              
              // ส่วนสรุปราคาและปุ่มสั่งซื้อ
              if (cartItems.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ยอดรวมทั้งหมด:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '฿${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            confirmOrder();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'สั่งซื้อเลย',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍽️ ร้านอาหาร'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          // ปุ่มสุ่มเมนู
          IconButton(
            icon: const Icon(Icons.casino),
            tooltip: 'สุ่มเมนู',
            onPressed: randomFood,
          ),
          // ปุ่มตะกร้าสินค้า
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: showCart,
              ),
              if (totalItems > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '$totalItems',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // ส่วนเลือกหมวดหมู่
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    selectedColor: Colors.orange,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // รายการอาหาร
          Expanded(
            child: filteredFoods.isEmpty
                ? const Center(
                    child: Text('ไม่มีเมนูในหมวดหมู่นี้'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: filteredFoods.length,
                    itemBuilder: (context, index) {
                      final food = filteredFoods[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // รูปอาหาร
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.asset(
                                  food.imagePath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.restaurant,
                                        size: 50,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            
                            // ข้อมูลอาหาร
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    food.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    food.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '฿${food.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_shopping_cart),
                                        color: Colors.orange,
                                        iconSize: 20,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () => addToCart(food),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
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