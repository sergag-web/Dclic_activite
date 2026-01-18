import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../modele/redacteur.dart';

class DatabaseManager {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  // Initialisation
  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'redacteurs.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE redacteurs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT,
            prenom TEXT,
            email TEXT
          )
        ''');
      },
    );
  }

  // INSERT
  Future<int> insertRedacteur(Redacteur redacteur) async {
    final db = await database;
    return db.insert('redacteurs', redacteur.toMap());
  }

  // READ
  Future<List<Redacteur>> getAllRedacteurs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('redacteurs');

    return maps.map((e) => Redacteur.fromMap(e)).toList();
  }

  // UPDATE
  Future<int> updateRedacteur(Redacteur redacteur) async {
    final db = await database;
    return db.update(
      'redacteurs',
      redacteur.toMap(),
      where: 'id = ?',
      whereArgs: [redacteur.id],
    );
  }

  // DELETE
  Future<int> deleteRedacteur(int id) async {
    final db = await database;
    return db.delete(
      'redacteurs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
