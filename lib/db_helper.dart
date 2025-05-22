// TODO Implement this library.
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'gym_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE members(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            price REAL
          )
        ''');
      },
    );
  }

  // Member CRUD
  static Future<int> insertMember(Map<String, dynamic> member) async {
    final dbClient = await db;
    return await dbClient.insert('members', member);
  }

  static Future<List<Map<String, dynamic>>> getMembers() async {
    final dbClient = await db;
    return await dbClient.query('members');
  }

  static Future<int> updateMember(Map<String, dynamic> member) async {
    final dbClient = await db;
    return await dbClient.update('members', member, where: 'id=?', whereArgs: [member['id']]);
  }

  static Future<int> deleteMember(int id) async {
    final dbClient = await db;
    return await dbClient.delete('members', where: 'id=?', whereArgs: [id]);
  }

  // Product CRUD
  static Future<int> insertProduct(Map<String, dynamic> product) async {
    final dbClient = await db;
    return await dbClient.insert('products', product);
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final dbClient = await db;
    return await dbClient.query('products');
  }

  static Future<int> updateProduct(Map<String, dynamic> product) async {
    final dbClient = await db;
    return await dbClient.update('products', product, where: 'id=?', whereArgs: [product['id']]);
  }

  static Future<int> deleteProduct(int id) async {
    final dbClient = await db;
    return await dbClient.delete('products', where: 'id=?', whereArgs: [id]);
  }
}