// ignore_for_file: prefer_const_declarations

import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';

class DataBaseHelper {
  static final _dbName = "rununudb.db";
  static final _dbVersion = 1;

  // Key Table Details
  static final keyTableName = "keyTable";
  static final columnKeyId = "_id";
  static final columnKeyKeyId = "keyid";
  static final columnKey32BitKeyMain = "_32bitkeymain";
  static final columnKey32BitKeyRand = "_32bitkeyrand";
  static final columnKeyLocationName = "locationname";
  static final columnKeyLocationDescription = "locationdescription";
  static final columnKeyOnCreateDate = "oncreatedate";
  static final columnKeyLastView = "lastview";

  // User Table Details
  static final userTableName = "userTable";
  static final columnUserId = "_id";
  static final columnUserName = "name";
  static final columnUserEmail = "email";
  static final columnUserIdNumber = "id_number";
  static final columnUserHasPass = "has_pass";
  static final columnUserPass = "pass";
  static final columnUserTheme = "theme_mode";

  // Make this a singleton class
  DataBaseHelper._privateConstractor();
  static final DataBaseHelper instance = DataBaseHelper._privateConstractor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    log("Database Path: $path");
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $keyTableName (
            $columnKeyId INTEGER PRIMARY KEY,
            $columnKeyKeyId TEXT NOT NULL,
            $columnKey32BitKeyMain TEXT NOT NULL,
            $columnKey32BitKeyRand TEXT NOT NULL,
            $columnKeyLocationName TEXT NOT NULL,
            $columnKeyLocationDescription TEXT NOT NULL,
            $columnKeyOnCreateDate TEXT NOT NULL,
            $columnKeyLastView TEXT NOT NULL
          );

          CREATE TABLE $userTableName (
            $columnUserId INTEGER PRIMARY KEY,
            $columnUserName TEXT NOT NULL,
            $columnUserEmail TEXT NOT NULL,
            $columnUserIdNumber TEXT NOT NULL,
            $columnUserHasPass TEXT NOT NULL,
            $columnUserPass TEXT NOT NULL,
            $columnUserTheme TEXT NOT NULL
          )
          ''');
  }

  // HELPER FUNCTIONS\METHODS
  // Querry All Keys
  Future<int?> queryKeyCount() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM $keyTableName'));
  }

  // All of the rows are returned as a list of maps, where each map is a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllKeys() async {
    Database? db = await instance.database;
    return await db!.query(keyTableName);
  }

  Future<int> insertKey(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(keyTableName, row);
  }
}
