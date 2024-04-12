import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'quotes.db';
  static const _databaseVersion = 1;

  static Database? _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), _databaseName),
        version: _databaseVersion);
  }

  // Future<void> _onCreate(Database db, int version) async {
  //   await db.execute('''
  // CREATE TABLE default_quotes (
  //   id INTEGER PRIMARY KEY AUTOINCREMENT,
  //     quote_content TEXT,
  //     author_name TEXT,
  //     author_id INTEGER,
  //     category_id INTEGER,
  //     created_at TEXT
  // );
  //   ''');

  //   await db.execute('''
  // CREATE TABLE user_quotes (
  //     id INTEGER PRIMARY KEY AUTOINCREMENT,
  //     quote_content TEXT,
  //     author_name TEXT,
  //     category_id INTEGER,
  //     created_at TEXT
  //     updated_at TEXT
  // );
  //   ''');

  //   await db.execute('''
  // CREATE TABLE categories (
  //   id INTEGER PRIMARY KEY AUTOINCREMENT,
  //   category_name TEXT,
  //   created_at TEXT
  // )
  //   ''');

  //   await db.execute('''
  // CREATE TABLE likes (
  //   id INTEGER PRIMARY KEY AUTOINCREMENT,
  //   quote_id INTEGER NOT NULL,
  //   quote_source TEXT NOT NULL,
  //   created_at TEXT
  // )
  //   ''');
  //   //quote source: default, user

  //   //create user collection table for saving quotes
  //   // include collection id, collection name, created_at, updated_at
  //   await db.execute('''
  // CREATE TABLE user_collections (
  //   id INTEGER PRIMARY KEY AUTOINCREMENT,
  //   collection_name TEXT,
  //   created_at TEXT,
  //   updated_at TEXT
  // )
  //   ''');

  //   //create save table
  //   // to save quotes into collection

  //   await db.execute('''
  // CREATE TABLE saves (
  //   id INTEGER PRIMARY KEY AUTOINCREMENT,
  //   quote_id INTEGER NOT NULL,
  //   quote_source TEXT NOT NULL,
  //   collection_id INTEGER NOT NULL,
  //   created_at TEXT
  // )
  //   ''');
  // }
}
