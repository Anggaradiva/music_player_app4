import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db_helper.dart';
import '../models/playlist.dart';
import '../theme_notifier.dart';
import 'music_player_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  DBHelper _dbHelper = DBHelper();
  List<Playlist> _playlists = [];

  @override
  void initState() {
    super.initState();
    _fetchPlaylists();
  }

  Future<void> _fetchPlaylists() async {
    _playlists = await _dbHelper.getPlaylists();
    setState(() {});
  }

  Future<void> _createPlaylist() async {
    String? name = await _showCreatePlaylistDialog();
    if (name != null && name.isNotEmpty) {
      List<File> songs = await _pickSongs();
      if (songs.isNotEmpty) {
        Playlist playlist = Playlist(name: name, songs: songs);
        await _dbHelper.insertPlaylist(playlist);
        _fetchPlaylists();
      }
    }
  }

  Future<String?> _showCreatePlaylistDialog() {
    TextEditingController _controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Playlist'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Playlist Name'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () {
                Navigator.of(context).pop(_controller.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future<List<File>> _pickSongs() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.audio);
    if (result != null) {
      return result.paths.map((path) => File(path!)).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Playlists'),
        actions: [
          IconButton(
            icon: Icon(themeNotifier.isDarkTheme ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: () {
              themeNotifier.toggleTheme();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _playlists.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_playlists[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicPlayerScreen(song: _playlists[index].songs.first),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPlaylist,
        child: Icon(Icons.add),
      ),
    );
  }
}
