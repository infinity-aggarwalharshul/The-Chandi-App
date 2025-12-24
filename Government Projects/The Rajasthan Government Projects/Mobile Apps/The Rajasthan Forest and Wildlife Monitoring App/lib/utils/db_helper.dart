import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  static final _dbName = "van_rakshak_secure.db";
  static final _dbVersion = 1;
  static final _tableName = "offense_logs";

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        encrypted_notes TEXT NOT NULL,
        has_voice INTEGER NOT NULL,
        has_image INTEGER NOT NULL,
        timestamp TEXT NOT NULL,
        synced INTEGER NOT NULL,
        encrypted_image_path TEXT,
        encrypted_audio_path TEXT
      )
    ''');
  }

  Future<int> insertLog(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllLogs() async {
    Database db = await database;
    return await db.query(_tableName, orderBy: "timestamp DESC");
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await database;
    String id = row['id'];
    return await db.update(_tableName, row, where: 'id = ?', whereArgs: [id]);
  }
}
