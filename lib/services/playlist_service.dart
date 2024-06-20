import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PlaylistService {
  static final PlaylistService _instance = PlaylistService._internal();
  factory PlaylistService() => _instance;

  PlaylistService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'playlist.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE playlists (
        id INTEGER PRIMARY KEY,
        name TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE songs (
        id INTEGER PRIMARY KEY,
        playlistId INTEGER,
        title TEXT,
        path TEXT,
        FOREIGN KEY (playlistId) REFERENCES playlists (id)
      )
    ''');
  }

  Future<void> insertPlaylist(Map<String, dynamic> playlist) async {
    final db = await database;
    await db.insert('playlists', playlist, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getPlaylists() async {
    final db = await database;
    return await db.query('playlists');
  }

  Future<void> insertSong(Map<String, dynamic> song) async {
    final db = await database;
    await db.insert('songs', song, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getSongs(int playlistId) async {
    final db = await database;
    return await db.query('songs', where: 'playlistId = ?', whereArgs: [playlistId]);
  }
}
