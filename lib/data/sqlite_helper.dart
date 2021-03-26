import 'dart:async';
import 'dart:io';

import 'package:flutter_persist_data_locally/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteHelper {
  final String colId = 'id';
  final String colName = 'name';
  final String colDate = 'date';
  final String colNote = 'note';
  final String colPosition = 'position';
  final String tableNotes = 'notes';

  static Database _db;
  final int _version = 1;
  static SQLiteHelper _singleton = SQLiteHelper._internal();

  SQLiteHelper._internal(); // private named constructor

  factory SQLiteHelper() {
    return _singleton;
  }

  Future<Database> init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, "notes.db");
    return await openDatabase(dbPath, version: _version, onCreate: _createDb);
  }

  Future _createDb(Database db, int version) async {
    String query =
        'CREATE TABLE $tableNotes ($colId INTEGER PRIMARY KEY, $colName TEXT, $colDate TEXT, $colNote TEXT, $colPosition INTEGER)';
    await db.execute(query);
  }

  Future<List<Note>> getNotes() async {
    if (_db == null) {
      _db = await init();
    }

    List<Map<String, dynamic>> noteList =
        await _db.query(tableNotes, orderBy: colPosition);
    List<Note> notes = [];
    noteList.forEach((element) {
      notes.add(Note.fromMap(element));
    });
    return notes;
  }

  Future<int> insertNote(Note note) async {
    int result = await _db.insert(tableNotes, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    int result = await _db.update(tableNotes, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(Note note) async {
    int result =
        await _db.delete(tableNotes, where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }
}
