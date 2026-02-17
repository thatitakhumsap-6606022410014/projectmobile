import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'user.dart';

class DatabaseHelper {
  DatabaseHelper._instance();
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tbUsers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        pwd TEXT,
        weight REAL,
        height REAL,
        bmi REAL,
        bmi_type TEXT
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await instance.db;
    return await db.query('tbUsers');
  }

  Future<List<User>> getUsers() async {
    List<Map<String, dynamic>> usersMap = await queryAllUsers();
    return usersMap.map((map) => User.fromMap(map)).toList();
  }

  Future<void> updateAllbmi() async {
    Database db = await instance.db;
    List<User> users = await getUsers();

    for (User user in users) {
      double bmi = User.calculateBmi(user.weight, user.height);
      String bmiType = User.determineBmiType(bmi);

      await db.update(
        'tbUsers',
        {'bmi': bmi, 'bmi_type': bmiType},
        where: 'id = ?',
        whereArgs: [user.id],
      );
    }
  }

  Future<void> updateAllTargetWeights() async {
    Database db = await instance.db;
    List<User> users = await getUsers();

    for (User user in users) {
      double targetWeight = User.calculateTargetWeight(
        user.weight,
        user.height,
      );

      await db.update(
        'tbUsers',
        {'target_weight': targetWeight},
        where: 'id = ?',
        whereArgs: [user.id],
      );
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE tbUsers ADD COLUMN bmi REAL');
      await db.execute('ALTER TABLE tbUsers ADD COLUMN bmi_type TEXT');
      await updateAllbmi();
    }
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE tbUsers ADD COLUMN name TEXT');
      await db.execute(
        'UPDATE tbUsers SET name = username WHERE name IS NULL OR name = ""',
      );
    }
    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE tbUsers_new(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT,
          pwd TEXT,
          weight REAL,
          height REAL,
          bmi REAL,
          bmi_type TEXT,
          target_weight REAL
        )
      ''');
      await db.execute(
        'INSERT INTO tbUsers_new (id, name, email, pwd, weight, height, bmi, bmi_type) SELECT id, name, email, pwd, weight, height, bmi, bmi_type FROM tbUsers',
      );
      await db.execute('DROP TABLE tbUsers');
      await db.execute('ALTER TABLE tbUsers_new RENAME TO tbUsers');
      await updateAllTargetWeights();
    }
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'appDBbmi2.db');

    return await openDatabase(
      path,
      version: 5,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<int> insertUser(User user) async {
    Database db = await instance.db;
    return await db.insert('tbUsers', user.toMap());
  }

  Future<int> updateUser(User user) async {
    Database db = await instance.db;
    return await db.update(
      'tbUsers',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    Database db = await instance.db;
    return await db.delete('tbUsers', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllUsers() async {
    Database db = await instance.db;
    await db.delete('tbUsers');
  }

  Future<void> updateAllBmi() async {
    Database db = await instance.db;
    List<User> users = await getUsers();

    for (User user in users) {
      double bmi = User.calculateBmi(user.weight, user.height);
      String bmiType = User.determineBmiType(bmi);

      await db.update(
        'tbUsers',
        {'bmi': bmi, 'bmi_type': bmiType},
        where: 'id = ?',
        whereArgs: [user.id],
      );
    }
  }

  Future<void> initializeUsers() async {
    List<User> usersToAdd = [
      // User(
      //   name: 'John',
      //   email: 'john@example.com',
      //   pwd: '9999',
      //   weight: 80,
      //   height: 170,
      // ),
      // User(
      //   name: 'Jane',
      //   email: 'jane@example.com',
      //   pwd: '1234',
      //   weight: 55,
      //   height: 160,
      // ),
    ];

    for (User user in usersToAdd) {
      await insertUser(user);
    }
  }
}
