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
    await deleteDatabase(path); // Ini code agar setiap inisiasi project database akan dihapus, penting agar data tidak menumpuk saat tahap development
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tabel Film Utama
      await db.execute('''
        CREATE TABLE films (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          genre TEXT,
          rating REAL,
          videoUrl TEXT
        )
      ''');
        //Tabel History
      await db.execute('''
        CREATE TABLE history (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          genre TEXT,
          rating REAL,
          watchedAt TEXT,
          videoUrl TEXT
        )
      ''');
        //Tabel Downloads
      await db.execute('''
        CREATE TABLE downloads (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          genre TEXT,
          rating REAL,
          downloadedAt TEXT,
          videoUrl TEXT
        )
      ''');
      },
    );
  }

  // ====================
  // CRUD FILM
  // ====================

// INSERT FILM
Future<void> insertFilm(Film film) async {
  final db = await database;
  await db.insert(
    'films',
    film.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// GET SEMUA FILM
Future<List<Film>> getFilms() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('films');
  return List.generate(maps.length, (i) {
    return Film(
      id: maps[i]['id'],
      title: maps[i]['title'],
      genre: maps[i]['genre'],
      rating: maps[i]['rating'],
      videoUrl: maps[i]['videoUrl'], // ambil videoUrl
    );
  });
}

// GET FILM BY GENRE
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
      videoUrl: maps[i]['videoUrl'], // ambil videoUrl
    );
  });
}

// UPDATE FILM
Future<void> updateFilm(Film film) async {
  final db = await database;
  await db.update(
    'films',
    film.toMap(),
    where: 'id = ?',
    whereArgs: [film.id],
  );
}

// DELETE FILM
Future<void> deleteFilm(int id) async {
  final db = await database;
  await db.delete(
    'films',
    where: 'id = ?',
    whereArgs: [id],
  );
}


  // ====================
  // HISTORY TONTON
  // ====================

//Create
  Future<void> insertHistory(Film film) async {
    final db = await database;

    // Cek apakah sudah pernah ditonton berdasarkan videoUrl
    final existing = await db.query(
      'history',
      where: 'videoUrl = ?',
      whereArgs: [film.videoUrl],
    );

    if (existing.isEmpty) {
      await db.insert('history', {
        'title': film.title,
        'genre': film.genre,
        'rating': film.rating,
        'videoUrl': film.videoUrl,
        'watchedAt': DateTime.now().toIso8601String(),
      });
    }
  }

//Read
Future<List<Film>> getHistory() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('history');
  return List.generate(maps.length, (i) {
    return Film(
      id: maps[i]['id'],
      title: maps[i]['title'],
      genre: maps[i]['genre'],
      rating: maps[i]['rating'],
      videoUrl: maps[i]['videoUrl'], // tambahkan ini
    );
  });
}




  // ====================
  // DAFTAR DOWNLOAD
  // ====================

//Create
Future<void> insertDownload(Film film) async {
  final db = await database;
  await db.insert('downloads', {
    'title': film.title,
    'genre': film.genre,
    'rating': film.rating,
    'downloadedAt': DateTime.now().toIso8601String(),
  });
}

//Delete
Future<void> deleteDownload(int id) async {
  final db = await database;
  await db.delete('downloads', where: 'id = ?', whereArgs: [id]);
}

//Read
Future<List<Film>> getDownloads() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('downloads');
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