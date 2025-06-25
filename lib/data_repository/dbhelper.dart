import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/film_model.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'film_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE films (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            genre TEXT,
            rating REAL
          )
        ''');
      },
    );
  }

  Future<void> insertFilm(Film film) async {
    final db = await database;
    await db.insert('films', film.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Film>> getFilms() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('films');
    return List.generate(maps.length, (i) {
      return Film(
        id: maps[i]['id'],
        title: maps[i]['title'],
        genre: maps[i]['genre'],
        rating: maps[i]['rating'],
      );
    });
  }

  // ✅ Tambahkan ini untuk filter genre
  Future<List<Film>> getFilmsByGenre(String genre) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('films', where: 'genre = ?', whereArgs: [genre]);

    return List.generate(maps.length, (i) {
      return Film(
        id: maps[i]['id'],
        title: maps[i]['title'],
        genre: maps[i]['genre'],
        rating: maps[i]['rating'],
      );
    });
  }
}
