import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  ///private constructor
  /// Step 1
  DbHelper._();

  static DbHelper getInstance() => DbHelper._();

  /// Step2
  Database? mDB;
  static const String db_name = "notedDB.db";
  static const String table_note = "notes";
  static const String column_note_id = "note_id";
  static const String column_note_title = "note_title";
  static const String column_note_desc = "note_desc";
  static const String column_note_created_at = "note_created_at";

  Future<Database> initDB() async {
    mDB ??= await openDB();

    return mDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();

    /// data/data/com.facebook.katana/databases/documents/userDB.db
    String dbPath = join(appDir.path, db_name);

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        /// Step 3
        ///create tables
        ///id int (primary key) autoincrement
        ///title String
        ///desc String
        ///createdAt String (milliseconds)

        db.execute(
          "create table $table_note ( $column_note_id integer primary key autoincrement, $column_note_title text, $column_note_desc text, $column_note_created_at text)",
        );

        /// all the tables are created
      },
    );
  }

  /// Step 4
  /// Queries (CRUD select, insert, update, delete)
  Future<bool> addNote({required String title, required String desc}) async {
    String currTimeMillis = DateTime.now().millisecondsSinceEpoch.toString();

    Database db = await initDB();
    int rowsEffected = await db.insert(table_note, {
      column_note_title: title,
      column_note_desc: desc,
      column_note_created_at: currTimeMillis,
    });

    return rowsEffected > 0;
  }

   Future<List<Map<String, dynamic>>> fetchAllNotes() async {
    var db = await initDB();

    List<Map<String, dynamic>> allNotes = await db.query(table_note);

    return allNotes;
  }
  /// update
  /// delete
}
