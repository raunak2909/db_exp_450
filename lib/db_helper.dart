import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{
  ///private constructor
  /// Step 1
  DbHelper._();
  static DbHelper getInstance() => DbHelper._();

  /// Step2
  Database? mDB;
  static const String db_name = "notedDB.db";

  Future<Database> initDB() async{
    mDB ??= await openDB();

    return mDB!;
  }

  Future<Database> openDB() async{
    Directory appDir = await getApplicationDocumentsDirectory();
    /// data/data/com.facebook.katana/databases/userDB.db
    String dbPath = join(appDir.path, db_name);

    return await openDatabase(dbPath, version: 1, onCreate: (db, version){
      /// Step 3
      ///create tables


    });

  }

  /// Step 4
  /// Queries (CRUD select, insert, update, delete)



}