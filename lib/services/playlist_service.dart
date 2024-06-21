import 'package:sqflite_common/sqflite.dart';  // Ubah ini
import 'package:path/path.dart';

class PlaylistService {
  static final PlaylistService _instance = PlaylistService._internal();
  factory PlaylistService() => _instance;

  static Database? _database;

  PlaylistService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'playlist.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE playlist (
        id INTEGER PRIMARY KEY,
        name TEXT
      )
    ''');
  }

  insertPlaylist(Map<String, String> playlist) {}

  getSongs(int playlistId) {}

  getPlaylists() {}

  insertSong(Map<String, Object?> map) {}

  deletePlaylist(playlist) {}
}
