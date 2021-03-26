import 'dart:async';
import 'dart:io';

import 'package:flutter_persist_data_locally/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteHelper {
  final String colId = 'id';
  final String colName = 'name';
  final String colDate = 'date';
  final String colNote = 'note';
  final String colPosition = 'position';
  final String tableNotes = 'notes';

  static Database _db;
  final int version = 1;
  static SqliteHelper _singleton = SqliteHelper._internal();

  factory SqliteHelper() {
    return _singleton;
  }

  SqliteHelper._internal(); // private named constructor

  Future<Database> init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, "notes.db");
    Database dbNotes =
        await openDatabase(dbPath, version: version, onCreate: _createDb);
    return dbNotes;
  }

  Future _createDb(Database db, int version) async {
    String query = 'CREATE TABLE $tableNotes ($colId INTEGER PRIMARY KEY, ' +
        '$colName TEXT, $colDate TEXT, $colNote TEXT, $colPosition INTEGER)';
    await _db.execute(query);
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
