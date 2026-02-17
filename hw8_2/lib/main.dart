import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDb();
  await DatabaseHelper.instance.initializeUsers();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Management',
      home: UserList(),
    );
  }
}

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> _users = [];

  Future<void> _fetchUsers() async {
    final userMaps = await DatabaseHelper.instance.queryAllUsers();
    setState(() {
      _users = userMaps.map((map) => User.fromMap(map)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _deleteUser(int userId) async {
    await DatabaseHelper.instance.deleteUser(userId);
    _fetchUsers();
  }

  void _editUser(User user) {
    TextEditingController nameController = TextEditingController(
      text: user.name,
    );
    TextEditingController emailController = TextEditingController(
      text: user.email,
    );
    TextEditingController pwdController = TextEditingController(text: user.pwd);
    TextEditingController weightController = TextEditingController(
      text: user.weight.toString(),
    );
    TextEditingController heightController = TextEditingController(
      text: user.height.toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit User'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: pwdController,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: heightController,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final double weight = double.parse(weightController.text);
                final double height = double.parse(heightController.text);

                final updatedUser = User(
                  id: user.id,
                  name: nameController.text,
                  email: emailController.text,
                  pwd: pwdController.text,
                  weight: weight,
                  height: height,
                );

                DatabaseHelper.instance.updateUser(updatedUser).then((value) {
                  _fetchUsers();
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addUser() {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController pwdController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    TextEditingController heightController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New User'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: pwdController,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: heightController,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final double weight = double.parse(weightController.text);
                final double height = double.parse(heightController.text);

                final newUser = User(
                  name: nameController.text,
                  email: emailController.text,
                  pwd: pwdController.text,
                  weight: weight,
                  height: height,
                );
                DatabaseHelper.instance.insertUser(newUser).then((value) {
                  _fetchUsers();
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAllUsers() async {
    await DatabaseHelper.instance.deleteAllUsers();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show User List'),
        backgroundColor: const Color.fromARGB(255, 6, 207, 252),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _deleteAllUsers,
            color: Colors.red,
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final user = _users[index];
          final minWeight = 18.5 * ((user.height / 100) * (user.height / 100));
          final maxWeight = 24.9 * ((user.height / 100) * (user.height / 100));
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: IntrinsicHeight(
                // ทำให้ Row สูงเท่ากัน
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// รูปด้านซ้าย
                    SizedBox(
                      width: 80,
                      child: Image.asset(
                        user.bmiType == 'Underweight'
                            ? 'assets/images/bmi-1.png'
                            : user.bmiType == 'Normal'
                            ? 'assets/images/bmi-2.png'
                            : user.bmiType == 'Overweight'
                            ? 'assets/images/bmi-3.png'
                            : 'assets/images/bmi-4.png',
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// ข้อมูล
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('Email: ${user.email}'),
                          Text('Weight: ${user.weight} kg'),
                          Text('Height: ${user.height} cm'),
                          Text(
                            'BMI: ${user.bmi.toStringAsFixed(2)} (${user.bmiType})',
                          ),
                          if (user.bmiType == 'Normal') ...[
                            const SizedBox(height: 30),
                            // centered green italic text
                            Text(
                              'Great job! Keep maintaining your healthy lifestyle.',
                              style: const TextStyle(color: Colors.green),
                              textAlign: TextAlign.center,
                            ),
                          ] else ...[
                            SizedBox(height: 30),
                            Column(
                              children: [
                                Text(
                                  'Normal weight range this height',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${minWeight.toStringAsFixed(1)} kg - ${maxWeight.toStringAsFixed(1)} kg',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  user.bmiType == 'Underweight'
                                      ? 'You should gain ${(minWeight - user.weight).toStringAsFixed(1)} kg.'
                                      : 'You should lose ${(user.weight - maxWeight).toStringAsFixed(1)} kg.',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    /// ปุ่มด้านขวา
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editUser(user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteUser(user.id!),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: _users.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        backgroundColor: const Color.fromARGB(255, 7, 174, 221),
        child: const Icon(Icons.add),
      ),
    );
  }
}
