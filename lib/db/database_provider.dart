import 'package:notes_lite/models/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();
  static Database? _database;


  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), "notes.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE notes ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "title TEXT,"
          "body TEXT,"
          "createdAt TEXT"
          ")");
    });
  }

  addNewNote(NoteModel note) async {
    final db = await database;
    db.insert("notes", note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<NoteModel>> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("notes");
    return List.generate(maps.length, (i) {
      return NoteModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        body: maps[i]['body'],
        createdAt: maps[i]['createdAt'],
      );
    });
  }


  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete("notes", where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateNote(NoteModel note) async {
    final db = await database;
    return db.update("notes", note.toMap(),
        where: "id = ?", whereArgs: [note.id]);
  }

  Future<int> deleteAllNotes() async {
    final db = await database;
    return db.delete("notes");
  }

}