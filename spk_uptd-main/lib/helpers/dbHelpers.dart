import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'psbghi_database.db');
    print(databasesPath.toString());
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
        'CREATE TABLE user (id INTEGER PRIMARY KEY, username TEXT, email TEXT, password TEXT, akses TEXT, tgl_lahir TEXT, alamat TEXT, jabatan TEXT, telepon TEXT, foto TEXT, isActive INTEGER)');
    await db.execute(
        'CREATE TABLE client (id INTEGER PRIMARY KEY, nama_client TEXT, jenis_kelamin_client TEXT, umur_client TEXT, klasifikasi_kecacatan_client TEXT, tanggal_lahir_client TEXT, tanggal_masuk_client TEXT, nilai_raport TEXT)');
    // await db.execute(
    //     'CREATE TABLE profil (id INTEGER PRIMARY KEY, nama TEXT, tgl_lahir TEXT, alamat TEXT, jabatan TEXT, telepon TEXT, foto TEXT, user INTEGER)');
  }

  Future<int> insertData(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('user', data);
  }

  Future<void> updateData(Map<String, dynamic> newData, int id) async {
    final Database db = await database;
    await db.update(
      'user', // Replace with your table name
      newData,
      where: 'id = ?', // Replace with your condition
      whereArgs: [id], // Replace with your condition arguments
    );
  }

  Future<void> deleteUser(int id) async {
    final Database db = await database;
    await db.delete(
      'user',
      where: 'id = ?', // Replace with your condition
      whereArgs: [id], // Replace with your condition arguments
    );
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final db = await database;
    return await db.query('user');
  }

  Future<int> insertDataClient(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('client', data);
  }

  Future<List<Map<String, dynamic>>> fetchDataClient() async {
    final db = await database;
    return await db.query('client');
  }

  Future<void> updateDataClient(Map<String, dynamic> newData, int id) async {
    final Database db = await database;
    await db.update(
      'client', // Replace with your table name
      newData,
      where: 'id = ?', // Replace with your condition
      whereArgs: [id], // Replace with your condition arguments
    );
  }

  Future<void> deleteDataClient(int id) async {
    final Database db = await database;
    await db.delete(
      'client',
      where: 'id = ?', // Replace with your condition
      whereArgs: [id], // Replace with your condition arguments
    );
  }

  // Future<int> insertDataProfil(Map<String, dynamic> data) async {
  //   final db = await database;
  //   return await db.insert('profil', data);
  // }

  // Future<List<Map<String, dynamic>>> fetchDataProfil() async {
  //   final db = await database;
  //   return await db.query('profil');
  // }
}
